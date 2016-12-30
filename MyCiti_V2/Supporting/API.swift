//
//  API.swift
//  The Force
//
//  Created by Byron Coetsee on 2016/09/01.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit

let api = API()

class API: NSObject {
	
	var token_oath: String?
	let baseUrl = "https://platform.whereismytransport.com/api/"
	
	// Tracking variables
	var internetActive = true
	var gotStops = false
	var gotAlerts = false
	
	let dateNow: Date = Date()
	let calendar: Calendar = Calendar(identifier: .gregorian)
	
	override init() {
		super.init()
	}
}









