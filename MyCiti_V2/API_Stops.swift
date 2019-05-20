//
//  API_Stops.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/23/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import Alamofire
import AlamofireSwiftyJSON //now response.result.value is SwiftyJSON.JSON type
import SwiftyJSON

extension API {
	
	func getStops() { getStops(completionHandler: {stops in}) }
    
    /// Gets the stops from the WhereIsMyTransport API.
    ///
    /// - Parameters:
    ///   - point: The default point to search from
    ///   - limit: the record limit
    ///   - completion: the completion handler
    func getStops(point: [Double] = [-33.92543,18.43644], limit: Int = 100, completionHandler completion: @escaping ([Stop]) -> Void) {
		if token_oath == nil { print("OAuth token not found - getStops"); return }
		
		var stops: [Stop] = []
		var pageCount = 0
		
		func fetchPage() {
			
			let url: URLConvertible = baseUrl + "stops/"
			let headers = [
				"Accept": "application/json",
				"Authorization" : "Bearer \(token_oath!)"
			]
            let params: [String:Any] = [
				"agencies" : "5kcfZkKW0ku4Uk-A6j8MFA",
                "limit": limit,
                "point": point,
				"offset" : "\(pageCount*100)"
			]
			
			print("Started getting stops - \(pageCount)")
			Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.methodDependent , headers: headers).responseSwiftyJSON {
				response in
				
				if response.response?.statusCode == 200 {
					if response.result.value?.count == 0 {
						UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "lastStopsUpdate")
						completion(stops)
					} else {
						if let json = response.result.value {
							for stop in json {
								let stopObject = objectCreator.jsonToStop(json: stop.1)
								dataManager.addStop(stop: stopObject)
								stops.append(stopObject)
							}
							pageCount += 1
							fetchPage()
						} else {
							UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "lastStopsUpdate")
							completion(stops)
						}
					}
				}
			}
		}
		fetchPage()
	}
}
