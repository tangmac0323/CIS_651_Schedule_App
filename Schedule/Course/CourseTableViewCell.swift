//
//  AssignmentTableViewCell.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/17.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class CourseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var OutterView_View: UIView!
    @IBOutlet weak var Subview_View: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    
    var courseTitle : String?
    var sectionID : String?
    var courseObj : Course?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /*
        self.backgroundColor = UIColor.red
        //self.contentView.backgroundColor = UIColor.green

        self.Subview_View.backgroundColor = UIColor.orange
        self.Subview_View.layer.cornerRadius = 5
        self.Subview_View.layer.masksToBounds = true
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layoutMargins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        self.contentView.layer.borderWidth = 5
        */
        //self.OutterView_View.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        
        self.Subview_View.layer.masksToBounds = true
        self.Subview_View.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        self.Subview_View.backgroundColor = UIColor.cyan.withAlphaComponent(0.2)
        self.Subview_View.layer.cornerRadius = 5
        //self.Subview_View.layer.borderWidth = 5
        //self.Subview_View.layer.shadowOffset = CGSize(width: -1, height: 1)
        //let borderColor: UIColor = .white
        //self.Subview_View.layer.borderColor = borderColor.cgColor
        
        // Initialization code
        
    }


    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 */
}
