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

class About_VC: UIViewController {
	
	@IBOutlet weak var viewInformation: UIScrollView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		view.backgroundColor = UIColor.init(gradientStyle: .radial, withFrame: view.frame, andColors: [UIColor.flatRedColorDark(), UIColor.flatRedColorDark().darken(byPercentage: 0.3)])
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		viewInformation.contentSize = CGSize(width: viewInformation.frame.size.width, height: 1220)
	}
	
	@IBAction func openWIMT(_ sender: Any) {
		UIApplication.shared.openURL(NSURL(string: "http://www.whereismytransport.com")! as URL)
	}
	
	@IBAction func openInstagram(_ sender: Any) {
		UIApplication.shared.openURL(NSURL(string: "instagram://user?username=byroncoetsee")! as URL)
	}
	
	override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
