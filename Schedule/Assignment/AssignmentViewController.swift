//
//  AssignmentViewController.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/17.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class AssignmentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var assignmentTableView: UITableView!
    
    var tasks = ["task1", "task2"]
    
    var selectIndex = -1
    var isCollapse = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        assignmentTableView.estimatedRowHeight = 130
        assignmentTableView.rowHeight = UITableView.automaticDimension
    }
    
    
    @IBAction func addNewTask(_ sender: UIButton) {
        
        //test
        tasks.append("new Task")
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        
        assignmentTableView.beginUpdates()
        assignmentTableView.insertRows(at: [indexPath], with: .automatic)
        assignmentTableView.endUpdates()
        
        
        /*
        print("main before add")
        AssignmentManager.shared.getAssignment()
        */
        
        performSegue(withIdentifier: "addAssignment", sender: self)
        
        /*
        print("main after add")
        AssignmentManager.shared.getAssignment()
        */
 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.selectIndex == indexPath.row && self.isCollapse == true
        {
            return 130
        }
        else {
            return 50
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AssignmentCell") as! AssignmentTableViewCell
        cell.taskLabel.text = tasks[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if selectIndex == indexPath.row {
            if self.isCollapse == false {
                self.isCollapse = true
            }
            else {
                self.isCollapse = false
            }
        }
        else {
            self.isCollapse = true
        }
        
        self.selectIndex = indexPath.row
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }

}
