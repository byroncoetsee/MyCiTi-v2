//
//  Sub_UIButton.swift
//  Heroku
//
//  Created by Byron Coetsee on 2016/05/16.
//  Copyright © 2016 Wixel (Pty) Ltd. All rights reserved.
//

import UIKit
import BadgeSwift

class Sub_UIButton: UIButton {
	
	var badge = BadgeSwift()

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = UIColor.clear
		setTitleColor(UIColor.flatWhite(), for: UIControlState())
		self.addSubview(badge)
		badge.isHidden = false
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	func addBadge(text: String) {
		badge.isHidden = false
		badge.text = "\(text)"
		customiseBadge(badge: badge)
		positionBadge(badge: badge)
	}
	
	func removeBadge() {
		badge.isHidden = true
	}
	
	func customiseBadge(badge: BadgeSwift) {
		badge.insets = CGSize(width: 4, height: 4)
		badge.textColor = UIColor.white
		badge.badgeColor = UIColor.flatRed()
	}
	
	func positionBadge(badge: UIView) {
		badge.translatesAutoresizingMaskIntoConstraints = false
		var constraints = [NSLayoutConstraint]()
		
		constraints.append(NSLayoutConstraint(
			item: badge,
			attribute: NSLayoutAttribute.top,
			relatedBy: NSLayoutRelation.equal,
			toItem: self,
			attribute: NSLayoutAttribute.topMargin,
			multiplier: 1, constant: 0)
		)
		
		constraints.append(NSLayoutConstraint(
			item: badge,
			attribute: NSLayoutAttribute.trailing,
			relatedBy: NSLayoutRelation.equal,
			toItem: self,
			attribute: NSLayoutAttribute.trailingMargin,
			multiplier: 1, constant: 0)
		)
		
		self.addConstraints(constraints)
	}
	
	func fadeOut() {
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.5, animations: {_ in
				self.alpha = 0
			}, completion: {_ in
				self.isHidden = true
			})
		}
	}
	
	func fadeIn() {
		DispatchQueue.main.async {
			self.isHidden = false
			UIView.animate(withDuration: 0.5, animations: {_ in
				self.alpha = 1
			})
		}
	}
}








