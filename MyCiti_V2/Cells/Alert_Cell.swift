//
//  Alert_Cell.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/25/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import RSEmailFeedback
import SCLAlertView

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
            lblDate.text = alert.created.toString(.custom("dd MMM, HH:ss a"))
        } else {
            lblDate.text = "Now"
        }
		lblHeading.text = alert.heading
		lblBody.text = alert.body
		
		switch alert.condition! {
		case .information:
            viewColour.backgroundColor = UIColor.flatSkyBlue
			imgIcon.image = UIImage(named: "information")
			break
		case .positive:
            viewColour.backgroundColor = UIColor.flatGreen
			imgIcon.image = UIImage(named: "checked")
			break
		case .notice:
            viewColour.backgroundColor = UIColor.flatYellowDark
			imgIcon.image = UIImage(named: "notice")
			break
		case .warning:
            viewColour.backgroundColor = UIColor.flatRed
			imgIcon.image = UIImage(named: "cross")
			break
		}
        
        self.selectionStyle = .none
        
		addAppearances()
	}
	
	func addAppearances() {
		backgroundColor = UIColor.clear
		layer.shadowOffset = CGSize(width: 0, height: 0)
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 5
		
		viewContainer.layer.cornerRadius = 10
		viewContainer.clipsToBounds = true
	}
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        print("SELECTED CELL")
        
        if selected {
            if alert.clickable != nil {
                Analytics.logEvent("clicked_alert", parameters: [
                    "name": alert.heading as NSObject
                    ])
                
                switch alert.clickable!.type {
                case .url: url()
                    break
                    
                case .email: email()
                    break
                    
                default: break
                }
            }
        }
    }
    
    func url() {
        let urlString = (alert.clickable!.content as! Alert.Url).url
        if let url = URL(string: urlString) {
            UIApplication.shared.openURL(url)
        }
    }
    
    func email() {
        let emailFeedback = RSEmailFeedback()
        emailFeedback.toRecipients = ["byroncoetsee@gmail.com"]
        emailFeedback.subject = "MyCiti app feedback"
        
        let vc = (UIApplication.shared.delegate as! AppDelegate).activeViewController
        emailFeedback.show(on: vc, withCompletionHandler: {
            result, error in
            
            if error == nil {
                switch result {
                case MFMailComposeResult.sent:
                    SCLAlertView().showSuccess("Thanks!", subTitle: "Thank you for the feedback - it's what keeps the app working :)")
                    break
                default:
                    break
                }
            } else {
                print(error)
                switch error! {
                case MFMailComposeError.sendFailed:
                    SCLAlertView().showError("Sending failed", subTitle: "Double check you have setup your email correctly and have an active internet connection")
                    break
                default:
                    SCLAlertView().showError("Hmm", subTitle: error!.localizedDescription)
                    break
                }
            }
        })
    }
}
