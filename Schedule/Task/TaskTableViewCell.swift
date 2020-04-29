//
//  TaskTableViewCell.swift
//  Schedule
//
//  Created by Mengtao Tang on 4/28/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class TaskTableViewCell : UITableViewCell {
    @IBOutlet weak var TaskTitle_Label: UILabel!
    @IBOutlet weak var TaskDLL_Label: UILabel!
    @IBOutlet weak var TaskStatus_Label: UILabel!
    
    var objectID : String = ""
    var object : Task?
    
}
