//
//  AssignmentViewController.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/17.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class CourseViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var CourseTableView: UITableView!
    
    @IBOutlet weak var AddCourseButtonItem: UIBarButtonItem!
    @IBOutlet weak var AddCourseButton: UIButton!
    
    var course = ["task1", "task2"]
    
    var selectIndex = -1
    var selectedClassID = ""
    var isCollapse = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.CourseTableView.delegate = self
        self.CourseTableView.dataSource = self
        
        CourseTableView.estimatedRowHeight = 130
        CourseTableView.rowHeight = UITableView.automaticDimension
    }
    
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        /*
        if self.selectIndex == indexPath.row && self.isCollapse == true
        {
            return 130
        }
        else {
            return 50
        }
         */
        return 60
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return course.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell") as! CourseTableViewCell
        cell.courseLabel.text = course[indexPath.row]
        cell.classID = course[indexPath.row]
        
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
     */
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        /*
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
         */
        self.CourseTableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! CourseTableViewCell
        self.selectedClassID = cell.classID!
        performSegue(withIdentifier: "CourseListToDetail", sender: self)
 
    }
    
    
    // prepare for transmition from course list to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CourseListToDetail") {
            if let destVC = segue.destination as? CourseDetailViewController {
                destVC.classID = self.selectedClassID
            }
        }
    }
    
}
