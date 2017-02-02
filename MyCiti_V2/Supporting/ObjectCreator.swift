//
//  ObjectCreator.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/11/04.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

let objectCreator = ObjectCreator()

class ObjectCreator: NSObject {

	func jsonToTime(json: JSON, stop: Stop) -> Time {
		let arriveTime = json["arrivalTime"].stringValue.formatFromActiveRecord
		let departTime = json["departureTime"].stringValue.formatFromActiveRecord
		let line = jsonToLine(json: json["line"])
		let time = Time(stop: stop, line: line, arrive: arriveTime, depart: departTime)
		return time
	}
	
	func jsonToLine(json: JSON) -> Line {
		let id = json["id"].stringValue
		let shortName = json["shortName"].stringValue.replacingOccurrences(of: "Route ", with: "")
		let name = json["name"].stringValue
		let mode = Mode.Bus
		let colour = json["colour"].stringValue.UIColourFromHex()
		let textColour = json["textColour"].stringValue.UIColourFromHex()
		
		return Line(id: id, mode: mode, shortName: shortName, name: name, colour: colour, textColour: textColour, agency: global.myciti)
	}
	
	func jsonToStop(json: JSON) -> Stop {
		let id = json["id"].stringValue
		let name = json["name"].stringValue
		let culture = json["agency"]["culture"].stringValue
		let lng = json["geometry"]["coordinates"][0].doubleValue
		let lat = json["geometry"]["coordinates"][1].doubleValue
		
		let newStop = Stop(id: id, name: name, agency: global.myciti, coords: CLLocationCoordinate2DMake(lat, lng), culture: culture)
		return newStop
	}
	
	func jsonToTrip(json: JSON) -> Trip {
		
		let id = json["id"].stringValue
		let depart = json["departureTime"].stringValue.formatFromActiveRecord
		let arrive = json["arrivalTime"].stringValue.formatFromActiveRecord
		let distance = json["distance"].doubleValue
		let duration = json["duration"].doubleValue
		
		var legs: [Leg] = []
		for leg in json["legs"] {
			legs.append(self.jsonToLeg(json: leg.1))
		}
		
		return Trip(id: id, depart: depart, arrive: arrive, distance: distance, duration: duration, legs: legs)
	}
	
	func jsonToLeg(json: JSON) -> Leg {
		let type = LegType(rawValue: json["type"].stringValue)
		let distance = json["distance"]["value"].doubleValue
		let duration = json["duration"].doubleValue
		
		var line: Line?
		if json["line"].exists() {
			line = jsonToLine(json: json["line"])
		}
		
		var waypoints: [Waypoint] = []
		for waypoint in json["waypoints"] {
			waypoints.append(jsonToWaypoint(json: waypoint.1))
		}
		
		var fare: Fare? = nil
		if json["fare"].exists() {
			let description = json["fare"]["description"].stringValue
			
			if json["fare"]["cost"].exists() {
				let cost = json["fare"]["cost"]["amount"].doubleValue.format(f: ".0")
				fare = Fare(description: description, cost: cost)
			} else {
				fare = Fare(description: description, cost: -1)
			}
		}
		
		return Leg(type: type, distance: distance, duration: duration, line: line, waypoints: waypoints, fare: fare)
	}
	
	func jsonToWaypoint(json: JSON) -> Waypoint {
		let arrive = json["arrivalTime"].stringValue.formatFromActiveRecord
		let depart = json["departureTime"].stringValue.formatFromActiveRecord
		
		if json["stop"].exists() {
			return Waypoint(stop: jsonToStop(json: json["stop"]), location: nil, arrive: arrive, depart: depart)
		} else {
			return Waypoint(stop: nil, location: jsonToLocation(json: json["location"]), arrive: arrive, depart: depart)
		}
	}
	
	func jsonToLocation(json: JSON) -> Location {
		let address = json["address"].stringValue
		
		let lat = json["geometry"]["coordinates"][0].doubleValue
		let long = json["geometry"]["coordinates"][1].doubleValue
		
		let coords = CLLocationCoordinate2DMake(lat, long)
		
		return Location(address: address, coords: coords)
	}
	
	func jsonToAlert(heading: String, json:  JSON) -> Alert {
		let body = json["body"].stringValue
		let created = NSDate(timeIntervalSince1970: TimeInterval(json["created"].intValue)) as Date
        
        var clickable: Alert.Clickable? = nil
        
        if json["clickable"].exists() {
            switch json["clickable"]["type"].stringValue {
                
            case "url":
                let content = Alert.Url(url: json["clickable"]["url"].stringValue) as AnyObject
                clickable = Alert.Clickable(type: Alert.ClickableType.url, content: content)
                break
                
            case "email":
                let to = json["clickable"]["to"].stringValue
                let subject = json["clickable"]["to"].stringValue
                let content = Alert.Email(to: to, subject: subject, body: "") as AnyObject
                clickable = Alert.Clickable(type: Alert.ClickableType.email, content: content)
                break
                
            default: break
            }
        }
        
        let condition = json["condition"].stringValue
        return Alert(heading: heading, body: body, created: created, condition: getAlertCondition(condition: condition), clickable: clickable)
	}
    
    func getAlertCondition(condition: String) -> AlertCondition {
        switch condition {
        case "information": return .information
        case "positive": return .positive
        case "notice": return .notice
        case "warning": return .warning
        default: return .information
        }
    }
}
