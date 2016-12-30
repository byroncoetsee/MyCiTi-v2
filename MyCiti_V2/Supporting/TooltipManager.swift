//
//  TooltipManager.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/20/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit

let tooltipManager = TooltipManager()

enum Screen {
	// Main menu
	case Main
	
	// Routing and Trips
	case RouteCell
	case RouteMain
}

class TooltipManager: NSObject {
	
	func isFirstTime(forScreen screen: Screen) -> Bool {
		
		switch screen {
		case .RouteCell: return !fetchStatus(identifier: "routeCell")
		case .RouteMain: return !fetchStatus(identifier: "routeMain")
		case .Main: return !fetchStatus(identifier: "main")
		}
	}
	
	// True = showen before. False = never been showen
	private func fetchStatus(identifier: String) -> Bool {
		if let status = UserDefaults.standard.object(forKey: identifier) as? Bool {
			return status
		} else {
			return false
		}
	}

}
