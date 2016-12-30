//
//  Alert_Cell.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/25/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit

class Alert_Cell: UITableViewCell {

	@IBOutlet weak var viewContainer: UIView!
	@IBOutlet weak var lblHeading: UILabel!
	@IBOutlet weak var lblBody: UILabel!
	@IBOutlet weak var viewColour: UIView!
	@IBOutlet weak var imgIcon: UIImageView!
	@IBOutlet weak var lblDate: UILabel!
	
	var alert: Alert!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = UIColor.clear
    }
	
	func setup(alert: Alert) {
		self.alert = alert
		
        if alert.created != (NSDate(timeIntervalSince1970: 0.0) as Date) {
            lblDate.text = alert.created.string(custom: "dd MMM, HH:ss a")
        } else {
            lblDate.text = "Now"
        }
		lblHeading.text = alert.heading
		lblBody.text = alert.body
		
		switch alert.condition! {
		case .information:
			viewColour.backgroundColor = UIColor.flatSkyBlue()
			imgIcon.image = UIImage(named: "information")
			break
		case .positive:
			viewColour.backgroundColor = UIColor.flatGreen()
			imgIcon.image = UIImage(named: "checked")
			break
		case .notice:
			viewColour.backgroundColor = UIColor.flatYellowColorDark()
			imgIcon.image = UIImage(named: "notice")
			break
		case .warning:
			viewColour.backgroundColor = UIColor.flatRed()
			imgIcon.image = UIImage(named: "cross")
			break
		}
		
		addAppearances()
	}
	
	func addAppearances() {
//		let shadowView = UIView(frame: viewContainer.frame)
		backgroundColor = UIColor.clear
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 5
//		insertSubview(shadowView, belowSubview: viewContainer)
		
		viewContainer.layer.cornerRadius = 10
		viewContainer.clipsToBounds = true
	}
}
