//
//  Sub_UILabel.swift
//  PTT
//
//  Created by Byron Coetsee on 2016/05/25.
//  Copyright © 2016 Wixel (Pty) Ltd. All rights reserved.
//

import UIKit

class Sub_UILabel: UILabel {
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		
		textColor = global.theme_textColour
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
}
