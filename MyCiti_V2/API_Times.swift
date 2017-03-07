//
//  API_Times.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/23/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import Alamofire
import AlamofireSwiftyJSON //now response.result.value is SwiftyJSON.JSON type
import SwiftyJSON

extension API {

	func getTimes(forStop stop: Stop, completion: @escaping ([Time]) -> Void) {
		var times: [Time] = []
		var latestTimeObject: Time? = nil
		var pageCount = 0
		
		func fetchPage() {
			
			if token_oath == nil { print("OAuth token not found"); return }
			let url: URLConvertible = baseUrl + "stops/\(stop.id!)/timetables/"
			let headers = [
				"Accept": "application/json",
				"Authorization" : "Bearer \(token_oath!)"
			]
			let params = [
				"agencies" : "eBTeYLPXOkWm5zyfjZVaZg",
				"offset" : "\(pageCount*100)",
				"latestArrivalTime" : calendar.date(byAdding: .day, value: 1, to: Date())!.formatToActiveRecord
			]
			
			Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.methodDependent , headers: headers).responseSwiftyJSON {
				response in
				if response.response?.statusCode == 200 {
					if response.result.value?.count == 0 {
						completion(times)
					} else {
						if let json = response.result.value {
							for time in json {
								let timeObject = objectCreator.jsonToTime(json: time.1, stop: stop)
								times.append(timeObject)
							}
							pageCount += 1
							fetchPage()
						} else {
							DispatchQueue.main.async(execute: {
								NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotStops"), object: nil)
							})
							completion(times)
						}
					}
                } else {
                    print("ERROR status code = \(response.response?.statusCode)")
                }
			}
		}
		fetchPage()
	}
	
}
