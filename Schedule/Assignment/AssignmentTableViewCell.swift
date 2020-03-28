//
//  AssignmentTableViewCell.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/17.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class AssignmentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
