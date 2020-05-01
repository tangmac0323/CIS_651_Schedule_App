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
    
    var CourseList: [Course] = []   // variable to store course fetch from coredata
    let coredataRef = PersistenceManager.shared
    
    var selectIndex = -1
    
    var selectedClassID = ""
    var courseObj: Course?
    var isCollapse = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.CourseTableView.delegate = self
        self.CourseTableView.dataSource = self
        
        CourseTableView.estimatedRowHeight = 130
        CourseTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        loadCourseDataFromCoredata()
        self.CourseTableView.separatorStyle = .none
        self.CourseTableView.reloadData()
    }
    
    // *********************************************************************************
    // load data from coredata
    // *********************************************************************************
    func loadCourseDataFromCoredata() {
        self.CourseList = coredataRef.getCourseList()
    }
    
    // *********************************************************************************
    // construct date label for cell
    // *********************************************************************************
    func constructCellDateLabel(course: Course) -> String {
        var labelText = ""
        let startDate = (course.startDate == "") ? "TBA" : course.startDate!
        let startTime = (course.endTime == "") ? "TBA" : course.endTime!
        let endDate = (course.endDate == "") ? "TBA" : course.endDate!
        let endTime = (course.endTime == "") ? "TBA" : course.endTime!
        let weekdays = (course.weekdays == "") ? "TBA" : course.weekdays!
        
        labelText = "\(weekdays) \(startTime)-\(endTime) \(startDate)-\(endDate)"
        
        return labelText
        
    }
    
    // *********************************************************************************
    // extension of table view
    // *********************************************************************************

    
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
        return 80
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CourseTableViewCell") as! CourseTableViewCell
        let course = CourseList[indexPath.row] as! Course
        
        cell.courseLabel.text = course.course
        cell.courseObj = course
        
        //print(course)
        
        cell.dateLabel.text = self.constructCellDateLabel(course: course)
        //cell.courseLabel.text = course[indexPath.row]
        //cell.classID = course[indexPath.row]
        
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
        //self.selectedClassID = cell.courseTitle!
        self.courseObj = cell.courseObj
        performSegue(withIdentifier: "CourseListToDetail", sender: self)
 
    }
    
    
    // prepare for transmition from course list to detail view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CourseListToDetail") {
            if let destVC = segue.destination as? CourseDetailViewController {
                //destVC.courseTitle = self.selectedClassID
                destVC.courseObj = self.courseObj
            }
        }
    }
    
}
