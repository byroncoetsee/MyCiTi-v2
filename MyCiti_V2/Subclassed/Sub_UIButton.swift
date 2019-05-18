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
		setTitleColor(UIColor.flatWhite, for: UIControl.State())
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
        badge.badgeColor = UIColor.flatRed
	}
	
	func positionBadge(badge: UIView) {
		badge.translatesAutoresizingMaskIntoConstraints = false
		var constraints = [NSLayoutConstraint]()
		
		constraints.append(NSLayoutConstraint(
			item: badge,
			attribute: NSLayoutConstraint.Attribute.top,
			relatedBy: NSLayoutConstraint.Relation.equal,
			toItem: self,
			attribute: NSLayoutConstraint.Attribute.topMargin,
			multiplier: 1, constant: 0)
		)
		
		constraints.append(NSLayoutConstraint(
			item: badge,
			attribute: NSLayoutConstraint.Attribute.trailing,
			relatedBy: NSLayoutConstraint.Relation.equal,
			toItem: self,
			attribute: NSLayoutConstraint.Attribute.trailingMargin,
			multiplier: 1, constant: 0)
		)
		
		self.addConstraints(constraints)
	}
	
	func fadeOut() {
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.5, animations: {
				self.alpha = 0
			}, completion: {_ in
				self.isHidden = true
			})
		}
	}
	
	func fadeIn() {
		DispatchQueue.main.async {
			self.isHidden = false
			UIView.animate(withDuration: 0.5) {
				self.alpha = 1
			}
		}
	}
}








