//
//  AppDelegate.swift
//  MyCiti_V2
//
//  Created by Byron Coetsee on 2016/09/17.
//  Copyright © 2016 Byron Coetsee. All rights reserved.
//

import UIKit
import Mapbox
import Firebase
import FirebaseMessaging
import UserNotifications
import SwiftyJSON
import SCLAlertView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
    var activeViewController: Sub_UIViewController!
	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		MGLAccountManager.setAccessToken("pk.eyJ1IjoiYnlyb25jb2V0c2VlIiwiYSI6ImRacUQzS2sifQ.WbF5R5mwkikWyEHi6-EKyw")
		FIRApp.configure()
		
		api.getToken()
		
		let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
		application.registerUserNotificationSettings(settings)
		
		application.registerForRemoteNotifications()
		application.applicationIconBadgeNumber = 0
		
		return true
	}
	
	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
		let json = JSON(userInfo)
		
		if let message = json["aps"]["alert"].string {
			SCLAlertView().showInfo("", subTitle: message)
		}
		print(userInfo)
	}
    
//    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
//        
//        var rootVC = rootViewController
//        if rootVC == nil {
//            rootVC = UIApplication.shared.keyWindow?.rootViewController
//        }
//        
//        if rootVC?.presentedViewController == nil {
//            return rootVC
//        }
//        
//        if let presented = rootVC?.presentedViewController {
//            if presented.isKind(of: UINavigationController.self) {
//                let navigationController = presented as! UINavigationController
//                return navigationController.viewControllers.last!
//            }
//            
//            if presented.isKind(of: UITabBarController.self) {
//                let tabBarController = presented as! UITabBarController
//                return tabBarController.selectedViewController!
//            }
//            
//            return getVisibleViewController(presented)
//        }
//        return nil
//    }
	
	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	
	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
	
	
}

