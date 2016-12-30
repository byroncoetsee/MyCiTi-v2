//
//  Sub_UIViewController.swift
//
//  Created by Byron Coetsee on 2016/05/16.
//  Copyright © 2016 Wixel (Pty) Ltd. All rights reserved.
//

import UIKit

class Sub_UIViewController: UIViewController {
	
	var navBar : Sub_UINavigationController?
//	var loadingView: UIAlertController!
	var loadingVisible: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
//		view.backgroundColor = UIColor.init(gradientStyle: .radial, withFrame: view.frame, andColors: [UIColor.flatBlueColorDark(), UIColor.flatBlackColorDark().darken(byPercentage: 0.3)])
        view.backgroundColor = UIColor.init(gradientStyle: .radial, withFrame: view.frame, andColors: [UIColor.flatBlack(), UIColor.flatBlackColorDark()])
//		view.backgroundColor = UIColor.flatOrange()
//		view.backgroundColor = UIColor.flatNavyBlue()
//		view.backgroundColor = UIColor.flatTeal()
//        view.backgroundColor = UIColor.flatBlack()
		
		// Comment this line to unTransparentarize the Navi Controller
		if self.navigationController != nil {
			self.navigationController!.isNavigationBarHidden = false
			self.navigationController!.navigationBar.shadowImage = UIImage()
			self.navigationController?.navigationBar.tintColor = UIColor.white
			self.navigationController?.navigationBar.barTintColor = view.backgroundColor
		}
		
		navBar = navigationController as? Sub_UINavigationController
		showNavigationBar()
    }
	
//	override func viewDidLayoutSubviews() {
//		self.loadingView = getLoadingView()
//	}
	
	func showNavigationBar() {
		self.navigationController!.navigationBar.setBackgroundImage(nil, for: .default)
	}
	
	func hideNavigationBar() {
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}
	
	func showLoading(cancelButton: Bool = true, _ completion: (() -> Void)? = nil) {
		if loadingVisible == false {
			present(getLoadingView(cancelButton: cancelButton), animated: false, completion: {
				self.loadingVisible = true
				if completion != nil { completion!() }
			})
		}
	}
	
	func hideLoading(_ completion: (() -> Void)? = nil) {
		DispatchQueue.main.async(execute: {
			if self.loadingVisible == true {
				self.dismiss(animated: false, completion: {
					self.loadingVisible = false
					if completion != nil { completion!() }
				})
			}
		})
	}
	
	func canceledLoading() {
		_ = self.navBar?.popViewController(animated: true)
		hideLoading()
	}
	
	func getLoadingView(cancelButton: Bool) -> UIAlertController {
		let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
		alert.view.tintColor = UIColor.black
		
		if cancelButton {
			let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {_ in
				self.canceledLoading()
			})
			alert.addAction(cancel)
		}
		
		let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
		loadingIndicator.hidesWhenStopped = true
		loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
		loadingIndicator.startAnimating()
		
		alert.view.addSubview(loadingIndicator)
		alert.modalTransitionStyle = .crossDissolve
		return alert
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let transition = CATransition()
		transition.duration = 0.5
		transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionFade
		self.navigationController?.view.layer.add(transition, forKey: nil)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
