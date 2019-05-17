//
//  Sub_MGLPointAnnotation.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/14/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import Mapbox

class Sub_MGLPointAnnotation: MGLPointAnnotation {
	
	var stop: Stop!
	
	init(stop: Stop) {
		super.init()
		self.stop = stop
		
		coordinate = stop.coords
		title = stop.name
		subtitle = stop.agency.name
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
