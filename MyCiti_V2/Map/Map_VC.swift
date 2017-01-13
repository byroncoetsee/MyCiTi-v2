//
//  Map_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/09/17.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import Mapbox
import FirebaseCrash

class Map_VC: Sub_UIViewController, MGLMapViewDelegate {
	
	@IBOutlet weak var map: MGLMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		map.delegate = self
		map.showsUserLocation = true
		map.isRotateEnabled = false
		view.addSubview(map)
		
		populateStops()
		NotificationCenter.default.addObserver(self, selector: #selector(populateStops), name: NSNotification.Name(rawValue: "gotStops"), object: nil)
	}
    
    override func viewWillAppear(_ animated: Bool) {
        hideNavigationBar()
    }
	
	override func viewDidAppear(_ animated: Bool) {
        if locManager.locManager.location != nil {
            zoomToUser()
        } else {
            map.setCenter(CLLocationCoordinate2DMake(-33.792583, 18.545604), zoomLevel: 9, animated: false)
            let notificationName = NSNotification.Name(rawValue: LocationManagerNotification.locationUpdate.rawValue)
            NotificationCenter.default.addObserver(self, selector: #selector(zoomToUser), name: notificationName, object: nil)
        }
	}
	
	func populateStops() {
		for stop in global.stopList {
			let pin = Sub_MGLPointAnnotation(stop: stop)
			self.map.addAnnotation(pin)
		}
	}
    
    func zoomToUser() {
        if locManager.locManager.location != nil {
            map.setCenter(locManager.locManager.location!.coordinate, zoomLevel: 15, animated: true)
        }
    }
	
	func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool { return true }
	func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        FIRCrashMessage((annotation as! Sub_MGLPointAnnotation).stop.name)
		let vc = self.storyboard?.instantiateViewController(withIdentifier: "times_vc") as! Times_VC
		vc.stop = (annotation as! Sub_MGLPointAnnotation).stop
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
