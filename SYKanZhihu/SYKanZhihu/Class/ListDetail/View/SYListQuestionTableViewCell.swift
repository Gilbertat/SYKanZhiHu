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
        let maskPath = UIBezierPath(roundedRect:self.bounds, byRoundingCorners: [.TopLeft,.TopRight], cornerRadii: CGSizeMake(5.0, 5.0))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.CGPath
        self.layer.mask = maskLayer
    }
}
