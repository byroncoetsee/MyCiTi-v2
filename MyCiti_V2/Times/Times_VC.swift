//
//  Times_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/11/03.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import Firebase

class Times_VC: Sub_UIViewController {
	
	var stop: Stop!
	var times: [Time] = []
	
	// Popup
	var time: Time?
	var countDownTimer: Timer?
	
	@IBOutlet weak var tblTimes: UITableView!
	
	// Popup
	@IBOutlet weak var viewBlur: UIVisualEffectView!
	@IBOutlet weak var viewContainer: UIView!
	@IBOutlet weak var viewTopSection: UIView!
	@IBOutlet weak var lblTime: UILabel!
	@IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblSeconds: UILabel!
	@IBOutlet weak var lblLine: UILabel!
	@IBOutlet weak var lblLineName: UILabel!
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		FIRAnalytics.setUserPropertyString(stop.name, forName: "times_for_stop")
		
		navBar?.setTitle(title: stop.name)
		tblTimes.register(UINib(nibName: "Time_Cell", bundle: nil), forCellReuseIdentifier: "time_cell")
		
		let tapClosePopup = UITapGestureRecognizer(target: self, action: #selector(hidePopup))
		viewBlur.addGestureRecognizer(tapClosePopup)
		viewBlur.alpha = 0
    }
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		showLoading()
		getTimes()
	}
	
	func getTimes() {
		api.getTimes(forStop: stop, completion: {
			times in
			self.times = times
			self.tblTimes.reloadData()
			self.hideLoading()
		})
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// Tableview stuff


extension Times_VC: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return times.count	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 90 }
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 0 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return tblTimes.dequeueReusableCell(withIdentifier: "time_cell") as! Time_Cell }
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let _cell = cell as! Time_Cell
		let time = times[indexPath.row]
		_cell.setup(time: time)
		
		if indexPath.row == 0 {
			Timer.scheduledTimer(timeInterval: time.depart.timeIntervalSinceNow, target: self, selector: #selector(getTimes), userInfo: nil, repeats: false)
		}
		
		if indexPath.row%2 == 0 { _cell.backgroundColor = UIColor.white.withAlphaComponent(0.1) }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tblTimes.deselectRow(at: indexPath, animated: true)
		let cell = tblTimes.cellForRow(at: indexPath) as! Time_Cell
		setupPopupDetails(time: cell.time)
		showPopup()
	}
}


// Popup


extension Times_VC {
	
	func setupPopupDesign() {
		viewTopSection.backgroundColor = UIColor.flatBlack()
        viewContainer.layer.cornerRadius = 10
        viewContainer.clipsToBounds = true
	}
	
	func setupPopupDetails(time: Time) {
		self.time = time
        updateCountdown()
		countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
		lblTime.text = time.depart.string(custom: "hh:mm a")
		lblLine.text = time.line.shortName
		lblLine.textColor = time.line.colour
		lblLineName.text = time.line.name
	}
	
	func showPopup() {
		self.navigationController?.setNavigationBarHidden(true, animated: true)
		viewBlur.isHidden = false
		UIView.animate(withDuration: 0.25, animations: {
			self.viewBlur.alpha = 1
		})
	}
	
	func hidePopup() {
		countDownTimer?.invalidate()
		countDownTimer = nil
		self.navigationController?.setNavigationBarHidden(false, animated: true)
		UIView.animate(withDuration: 0.25, animations: {
			self.viewBlur.alpha = 0
		}, completion: {_ in
			self.viewBlur.isHidden = true
		})
	}
    
    func updateCountdown() {
        let components = getTimerElements()
        lblHours.text = String(format: "%02d", components.hours)
        lblMinutes.text = String(format: "%02d", components.minutes)
        lblSeconds.text = String(format: "%02d", components.seconds)
    }
	
    func getTimerElements() -> (hours: Int, minutes: Int, seconds: Int) {
		let interval = Int(abs(Date().timeIntervalSince(time!.depart)))
		let seconds: Int = interval % 60
		let minutes: Int = (interval / 60) % 60
		let hours: Int = interval / 3600
		return (hours, minutes, seconds)
	}
}
