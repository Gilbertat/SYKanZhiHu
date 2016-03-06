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
    override func drawRect(rect: CGRect) {
        //切左上右上圆角 添加border
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: [.TopLeft,.TopRight], cornerRadii: CGSizeMake(5.0, 5.0)).CGPath
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = UIColor.lightGrayColor().CGColor
        borderLayer.fillColor = UIColor.clearColor().CGColor
        
        let layers:NSArray = self.layer.sublayers! as NSArray
        
        if ((layers.lastObject!.isKindOfClass(CAShapeLayer))) {
            layers.lastObject?.removeFromSuperlayer()
        }
        self.layer.addSublayer(borderLayer)
        
    }
}
