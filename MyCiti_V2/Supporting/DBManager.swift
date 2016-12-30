//
//  DBManager.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/14/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import SQLite
import CoreLocation

let db = DBManager()

class DBManager: NSObject {
	
	var dbConn: Connection!
	
	let stops = Table("stops")
	
	override init() {
		super.init()
		let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
		dbConn = try! Connection("\(path)/db.sqlite3")
		createTables()
	}
	
	func getStopsCount() -> Int { return try! dbConn.scalar(stops.count) }
	
	func getStops(completionHandler handler: ([Stop]) -> Void) {
		var stops: [Stop] = []
		for stop in try! dbConn.prepare(Table("stops")) {
			
			let id = stop[Expression<String>("id")]
			let name = stop[Expression<String>("name")]
			let culture = "en"
			let lat = stop[Expression<Double>("lat")]
			let lng = stop[Expression<Double>("long")]
			
			let newStop = Stop(id: id, name: name, agency: global.myciti, coords: CLLocationCoordinate2DMake(lat, lng), culture: culture)
			stops.append(newStop)
		}
		handler(stops)
	}
	
	func addStop(_id: String, _name: String, _culture: String, _agency: String, _lat: Double, _long: Double) {
		let id = Expression<String>("id")
		let name = Expression<String>("name")
		let lat = Expression<Double>("lat")
		let long = Expression<Double>("long")
		let culture = Expression<String>("culture")
		let agency = Expression<String>("agency")
		try! dbConn.run(stops.insert(or: .replace, id <- _id, name <- _name, lat <- _lat, long <- _long, culture <- _culture, agency <- _agency))
	}
}

extension DBManager {
	func createTables() {
		createStops()
	}
	
	func createStops() {
//		try! dbConn.run(stops.drop(ifExists: true))
		
		let id = Expression<String>("id")
		let name = Expression<String>("name")
		let agency = Expression<String>("agency")
		let lat = Expression<Double>("lat")
		let long = Expression<Double>("long")
		let culture = Expression<String>("culture")
		
		try! dbConn.run(stops.create(ifNotExists: true) {
			t in
			t.column(id, primaryKey: true)
			t.column(name, unique: false)
			t.column(agency, unique: false)
			t.column(lat)
			t.column(long)
			t.column(culture)
		})
	}
}
