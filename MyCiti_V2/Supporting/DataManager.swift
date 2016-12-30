//
//  DataManager.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/14/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

// READ ME
// This class should be the only one to interact with the DB Manager but should not contain any DB class related things. eg. Expressions, Tables etc

import UIKit

let dataManager = DataManager()

class DataManager: NSObject {
	
	override init() {
		super.init()
	}
}

// Alerts
extension DataManager {
	
}

// Stops
extension DataManager {
	func stopsCount() -> Int { return db.getStopsCount() }
	
	func getStops() { getStops(completionHandler: { stops in }) }
	
	func getStops(completionHandler handler: @escaping ([Stop]) -> Void) {
		if db.getStopsCount() > 0 {
			db.getStops(completionHandler: {
				stops in
				global.stopList = stops
				DispatchQueue.main.async(execute: {
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotStops"), object: nil)
				})
				handler(stops)
			})
		} else {
			api.getStops(completionHandler: {
				stops in
				global.stopList = stops
				DispatchQueue.main.async(execute: {
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotStops"), object: nil)
				})
				handler(stops)
			})
		}
	}
	
	func updateStops() {
		if let lastStopsUpdate = UserDefaults.standard.object(forKey: "lastStopsUpdate") as? Double {
			if Date().timeIntervalSince1970 - lastStopsUpdate > 86400 {
				api.getStops()
			}
		} else {
			api.getStops()
		}
	}
	
	func addStop(stop: Stop) {
		let id = stop.id
		let name = stop.name
		let lat = stop.coords.latitude
		let long = stop.coords.longitude
		let culture = stop.culture
		let agency = stop.agency.id
		db.addStop(_id: id!, _name: name!, _culture: culture!, _agency: agency!, _lat: lat, _long: long)
	}
}
