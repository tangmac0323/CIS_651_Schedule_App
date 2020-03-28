//
//  WeeklyEventViewer.swift
//  KVKCalendar_Example
//
//  Created by Mengtao Tang on 3/20/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import UIKit

final class WeeklyEventViewer: UIView {
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Select event to view the description"
        return label
    }()
    
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        textLabel.frame = frame
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadFrame(frame: CGRect) {
        textLabel.frame = frame
    }
}
