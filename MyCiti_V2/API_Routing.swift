//
//  API_Routing.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/23/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import Alamofire
import AlamofireSwiftyJSON //now response.result.value is SwiftyJSON.JSON type
import SwiftyJSON
import SCLAlertView

extension API {
	func getTrip(from fromStop: Stop, to toStop: Stop, completion: @escaping ((Trip?) -> Void)) {
		
		if token_oath == nil { print("OAuth token not found"); return }
		let url: URLConvertible = baseUrl + "journeys?exclude=directions,geometry,parentStop"
		let headers = [
			"Content-Type": "application/json",
			"Authorization" : "Bearer \(token_oath!)"
		]
		let params: [String : Any] = [
			"profile": "FewestTransfers",
			"geometry": [
				"type": "Multipoint",
				"coordinates": [
					[
						fromStop.coords.longitude,
						fromStop.coords.latitude
					],
					[
						toStop.coords.longitude,
						toStop.coords.latitude
					]
				]
			],
			"time": (Date().add(components: [.hour:-2])).formatToActiveRecord,
			"only": [
				"agencies": [ global.myciti.id ]
			]
		]
		
		
		Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseSwiftyJSON {
			response in
			if response.response?.statusCode == 200 ||  response.response?.statusCode == 201 {
				var index = 0
				var duration: Double = 9999999
				for item in response.result.value!["itineraries"] {
					if item.1["duration"].doubleValue < duration {
						duration = item.1["duration"].doubleValue
						index = Int(item.0)!
					}
				}
				if response.result.value!["itineraries"].count > 0 {
					let trip = objectCreator.jsonToTrip(json: response.result.value!["itineraries"][index])
					completion(trip)
				} else {
					SCLAlertView().showNotice("", subTitle: "Something's not lekker... If this keeps happening, go to the about screen and report it")
					completion(nil)
				}
			}
		}
	}
}
