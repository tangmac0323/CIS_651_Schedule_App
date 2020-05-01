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
    
    @IBOutlet weak var OutterView_View: UIView!
    @IBOutlet weak var Subview_View: UIView!
    
    var objectID : String = ""
    var object : Task?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*
        self.Subview_View.layer.masksToBounds = true
        self.Subview_View.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.Subview_View.backgroundColor = UIColor.orange
        self.Subview_View.layer.cornerRadius = 5
        
        self.layer.backgroundColor = UIColor.orange.cgColor
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        let borderColor: UIColor = .white
        self.layer.borderColor = borderColor.cgColor
         */
        
        self.Subview_View.layer.masksToBounds = true
        self.Subview_View.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        self.Subview_View.backgroundColor = UIColor.cyan.withAlphaComponent(0.2)
        self.Subview_View.layer.cornerRadius = 5
    }
    
}
