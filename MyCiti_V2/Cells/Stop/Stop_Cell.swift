//
//  Stop_Cell.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/11/03.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation

class Stop_Cell: UITableViewCell {
	
	var stop: Stop!

	@IBOutlet weak var lblName: UILabel!
	@IBOutlet weak var lblAgency: UILabel!
	@IBOutlet weak var lblIcon: UILabel!
	@IBOutlet weak var lblDistance: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func setup(stop: Stop) {
		self.stop = stop
		
		lblName.text = stop.name
		lblAgency.text = stop.agency.name
		
		if locManager.locManager.location != nil {
			let stopLocation = CLLocation(latitude: stop.coords.latitude, longitude: stop.coords.longitude)
			let distance = (locManager.locManager.location!.distance(from: stopLocation)/1000).format(f: "0.1")
			lblDistance.text = "\(distance) km"
		} else {
			lblDistance.text = ""
		}
		
		backgroundColor = UIColor.clear
	}
}
