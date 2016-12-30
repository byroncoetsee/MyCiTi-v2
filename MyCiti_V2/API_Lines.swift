//
//  API_Lines.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/23/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import Alamofire
import AlamofireSwiftyJSON //now response.result.value is SwiftyJSON.JSON type
import SwiftyJSON

extension API {
	
	func getLines(forStop stop : String?) -> [Line] {
		if token_oath == nil { print("OAuth token not found"); return [] }
		var lines : [Line] = []
		let url: URLConvertible = baseUrl + "lines"
		let headers = [
			"Accept": "application/json",
			"Authorization" : "Bearer \(token_oath!)"
		]
		let params = [
			"servesStops" : "eBTeYLPXOkWm5zyfjZVaZg"
		]
		
		Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.httpBody , headers: headers).responseSwiftyJSON {
			response in
			print(response)
			if response.result.value?.count == 0 { return } // End of list
			if let json = response.result.value {
				for line in json {
					let id = line.1["id"].stringValue
					let name = line.1["name"].stringValue
					let shortName = line.1["shortName"].stringValue
					let colour = line.1["colour"].stringValue.UIColourFromHex()
					let textColour = line.1["textColour"].stringValue.UIColourFromHex()
					let mode = Mode.Bus
					
					let newLine = Line(id: id, mode: mode, shortName: shortName, name: name, colour: colour, textColour: textColour, agency: nil)
					lines.append(newLine)
				}
			}
		}
		print("\(lines.count) line serving this stop")
		return lines
	}

}
