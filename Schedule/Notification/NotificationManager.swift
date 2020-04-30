//
//  NotificationManager.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/30/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    private init() {}
    
    // create a singleton
    static let shared = NotificationManager()
    
    let notifyCenter = UNUserNotificationCenter.current()
    
    func removeNotify(id: String) {
        notifyCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func setNotify(date: Date?, str: String?, type: String?, id: String) -> () {
        
        var title = "None"
        
        if type != nil {
            if type == "Class" {
                title = "You have a class in 10 mintue"
            }
            else if type == "Task" {
                title = "You have a task due tomorrow"
            }
            else {
                return
            }
        }
        
        //create the notification content
        let content = UNMutableNotificationContent()
        content.title = title
        if str != nil {
            content.body = str!
        }
        
        //create the trigger
        //let date = Date().addingTimeInterval(10)
        
        if date == nil {
            return
        }
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date!)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        //create the request
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        //register the request with the notification center
        notifyCenter.add(request) { (error) in
            if error != nil {
                print("register request failed")
            }
            
        }
        
    }
    
}
