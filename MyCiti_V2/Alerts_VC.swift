//
//  Alerts_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 12/25/16.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit

class Alerts_VC: Sub_UIViewController {
	
	@IBOutlet weak var tblAlerts: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
		tblAlerts.register(UINib(nibName: "Alert_Cell", bundle: nil), forCellReuseIdentifier: "alert_cell")
    }
	
	override func viewDidAppear(_ animated: Bool) {
		if api.gotAlerts == false {
			showLoading()
			api.fetchFirebaseAlerts(completion: {
				alerts in
				self.tblAlerts.reloadData()
				self.hideLoading()
			})
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension Alerts_VC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return global.alerts.count }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return tblAlerts.dequeueReusableCell(withIdentifier: "alert_cell") as! Alert_Cell }
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 160 }
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let _cell = cell as! Alert_Cell
		_cell.setup(alert: global.alerts[indexPath.row])
	}
}
