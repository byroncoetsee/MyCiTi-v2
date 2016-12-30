//
//  Main_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/09/17.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import ChameleonFramework
import SCLAlertView
import BadgeSwift

class Main_VC: Sub_UIViewController {
	
	@IBOutlet weak var lblHeading: UILabel!
	@IBOutlet weak var imgLogo: UIImageView!
	@IBOutlet weak var viewButtonContainer: UIView!
	@IBOutlet weak var btnRoutePlanner: Sub_UIButton!
	@IBOutlet weak var btnMap: Sub_UIButton!
	@IBOutlet weak var btnTimes: Sub_UIButton!
	@IBOutlet weak var btnAnnoun: Sub_UIButton!
	@IBOutlet weak var spinnerAnnoun: UIActivityIndicatorView!

    override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = UIColor.init(gradientStyle: .radial, withFrame: view.frame, andColors: [UIColor.flatBlueColorDark(), UIColor.flatBlackColorDark().darken(byPercentage: 0.3)])
		
		btnRoutePlanner.isHidden = true
		btnTimes.isHidden = true
		NotificationCenter.default.addObserver(self, selector: #selector(gotStops), name: NSNotification.Name(rawValue: "gotStops"), object: nil)
		
		if global.stopList.count == 0 {
			viewButtonContainer.alpha = 0
			viewButtonContainer.isHidden = true
		}
		btnAnnoun.alpha = 0
		btnAnnoun.isHidden = true
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		applyViewAppearances()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		hideNavigationBar()
		loadAlerts()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		if global.stopList.count == 0 {
			showLoading(cancelButton: false)
		}
		fetchInformation()
	}
	
	func applyViewAppearances() {
		applyButtonDesigns(button: btnMap)
		applyButtonDesigns(button: btnTimes)
		applyButtonDesigns(button: btnAnnoun)
		applyButtonDesigns(button: btnRoutePlanner)
	}
	
	@IBAction func showRouting(_ sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "routing_vc") as! Routing_VC
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
	@IBAction func showMap(_ sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "map_vc") as! Map_VC
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
	@IBAction func showTimes(_ sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "stops_vc") as! Stops_VC
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
	@IBAction func showAlerts(_ sender: Any) {
		UserDefaults.standard.setValue(Date().formatToActiveRecord, forKey: "lastAlertsViewed")
		UserDefaults.standard.synchronize()
		
		if global.alerts.count == 0 {
			SCLAlertView().showSuccess("Looks good", subTitle: "Everything seems to be opperating as it should :)")
			return
		} else {
			loadAlerts()
			let vc = storyboard?.instantiateViewController(withIdentifier: "alerts_vc") as! Alerts_VC
			self.navigationController?.pushViewController(vc, animated: false)
		}
	}
	
	@IBAction func showAbout(_ sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "about_vc") as! About_VC
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
	func loadAlerts() {
		spinnerAnnoun.startAnimating()
		let lastAlertsViewed = (UserDefaults.standard.object(forKey: "lastAlertsViewed") as? String)?.formatFromActiveRecord
		
		api.fetchFirebaseAlerts(completion: {
			alerts in
			var newAlertsCount = 0
			
			for alert in alerts {
                if lastAlertsViewed == nil
                    || alert.created > lastAlertsViewed!
                    || alert.created == (NSDate(timeIntervalSince1970: 0.0) as Date)
                    && alert.created > Date().add(components: [Calendar.Component.day:-3])
                {
					newAlertsCount += 1
				}
			}
			self.spinnerAnnoun.stopAnimating()
			self.btnAnnoun.fadeIn()
			
			if newAlertsCount > 0 {
				self.btnAnnoun.addBadge(text: "\(newAlertsCount)")
			} else {
				self.btnAnnoun.removeBadge()
			}
		})
	}
	
	func gotAnnouncments() {
		spinnerAnnoun.stopAnimating()
	}
	
	func gotStops() {
		NotificationCenter.default.removeObserver(self)
		btnRoutePlanner.isHidden = false
		btnTimes.isHidden = false
		hideLoading()
		fadeButtons(fadeIn: true)
	}
	
	func applyButtonDesigns(button: Sub_UIButton) {
		button.layer.shadowOffset = CGSize(width: 0, height: 0)
		button.layer.shadowOpacity = 1
		button.layer.shadowRadius = 4
	}
	
	func fadeButtons(fadeIn: Bool) {
		UIView.animate(withDuration: 1, animations: {_ in
			self.viewButtonContainer.alpha = (fadeIn == true) ? 1 : 0
			self.viewButtonContainer.isHidden = !fadeIn
		})
	}
	
	func fetchInformation() {
		global.firebaseConfig.fetch(completionHandler: {_, _ in
			global.firebaseConfig.activateFetched()
			
			// App Version
			if global.firebaseConfig.configValue(forKey: "appVersion").stringValue != nil {
				
				var currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
				currentVersion = currentVersion.replacingOccurrences(of: ".", with: "")
				
				var latestVersion = global.firebaseConfig.configValue(forKey: "appVersion").stringValue!
				latestVersion = latestVersion.replacingOccurrences(of: ".", with: "")
				
				if Int(currentVersion)! < Int(latestVersion)! {
					SCLAlertView().showInfo("Update me!", subTitle: "You need to update the app. You might miss your bus otherwise...")
				}
			}
			
			// Heading
			if global.firebaseConfig.configValue(forKey: "mainHeading").stringValue != nil {
				self.lblHeading.text = global.firebaseConfig.configValue(forKey: "mainHeading").stringValue
			}
		})
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
