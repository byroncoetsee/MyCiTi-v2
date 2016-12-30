//
//  Sub_UINavigationController.swift
//  Heroku
//
//  Created by Byron Coetsee on 2016/05/19.
//  Copyright © 2016 Wixel (Pty) Ltd. All rights reserved.
//

import UIKit

class Sub_UINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	func setTitle(title: String, colour: UIColor = UIColor.white) {
		navigationBar.topItem!.title = title
		navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: colour]
	}
	
	override func pushViewController(_ viewController: UIViewController, animated: Bool) {
		addTransitionLayer()
		super.pushViewController(viewController, animated: animated)
	}
	
	override func popViewController(animated: Bool) -> UIViewController? {
		addTransitionLayer()
		super.popViewController(animated: false)
		return nil
	}
	
	func addTransitionLayer () {
		let transition = CATransition()
		transition.duration = 0.25
		transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
		transition.type = kCATransitionFade
		view.layer.add(transition, forKey: nil)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
