//
//  Stops_VC.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/11/03.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import CoreLocation

class Stops_VC: Sub_UIViewController {

//	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tblStops: UITableView!
    var searchController: UISearchController! = nil
	
	// Closest Stop Bar
	@IBOutlet weak var lblClosestDistance: UILabel!
	@IBOutlet weak var lblClosestName: UILabel!
	@IBOutlet weak var viewClosestBar: UIView!
    @IBOutlet weak var btnIcon: UIButton!
	@IBOutlet weak var constraintClosestBottom: NSLayoutConstraint!
	
	// Variables
	var stopsFull: [Stop] = []
	var stops: [Stop] = []
	var closestStop: Stop?
	var handler: ((Stop)->Void)?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tblStops.register(UINib(nibName: "Stop_Cell", bundle: nil), forCellReuseIdentifier: "stop_cell")
        navBar?.setTitle(title: "Stops")
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.delegate = self
        
        searchController.searchBar.barStyle = .blackTranslucent
        searchController.searchBar.placeholder = "Looking for a stop?"
        
        tblStops.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
		populateStops()
		
		if locManager.locManager.location != nil {
			findClosestStop()
		} else {
			let notificationName = NSNotification.Name(rawValue: LocationManagerNotification.locationUpdate.rawValue)
			NotificationCenter.default.addObserver(self, selector: #selector(findClosestStop), name: notificationName, object: nil)
		}
    }
	
	func populateStops() {
		dataManager.getStops(completionHandler: {
			stops in
			self.stops = stops
			self.tblStops.reloadData()
		})
	}

	@IBAction func openClosestStop(_ sender: Any) {
        if handler != nil {
            handler!(closestStop!)
            return
        }
        
		let vc = storyboard?.instantiateViewController(withIdentifier: "times_vc") as! Times_VC
		vc.stop = closestStop!
		self.navigationController?.pushViewController(vc, animated: false)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


// Search Controller (iOS 9+)


extension Stops_VC: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        search(forText: searchController.searchBar.text!)
        tblStops.reloadData()
    }
    
    func search(forText text: String) {
        if text.isEmpty {
            stops = global.stopList
        } else {
            var tempStops: [Stop] = []
            for stop in global.stopList {
                if stop.name.lowercased().contains(text.lowercased()) {
                    tempStops.append(stop)
                }
            }
            stops = tempStops
        }
    }
}


// TableView


extension Stops_VC: UITableViewDelegate, UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return stops.count }
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 80 }
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return tblStops.dequeueReusableCell(withIdentifier: "stop_cell") as! Stop_Cell }
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let cell = cell as! Stop_Cell
		cell.setup(stop: stops[indexPath.row])
		
		if indexPath.row%2 == 0 { cell.backgroundColor = UIColor.white.withAlphaComponent(0.1) }
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if handler != nil {
			handler!(stops[indexPath.row])
			return
		}
		
		let vc = storyboard?.instantiateViewController(withIdentifier: "times_vc") as! Times_VC
		vc.stop = stops[indexPath.row]
		self.navigationController?.pushViewController(vc, animated: false)
		tblStops.deselectRow(at: indexPath, animated: true)
	}
}


// Closest stop view bar


extension Stops_VC {
	func loadContents(stop: Stop) {
        if handler != nil {
            btnIcon.setImage(UIImage(named: "checked"), for: .normal)
            btnIcon.imageView?.image! = btnIcon.imageView!.image!.withRenderingMode(.alwaysTemplate)
            btnIcon.imageView?.tintColor = UIColor.flatBlue
        }
        
		let stopLocation = CLLocation(latitude: stop.coords.latitude, longitude: stop.coords.longitude)
		let distance = locManager.locManager.location?.distance(from: stopLocation)
		
		if distance != nil {
			if distance! < 1000.0 {
				lblClosestDistance.text = "\(Int(distance!)) m"
			} else {
				lblClosestDistance.text = "\((distance!/1000).format(f: "0.1")) km"
			}
		}
		
		lblClosestName.text = stop.name
		showClosestBar()
	}
	
	@objc func findClosestStop() {
		if locManager.locManager.location!.horizontalAccuracy > 500 { return }
		let notificationName = NSNotification.Name(rawValue: LocationManagerNotification.locationUpdate.rawValue)
		NotificationCenter.default.removeObserver(self, name: notificationName, object: nil)
		DispatchQueue(label: "findClosestStop").async {
			var closestDistance = 9999999.0
			for stop in global.stopList {
				let stopLocation = CLLocation(latitude: stop.coords.latitude, longitude: stop.coords.longitude)
				let distance = locManager.locManager.location?.distance(from: stopLocation)
				if distance! < closestDistance {
					closestDistance = distance!
					self.closestStop = stop
				}
			}
			if self.closestStop != nil {
				DispatchQueue.main.async {
					self.loadContents(stop: self.closestStop!)
				}
			}
		}
	}
	
	func showClosestBar() {
		constraintClosestBottom.constant = 0
		UIView.animate(withDuration: 1, animations: {
			self.viewClosestBar.layoutIfNeeded()
			self.tblStops.layoutIfNeeded()
		})
	}
	
	func hideClosestBar() {
		constraintClosestBottom.constant = -viewClosestBar.frame.height
		UIView.animate(withDuration: 1, animations: {
			self.viewClosestBar.layoutIfNeeded()
			self.tblStops.layoutIfNeeded()
		})
	}
}
