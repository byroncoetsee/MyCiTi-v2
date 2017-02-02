//
//  Time_Cell.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/11/03.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import SwiftDate
import ChameleonFramework

class Time_Cell: UITableViewCell {
	
	var time: Time!

	@IBOutlet weak var lblTime: UILabel!
	@IBOutlet weak var lblRemaining: UILabel!
	@IBOutlet weak var lblLine: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }
	
	func setup(time: Time) {
		self.time = time
		
		let diff = (Date() - time.depart).in([.hour,.minute])
		let hours = diff[.hour]
		let mins = diff[.minute]
		
		if hours != nil && hours! > 0 {
			lblRemaining.text = "\(hours!) hours \(mins!) minutes"
		} else {
            if mins! == 0 {
                lblRemaining.text = "Now"
            } else {
                lblRemaining.text = (mins == 1) ? "\(mins!) minute" : "\(mins!) minutes"
            }
		}
		
		lblTime.text = time.depart.string(dateStyle: .none, timeStyle: .short)
		lblLine.text = time.line.shortName.replacingOccurrences(of: "Route ", with: "")
		lblLine.backgroundColor = time.line.colour.flatten()
		lblLine.textColor = UIColor(contrastingBlackOrWhiteColorOn: time.line.textColour, isFlat: true)
		
		layoutViews()
	}
	
	func layoutViews() {
		backgroundColor = UIColor.clear
		lblLine.layer.cornerRadius = lblLine.frame.size.height/2
		lblLine.clipsToBounds = true
	}
}
