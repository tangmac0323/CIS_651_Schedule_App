//
//  TaskDetailViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TaskDetailViewController: UIViewController {
    
    
    @IBOutlet weak var Edit_Button: UIButton!
    @IBOutlet weak var TaskTitle_Label: UILabel!
    @IBOutlet weak var CountDown_Label: UILabel!
    @IBOutlet weak var DueDate_Label: UILabel!
    
    @IBOutlet weak var Note_TextView: UITextView!
    @IBOutlet weak var Notification_Switch: UISwitch!
    @IBOutlet weak var Delete_Button: UIButton!
    
    // reference to coredata db
    let coredataRef = PersistenceManager.shared
    let notificationManager = NotificationManager.shared
    
    
    var selectedObjectID : String = ""  // varaible to take the pass in id
    var selectedObject : Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadData()
    }
    
    
    // *********************************************************************************
    // function to load the data
    // *********************************************************************************
    func loadData() {
        if let task = getTaskByObjectID(objectID: self.selectedObjectID) {
            let myFormatter = MyDateManager()
        
            self.TaskTitle_Label.text = task.title
            self.DueDate_Label.text = "Due date: \(myFormatter.FormattedToSimplified(datestr: task.endTime!))"
            self.Note_TextView.text = task.content
            self.Notification_Switch.isOn = task.notification
            
            // calculate the time difference
            let dueDate = myFormatter.FormattedStringToDate(dateStr: task.endTime!)
            let delta = myFormatter.CalcDateDiffByDateObject(toDate: dueDate, fromDate: Date())
            
            if delta <= 0 {
                self.CountDown_Label.text = "Dued"
            }
            else{
                let deltaArr = myFormatter.SecondToDate(seconds: delta)
                self.CountDown_Label.text = "\(deltaArr[0])Day(s) \(deltaArr[1])Hour(s) \(deltaArr[2])Minutes"
            }
        }
    }
    
    // *********************************************************************************
    // function to extract object from db
    // *********************************************************************************
    func getTaskByObjectID( objectID : String ) -> Task? {
        if let objectURL = URL(string : objectID) {

            if let coordinator: NSPersistentStoreCoordinator = coredataRef.persistentContainer.persistentStoreCoordinator {
                if let managedObjectID = coordinator.managedObjectID(forURIRepresentation: objectURL) {

                    return coredataRef.context.object(with: managedObjectID) as? Task
                }
                else{
                    return nil
                }
            }
            else {
                return nil
            }
        }
        else {
            return nil
        }
    }
    
    // *********************************************************************************
    // function to delete the object
    // *********************************************************************************
    @IBAction func DeleteButton_Tapped(_ sender: Any) {
        if let object = self.selectedObject {
            self.coredataRef.context.delete(object)
        }
        else{
            print("object not exist")
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        

    }
    
    @IBAction func EditButton_Tapped(_ sender: Any) {
        performSegue(withIdentifier: "TaskDetailToEdit", sender: self)
    }
    
    // prepare for transmition from course list to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "TaskDetailToEdit") {
               if let destVC = segue.destination as? EditTaskViewController {
                    destVC.selectedObject = self.selectedObject
               }
           }
    }
    
    @IBAction func NotificationButton_Switched(_ sender: Any) {
        
        
        let myFormatter = MyDateManager()
        let dueDate = myFormatter.FormattedStringToDate(dateStr: self.selectedObject!.endTime!)
        let notifyDate = dueDate - Double (60 * 60 * 24)
        let notifyStr = "\(self.selectedObject!.title!)"
        let notifyType = "Task"
        let notifyID = selectedObject?.objectID.uriRepresentation().absoluteString
        
        // create a notification if is on
        if self.Notification_Switch.isOn {
            self.notificationManager.setNotify(date: notifyDate, str: notifyStr, type: notifyType, id: notifyID!)
        }
        // remove the notification if is off
        else{
            self.notificationManager.removeNotify(id: notifyID!)
        }
    }
    
    
}

