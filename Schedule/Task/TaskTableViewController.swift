//
//  TaskViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TaskTableViewController : UITableViewController {
    
    @IBOutlet weak var AddTaskButtonItem: UIBarButtonItem!
    @IBOutlet weak var AddTaskButton: UIButton!
    
    let coredataRef = PersistenceManager.shared
    var TaskList : [Task] = []
    var selectedObjectID : String = ""  // variable to pass selected object id to detail view
    var selectedObject : Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //getTaskList()
        self.TaskList = coredataRef.getTaskListByCategory(category: EventConstants.EventCategory.Task)
        self.tableView.separatorStyle = .none
        self.tableView.reloadData()
    }
    
    // *********************************************************************************
    // extract task from coredata
    // *********************************************************************************
    
    func getTaskList() {
        // clear the list
        TaskList = []
        
        guard let tasks = try! coredataRef.context.fetch(Task.fetchRequest()) as? [Task]
            else { return }
        tasks.forEach { (task) in
            TaskList.append(task)
        }
 
    }
    
    // *********************************************************************************
    // get count of task entity
    // *********************************************************************************
    func getTaskCount() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: TaskCoredataConstants.EntityTitle)
        do {
            let count = try coredataRef.context.count(for: fetchRequest)
            //print(count)
            return count
        }
        catch {
            print(error.localizedDescription)
            return -1
        }
    }
    
    // *********************************************************************************
    // extension of table view
    // *********************************************************************************
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getTaskCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell") as! TaskTableViewCell
        let task = TaskList[indexPath.row] as! Task
        
        let myFormatter = MyDateManager()
        let ddlDate = myFormatter.FormattedStringToDate(dateStr: task.endTime!)
        
        // check the task status
        if ddlDate <= Date() {
            task.setValue(true, forKey: "status")
            coredataRef.saveContext()
        }
        
        cell.TaskTitle_Label.text = task.title
        cell.TaskDLL_Label.text = myFormatter.FormattedToSimplified(datestr: task.endTime!)
        cell.TaskStatus_Label.text = convertTaskStatusToString(status: task.status)
        
        cell.objectID = task.objectID.uriRepresentation().absoluteString
        cell.object = task
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
        self.tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TaskTableViewCell
        self.selectedObjectID = cell.objectID
        self.selectedObject = cell.object
        performSegue(withIdentifier: "TaskListToDetail", sender: self)
    
    }
       
       
       // prepare for transmition from course list to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if (segue.identifier == "TaskListToDetail") {
               if let destVC = segue.destination as? TaskDetailViewController {
                    destVC.selectedObjectID = self.selectedObjectID
                    destVC.selectedObject = self.selectedObject
               }
           }
    }
    
    func convertTaskStatusToString(status : Bool) -> String {
        if status == true {
            return "Dued"
        }
        else{
            return "In Progress"
        }
    }
    
}
