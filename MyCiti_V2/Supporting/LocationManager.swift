//
//  LocationManager.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/20/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseAnalytics

enum LocationManagerNotification: String {
	case locationUpdate = "locationUpdate"
}

var locManager = LocationManager()

struct Geotification {
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String
    var eventType: GeoState
}

enum GeoState {
    case onEntry
    case onExit
}

/// Log the event to Firebase for analytics purposes
///
/// - Parameters:
///   - eventName: the event name to log
///   - params: the parameters to add to the log
public func logEvent(eventName:String, params: [String:Any]? = nil) {
    Analytics.logEvent(eventName, parameters: params as? [String : NSObject])
}

class LocationManager: NSObject, CLLocationManagerDelegate {
	
	public var locManager: CLLocationManager!
	
	override init() {
		super.init()
		locManager = CLLocationManager()
		locManager.desiredAccuracy = kCLLocationAccuracyBest
		
		locManager.delegate = self
		
		locManager.requestAlwaysAuthorization()
		locManager.startUpdatingLocation()
        
        self.preloadGeofencingAreas()
	}
	
    // In order to do station stop logging, need to test the transmission of the data
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        logEvent(eventName: "enter_region", params: ["region": region.identifier])
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        logEvent(eventName: "exit_region", params: ["region": region.identifier])
        self.stopMonitoring(region: region)
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        
        let clError = error as! CLError
        var eventParams: [String:Any] = [
            "region": region?.identifier,
            "errorCode": clError.code
        ]
        
        // https://developer.apple.com/documentation/corelocation/clerror/code
        switch clError.code {
        case .locationUnknown: // Unable to acquire a location the right way
            eventParams["message"] = "location unknown"
            break
        case .denied:   // Location service disabled or denied
            eventParams["message"] = "location service denied"
            break
        case .network: // Network unavailable
            eventParams["message"] = "network unavailable"
            break
        case .deferredFailed: // Didn't enter a proper deferred state
            eventParams["message"] = "Didn't enter a proper deferred state"
            break
        case .regionMonitoringDenied, // monitor denied
             .regionMonitoringFailure,// region cannot be monitored (5)
             .regionMonitoringSetupDelayed,
             .regionMonitoringResponseDelayed:
            eventParams["message"] = "Monitoring failure"
            if let clregion = region {
                // stop the monitoring
                self.stopMonitoring(region: clregion)
            }
            break
        case .rangingFailure: // range failure
            eventParams["message"] = "Range failure"
            break
        case .geocodeCanceled, // geocoding was cancelled
            .geocodeFoundNoResult,
            .geocodeFoundPartialResult:
            eventParams["message"] = "Geocoding failure"
            if let clregion = region {
                // stop the monitoring
                self.stopMonitoring(region: clregion)
            }
            break
        default:
            eventParams["message"] = clError.localizedDescription
            break
        }
        logEvent(eventName: "geo_error", params: eventParams)
    }
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		postNotification(name: .locationUpdate, information: ["location" : locations.first!])
        // Save the last location
        if let first = locations.first {
            UserDefaults.standard.set(first.coordinate.longitude, forKey: "saved_longitude")
            UserDefaults.standard.set(first.coordinate.latitude, forKey: "saved_latitude")
        }
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		switch status {
		case .authorizedAlways:
			locManager.startUpdatingLocation()
			break
		case .authorizedWhenInUse:
            locManager.startUpdatingLocation()
			break
		case .denied, .restricted:
			break
		case .notDetermined:
			break
        @unknown default:
            break
        }
	}
	
	func postNotification(name: LocationManagerNotification, information: [String : Any]) {
		let notifName = NSNotification.Name(rawValue: name.rawValue)
		NotificationCenter.default.post(name: notifName, object: nil, userInfo: information)
	}
    
    private func preloadGeofencingAreas () {
        // Extract the location from the user default storage
        let longitude = UserDefaults.standard.double(forKey: "saved_longitude")
        let latitude = UserDefaults.standard.double(forKey: "saved_latitude")
        // Don't continue processing if the longitude and the latitude cannot be determined
        if longitude == 0.0 || latitude == 0.0 {
            return
        }
        let point = [latitude, longitude]
        var limit = 10
        #if debug
        limit = 5
        #endif
        api.getStops(point: point, limit: limit) { (stops) in
            stops.forEach({ (stop) in
                let geotification = Geotification(coordinate: stop.coords,
                    radius: 200, identifier: stop.id, eventType: .onEntry)
                self.startMonitoring(geotification: geotification)
            })
        }
    }
    
    func region(with geotification: Geotification) -> CLCircularRegion {
        let region = CLCircularRegion(center: geotification.coordinate,
                                      radius: geotification.radius,
                                      identifier: geotification.identifier)
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = region.notifyOnEntry
        return region
    }
    
    func startMonitoring(geotification: Geotification) {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            return
        }
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            // Logs here
        }
        let fenceRegion = region(with: geotification)
        locManager.startMonitoring(for: fenceRegion)
    }
    
    func stopMonitoring(geotification: Geotification) {
        for region in locManager.monitoredRegions {
            guard
                let circularRegion = region as? CLCircularRegion,
                circularRegion.identifier == geotification.identifier
            else { continue }
            locManager.stopMonitoring(for: circularRegion)
        }
    }
    
    func stopMonitoring(region: CLRegion) {
        let firstRegion = locManager.monitoredRegions
            .first { (current) -> Bool in
            return current.identifier == region.identifier
        }
        if firstRegion != nil {
            locManager.stopMonitoring(for: firstRegion!)
        }
    }
}
