//
//  RouteLeg_Cell.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/14/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftDate

class RouteLeg_Cell: UITableViewCell {
	
	@IBOutlet weak var lblRouteNumber: UILabel!
	@IBOutlet weak var lblBoard: UILabel!
	@IBOutlet weak var lblAlight: UILabel!
	@IBOutlet weak var lblStops: UILabel!
	@IBOutlet weak var lblTime: UILabel!
	@IBOutlet weak var lblFare: UILabel!
	
	// Design controls
	@IBOutlet weak var viewCard: UIView!
	@IBOutlet weak var viewDotTop: UIView!
	@IBOutlet weak var viewDotBottom: UIView!
	@IBOutlet weak var viewBar: UIView!
	
	
	var leg: Leg!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		backgroundColor = UIColor.clear
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowRadius = 5
		layer.shadowOpacity = 0.5
	}
	
	func setup(leg: Leg) {
		self.leg = leg
		
		let firstWaypoint = leg.waypoints.first
		let lastWaypoint = leg.waypoints.last
		
		if firstWaypoint?.stop != nil { lblBoard.text = firstWaypoint!.stop!.name }
		if firstWaypoint?.location != nil { lblBoard.text = firstWaypoint!.location!.address }
		if lastWaypoint?.stop != nil { lblAlight.text = lastWaypoint!.stop!.name }
		if lastWaypoint?.location != nil { lblAlight.text = lastWaypoint!.location!.address }
		
		if firstWaypoint?.depart != nil {
			lblTime.text = firstWaypoint!.depart.string(custom: "HH:mm a")
		} else {
			lblTime.text = ""
		}
		
		if leg.type == .transit {
			lblStops.text = "\(leg.waypoints.count)"
		} else if leg.type == .walking {
            if leg.distance < 1000 {
				lblStops.text = "\(round(leg.distance!.format(f: ".0"))) m"
			} else {
				lblStops.text = "\(round(leg.distance!/1000).format(f: ".1")) km"
			}
		}
		
		if leg.fare != nil {
			if leg.fare?.cost == -1 {
				lblFare.text = leg.fare!.description!
			} else {
				lblFare.text = "R \(leg.fare!.cost!)"
			}
		} else {
			lblFare.text = "Walking is still free"
		}
		
		setupDesigns()
	}
}


// Design stuff



extension RouteLeg_Cell {
	func setupDesigns() {
		setupCard()
		setupDots()
		setupBar()
		setupStopCount()
		setupRouteNumber()
	}
	
	func setupCard() {
		viewCard.layer.cornerRadius = 10
		viewCard.clipsToBounds = true
	}
	
	func setupDots() {
		for dot in [viewDotTop, viewDotBottom] {
			dot!.layer.cornerRadius = dot!.frame.height/2
			dot!.clipsToBounds = true
			dot!.layer.borderColor = leg.line?.colour.cgColor
			dot!.layer.borderWidth = 2
			dot!.backgroundColor = UIColor.white
		}
	}
	
	func setupBar() {
		if leg.type == .walking {
			viewBar.backgroundColor = UIColor.black
		} else {
			viewBar.backgroundColor = leg.line?.colour
		}
	}
	
	func setupStopCount() {
		if leg.type == .transit {
			lblStops.layer.cornerRadius = lblStops.frame.height/2
			lblStops.clipsToBounds = true
			lblStops.layer.borderColor = leg.line?.colour.cgColor
			lblStops.layer.borderWidth = 2
			lblStops.textColor = leg.line?.colour
			lblStops.backgroundColor = UIColor.white
		} else {
			lblStops.layer.borderWidth = 0
			lblStops.textColor = UIColor.black
			lblStops.backgroundColor = UIColor.white
		}
	}
	
	func setupRouteNumber() {
		lblRouteNumber.layer.cornerRadius = lblRouteNumber.frame.height/2
		lblRouteNumber.clipsToBounds = true
		if leg.line != nil {
			lblRouteNumber.text = leg.line!.shortName
			lblRouteNumber.textColor = leg.line!.textColour
			lblRouteNumber.backgroundColor = leg.line?.colour
			lblRouteNumber.layer.borderWidth = 0
		} else {
			lblRouteNumber.text = "walk"
			lblRouteNumber.textColor = UIColor.black
			lblRouteNumber.backgroundColor = UIColor.white
			lblRouteNumber.layer.borderColor = leg.line?.colour.cgColor
			lblRouteNumber.layer.borderWidth = 2
		}
	}
}





