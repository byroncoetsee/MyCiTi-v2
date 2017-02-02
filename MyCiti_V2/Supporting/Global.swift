//
//  Global.swift
//  The Force
//
//  Created by Byron Coetsee on 2016/09/01.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import ChameleonFramework
import CoreLocation
import FirebaseRemoteConfig
import FirebaseDatabase
import FirebaseAnalytics

let global = Global()

enum AlertCondition {
	case information
	case positive
	case notice
	case warning
}

enum Mode {
	case Bus
	case Train
}

enum LegType: String {
	case walking = "Walking"
	case transit = "Transit"
}

struct Alert {
    
    struct Clickable {
        let type: ClickableType
        let content: AnyObject
    }
    
    enum ClickableType {
        case url
        case email
        case none
    }
    
    struct Url {
        let url: String
    }
    
    struct Email {
        let to: String
        let subject: String
        let body: String
    }
    
	let heading: String!
	let body: String!
	let created: Date!
	let condition: AlertCondition!
    let clickable: Clickable?
//    let clickableType: ClickableType!
//    let clickableContent: AnyObject! = nil
}

struct Agency {
	let id: String!
	let name: String!
	let culture: String!
}

struct Line {
	let id: String!
	let mode: Mode!
	let shortName: String!
	let name: String!
	let colour: UIColor!
	let textColour: UIColor!
	let agency: Agency?
}

struct Stop: Equatable {
	let id: String!
	let name: String!
	let agency: Agency!
	let coords: CLLocationCoordinate2D!
	let culture: String!
	
	static func ==(lhs: Stop, rhs: Stop) -> Bool {
		return lhs.id == rhs.id
	}
}

struct Time: Equatable {
	let stop: Stop!
	let line: Line!
	let arrive: Date!
	let depart: Date
	
	static func ==(lhs: Time, rhs: Time) -> Bool {
		return lhs.line.id == rhs.line.id && lhs.arrive == rhs.arrive
	}
}

struct Trip {
	let id: String!
	let depart: Date!
	let arrive: Date!
	let distance: Double!
	let duration: Double!
	let legs: [Leg]!
}

struct Leg {
	let type: LegType!
	let distance: Double!
	let duration: Double!
	let line: Line?
	let waypoints: [Waypoint]!
	let fare: Fare?
}

struct Waypoint {
	let stop: Stop?
	let location: Location?
	let arrive: Date!
	let depart: Date!
}

struct Location {
	let address: String!
	let coords: CLLocationCoordinate2D!
}

struct Fare {
	let description: String?
	let cost: Double!
}

// let stringColour = (line.1["colour"].stringValue).replacingOccurrences(of: "#", with: "")
// let colour = UIColor.init(argb: UInt(stringColour, radix: 16)!)
extension UIColor {
	convenience init(argb: UInt) {
		self.init(
			red: CGFloat((argb & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((argb & 0x00FF00) >> 8) / 255.0,
			blue: CGFloat(argb & 0x0000FF) / 255.0,
			alpha: CGFloat((argb & 0xFF000000) >> 24) / 255.0
		)
	}
}

extension Date {
	struct DateToRuby {
		static let formatToActiveRecord: DateFormatter = {
			let formatter = DateFormatter()
			formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601) as Calendar!
			formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
			formatter.timeZone = NSTimeZone.local //(forSecondsFromGMT: 0) as TimeZone!
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
			return formatter
		}()
	}
	var formatToActiveRecord: String { return "\(DateToRuby.formatToActiveRecord.string(from: self as Date))Z" }
}

extension String {
	struct DateFromRuby {
		static let formatFromActiveRecord: DateFormatter = {
			let formatter = DateFormatter()
			formatter.calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.ISO8601) as Calendar!
			formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
			formatter.timeZone = NSTimeZone.local //(forSecondsFromGMT: 0) as TimeZone!
			formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
			return formatter
		}()
	}
	var formatFromActiveRecord: Date { return DateFromRuby.formatFromActiveRecord.date(from: self)! as Date }
	
	func UIColourFromHex() -> UIColor {
		let stringColour = (self).replacingOccurrences(of: "#", with: "")
		let colour = UIColor.init(argb: UInt(stringColour, radix: 16)!)
		return colour
	}
}

extension UIView {
	
	@IBInspectable var shadow: Bool {
		get { return layer.shadowOpacity > 0.0 }
		set {
			if newValue == true {
				self.addShadow()
			}
		}
	}	
	
	func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
	               shadowOffset: CGSize = CGSize(width: 1.0, height: 2.0),
	               shadowOpacity: Float = 0.4,
	               shadowRadius: CGFloat = 3.0) {
		layer.shadowColor = shadowColor
		layer.shadowOffset = shadowOffset
		layer.shadowOpacity = shadowOpacity
		layer.shadowRadius = shadowRadius
	}
	
	func hide(animated: Bool) {
		let duration = (animated == true) ? 1.0 : 0.0
		UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
			self.alpha = 0
		}, completion: {_ in
			self.isHidden = true
		})
	}
	
	func unhide(animated: Bool) {
		let duration = (animated == true) ? 1.0 : 0.0
		UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut, animations: {
			self.alpha = 1
		}, completion: {_ in
			self.isHidden = false
		})
	}
}

extension Double {
	func format(f: String) -> Double {
		return Double(String(format: "%\(f)f", self))!
	}
}

class Global: NSObject {
	
	var firebaseConfig = FIRRemoteConfig.remoteConfig()
	var firebaseDatabase = FIRDatabase.database().reference()
	
	let myciti = Agency(id: "5kcfZkKW0ku4Uk-A6j8MFA", name: "MyCiTi", culture: "en")
	
	var alerts: [Alert] = []
	
	var stopList : [Stop] = []
	
	let theme_mainColour = UIColor(hexString: "B1E67B") //UIColor.randomFlatColor()
	let theme_textColour: UIColor!
	
	override init() {
		theme_textColour = theme_mainColour?.darken(byPercentage: 0.3)
	}
    
    func firebaseEvent(name: String, params: [String : NSObject]) {
        #if DEBUG
        #else
            FIRAnalytics.logEvent(withName: name, parameters: params)
        #endif
    }
}
