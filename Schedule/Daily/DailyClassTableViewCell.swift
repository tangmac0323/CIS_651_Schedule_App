//
//  DailyClassTableViewCell.swift
//  Schedule
//
//  Created by 杨丽婧 on 2020/3/16.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

class DailyClassTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var classroomLabel: UILabel!
    @IBOutlet weak var courseLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
