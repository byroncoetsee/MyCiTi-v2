//
//  API_OAuth.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/23/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import Alamofire
import AlamofireSwiftyJSON //now response.result.value is SwiftyJSON.JSON type
import SwiftyJSON

extension API {
	func getToken() {
		let url: URL = NSURL(string: "https://identity.whereismytransport.com/connect/token")! as URL
		let headers = [ "Accept": "application/json" ]
		
		let postData = NSMutableData(data: "client_id=d92b3377-2226-46e9-8e39-8fa1246b1ba8".data(using: String.Encoding.utf8)!)
		postData.append("&client_secret=hzgdKnJKyYGFyKqkh2%2F%2BJSnZO11sdyNhxnJUU8GR9uQ%3D".data(using: String.Encoding.utf8)!)
		postData.append("&grant_type=client_credentials".data(using: String.Encoding.utf8)!)
		postData.append("&scope=transportapi%3Aall".data(using: String.Encoding.utf8)!)
		
		let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = headers
		request.httpBody = postData as Data
		
		let session = URLSession.shared
		let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
			if (error != nil) {
				print("Token error... Retrying...\n\(error as Any)")
				self.getToken()
			} else {
				guard let token = try! JSON(data: data!)["access_token"].string else { return }
				self.token_oath = token
				DispatchQueue.main.async(execute: {
					NotificationCenter.default.post(name: NSNotification.Name(rawValue: "gotOAuthToken"), object: nil)
					dataManager.getStops()
				})
			}
		})
		dataTask.resume()
	}
}
