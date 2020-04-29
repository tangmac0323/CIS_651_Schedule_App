//
//  CourseDetailViewController.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class CourseDetailViewController : UIViewController {
    
    // declare outlets from story board
    @IBOutlet weak var College_Label: UILabel!
    @IBOutlet weak var SubjectArea_Label: UILabel!
    @IBOutlet weak var Course_Label: UILabel!
    @IBOutlet weak var ClassID_Label: UILabel!
    @IBOutlet weak var SectionID_Label: UILabel!
    @IBOutlet weak var Period_Label: UILabel!
    @IBOutlet weak var ClassTime_Label: UILabel!
    @IBOutlet weak var Room_Label: UILabel!
    @IBOutlet weak var Instructor_Label: UILabel!
    @IBOutlet weak var Notification_Switch: UISwitch!
    
    
    
    // declare variable for pass in value
    var classID : String?
    
    
}
