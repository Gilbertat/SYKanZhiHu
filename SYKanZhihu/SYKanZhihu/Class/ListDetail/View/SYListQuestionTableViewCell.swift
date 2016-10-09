//
//  SYListQuestionTableViewCell.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/22.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYListQuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
   
    override var frame:CGRect {
        get {
            return super.frame
        }
        set (newframe) {
            var frame = newframe
            frame.origin.x += 10
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }
    override func draw(_ rect: CGRect) {
        //切左上右上圆角 添加border
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 5.0, height: 5.0)).cgPath
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = UIColor.lightGray.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        
        let layers:NSArray = self.layer.sublayers! as NSArray
        
        if (((layers.lastObject! as AnyObject).isKind(of: CAShapeLayer()))) {
            (layers.lastObject as AnyObject).removeFromSuperlayer()
        }
        self.layer.addSublayer(borderLayer)
        
    }
}
