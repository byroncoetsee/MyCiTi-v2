//
//  Sub_UITextField.swift
//  Heroku
//
//  Created by Byron Coetsee on 2016/05/16.
//  Copyright © 2016 Wixel (Pty) Ltd. All rights reserved.
//

import UIKit

class Sub_UITextField: UITextField {

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
//		textColor = global.colour_opposing
//		backgroundColor = UIColor(white: 1, alpha: 0.1)
//		borderStyle = UITextBorderStyle.Line
//		layer.cornerRadius = frame.height/2
//		layer.borderWidth = 1
//		layer.borderColor = UIColor(white: 1, alpha: 0.8).CGColor
		font = UIFont(name: "Arial", size: 15)
		if placeholder != nil {
			attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [NSForegroundColorAttributeName: global.theme_textColour.withAlphaComponent(0.5) ])
		}
//		layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
	}
}
