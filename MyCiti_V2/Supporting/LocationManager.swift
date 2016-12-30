//
//  LocationManager.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/20/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationManagerNotification: String {
	case locationUpdate = "locationUpdate"
}

var locManager = LocationManager()

class LocationManager: NSObject, CLLocationManagerDelegate {
	
	public var locManager: CLLocationManager!
	
	override init() {
		super.init()
		locManager = CLLocationManager()
		locManager.desiredAccuracy = kCLLocationAccuracyBest
		
		locManager.delegate = self
		
		locManager.requestAlwaysAuthorization()
		locManager.startUpdatingLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
		//
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		postNotification(name: .locationUpdate, information: ["location" : locations.first!])
	}
	
	func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
		//
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		
		switch status {
		case .authorizedAlways:
			locManager.startUpdatingLocation()
			break
		case .authorizedWhenInUse:
			break
		case .denied, .restricted:
			break
		case .notDetermined:
			break
		}
	}
	
	func postNotification(name: LocationManagerNotification, information: [String : Any]) {
		let notifName = NSNotification.Name(rawValue: name.rawValue)
		NotificationCenter.default.post(name: notifName, object: nil, userInfo: information)
	}
}
