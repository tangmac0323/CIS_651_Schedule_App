//
//  AppDelegate.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/16.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit
import CoreData
import CloudKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // configure firebase
        FirebaseApp.configure()
        
        // Override point for customization after application launch.
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().tintColor = .blue
        
        
        // *************************************************************
        //  WeeklyView Delegate Extension
        // *************************************************************
        /*
        window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController(rootViewController: WeeklyViewController())
        //let navVC = MainNavController(persistenceManager: PersistenceManager.shared, viewController: WeeklyViewController())
        navVC.isNavigationBarHidden = false
        navVC.navigationBar.isTranslucent = false
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
        */
        // *************************************************************
        //  Coredata Extension
        // *************************************************************
        
        let vc = MainTabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        
        // *************************************************************
        //  Notification Extension
        // *************************************************************
        let center = UNUserNotificationCenter.current()
        //let center = NotificationManager.notifyCenter
        
        //request user authorization for the notification
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if error != nil {
                print("request authorization error")
            }
        }
        
        
        
        return true
    }

    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


