//
//  CalendarCollectionViewCell.swift
//  Schedule
//
//  Created by Mengtao Tang on 3/20/20.
//  Copyright © 2020 Le Sun. All rights reserved.
//

import Foundation
import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var Label_CalendarCell: UILabel!
    @IBOutlet weak var View_DateBackground: UIView!
    
    func DrawBackground() {
        
        let circleCenter = View_DateBackground.center
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: (View_DateBackground.bounds.width/2 - 5), startAngle: -CGFloat.pi/2, endAngle: (2 * CGFloat.pi), clockwise: true)
        
        let CircleLayer = CAShapeLayer()
        CircleLayer.path = circlePath.cgPath
        CircleLayer.strokeColor = UIColor.red.cgColor
        CircleLayer.lineWidth = 2
        CircleLayer.strokeEnd = 0
        CircleLayer.fillColor = UIColor.clear.cgColor
        CircleLayer.lineCap = CAShapeLayerLineCap.round
        
        let Animation = CABasicAnimation(keyPath: "strokeEnd")
        Animation.duration = 1.5
        Animation.toValue = 1
        Animation.fillMode = CAMediaTimingFillMode.forwards
        Animation.isRemovedOnCompletion = false
        
        CircleLayer.add(Animation, forKey: nil)
        View_DateBackground.layer.addSublayer(CircleLayer)
        View_DateBackground.layer.backgroundColor = UIColor.clear.cgColor
        
    }
}
