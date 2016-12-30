//
//  API_Alerts.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/23/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import FirebaseRemoteConfig
import FirebaseDatabase
import SwiftyJSON
import SCLAlertView
import SwiftSortUtils

extension API {
	
	func fetchFirebaseAlerts(completion: @escaping (_ someAlerts : [Alert]) -> Void) {
		global.firebaseDatabase.ref.observe(FIRDataEventType.value, with: {
			snapshot in
			self.gotAlerts = true
			if snapshot.value != nil {
				let alerts = JSON(snapshot.value!)["Alerts"]
				
				var alertsCollection: [Alert] = []
				
				for alert in alerts {
					let alertObject = objectCreator.jsonToAlert(heading: alert.0, json: alert.1)
					
					if !alert.1["ignore"].exists() { alertsCollection.append(alertObject) }
				}
				
				global.alerts = alertsCollection.sorted { $0.created! > $1.created }
				completion(alertsCollection.sorted { $0.created! > $1.created })
			}
		})
	}
}
