//
//  About_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/20/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import FirebaseRemoteConfig
import SCLAlertView
import FirebaseAnalytics

class About_VC: UIViewController {
	
	@IBOutlet weak var viewInformation: UIScrollView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        view.backgroundColor = UIColor.init(gradientStyle: .radial, withFrame: view.frame, andColors: [UIColor.flatRed, UIColor.flatRed.darken(byPercentage: 0.3)!])
        
        FIRAnalytics.logEvent(withName: "viewed_about", parameters: nil)
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		viewInformation.contentSize = CGSize(width: viewInformation.frame.size.width, height: 1220)
	}
	
	@IBAction func openWIMT(_ sender: Any) {
        FIRAnalytics.logEvent(withName: "opened_WIMT", parameters: nil)
		UIApplication.shared.openURL(NSURL(string: "http://www.whereismytransport.com")! as URL)
	}
	
	@IBAction func openInstagram(_ sender: Any) {
        FIRAnalytics.logEvent(withName: "opened_instagram", parameters: nil)
		UIApplication.shared.openURL(NSURL(string: "instagram://user?username=byroncoetsee")! as URL)
	}
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
