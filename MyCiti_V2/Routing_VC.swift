//
//  Routing_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/14/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import SexyTooltip
import CoreLocation
import FirebaseAnalytics

class Routing_VC: Sub_UIViewController {

	@IBOutlet weak var viewHeader: UIView!
	@IBOutlet weak var btnFrom: UIButton!
	@IBOutlet weak var btnTo: UIButton!
	@IBOutlet weak var tblLegs: UITableView!
	
	@IBOutlet weak var btnFromBig: Sub_UIButton!
	@IBOutlet weak var btnToBig: Sub_UIButton!
	
	var trip: Trip?
	var fromStop: Stop?
	var toStop: Stop?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tblLegs.register(UINib(nibName: "RouteLeg_Cell", bundle: nil), forCellReuseIdentifier: "routeLeg_cell")
		
		let label = UILabel(frame: CGRect(x: 0, y: 0, width: tblLegs.frame.width, height: 55))
		label.textAlignment = .center
		label.text = "Costs, times and route information are estimates."
		label.textColor = UIColor.gray
		label.font = UIFont(name: label.font.familyName, size: 9)
		tblLegs.tableFooterView = label
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		btnFromBig.layer.cornerRadius = btnFromBig.frame.height/2
        btnFromBig.backgroundColor = UIColor.flatGreen
		
		btnToBig.layer.cornerRadius = btnFromBig.frame.height/2
        btnToBig.backgroundColor = UIColor.flatRed
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	@IBAction func from(_ sender: Any) {
		chooseStop(sender: btnFrom)
	}
	
	@IBAction func to(_ sender: Any) {
		chooseStop(sender: btnTo)
	}
	
	func getTrip() {
		if fromStop != nil && toStop != nil && fromStop != toStop {
            FIRAnalytics.logEvent(withName: "viewed_route", parameters: [
                "from": fromStop!.name as NSObject,
                "to": toStop!.name as NSObject
                ])
            
			showLoading()
			api.getTrip(from: fromStop!, to: toStop!, completion: {
				trip in
				self.hideLoading()
				self.unhideControls()
				self.trip = trip
				self.tblLegs.reloadData()
			})
		}
	}
	
	func unhideControls() {
		tblLegs.unhide(animated: true)
		viewHeader.unhide(animated: true)
		btnFromBig.hide(animated: true)
		btnToBig.hide(animated: true)
	}
	
	func chooseStop(sender: Any) {
		let vc = storyboard?.instantiateViewController(withIdentifier: "stops_vc") as! Stops_VC
		vc.handler = {
			stop in
			vc.navigationController!.popViewController(animated: true)
			if (sender as! UIButton) == self.btnFrom {
				self.fromStop = stop
				self.btnFrom.setTitle(stop.name, for: .normal)
				self.btnFromBig.setTitle(stop.name, for: .normal)
			} else {
				self.toStop = stop
				self.btnTo.setTitle(stop.name, for: .normal)
				self.btnToBig.setTitle(stop.name, for: .normal)
			}
			self.getTrip()
		}
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
}



// TableView stuff


extension Routing_VC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if trip == nil { return 0 }
		return trip!.legs.count
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 210 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "routeLeg_cell") as! RouteLeg_Cell
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cell = cell as! RouteLeg_Cell
		cell.setup(leg: trip!.legs[indexPath.row])
	}
}


// Tooltips


extension Routing_VC {
	func showMainTooltips() {
		if tooltipManager.isFirstTime(forScreen: .RouteMain) {
			let ttFrom = SexyTooltip(attributedString: NSAttributedString(string: "Select where to start"), sizedTo: btnFrom)
			let ttTo = SexyTooltip(attributedString: NSAttributedString(string: "Select destination"), sizedTo: btnTo)
			
			ttFrom?.hasShadow = true
			ttFrom?.color = UIColor.red
			
			ttFrom?.present(from: btnFrom, in: self.view)
			ttTo?.present(from: btnTo, in: self.view)
		}
	}
}









