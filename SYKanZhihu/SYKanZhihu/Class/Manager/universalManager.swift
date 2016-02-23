//
//  universalManager.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/23.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation
import UIKit


class universal {
    static func maskToCorner(view:UIView, corner:UIRectCorner, cornerRedius size:CGSize) {
        let maskPath = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: size)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.CGPath
        view.layer.mask = maskLayer
    }
}


extension UIView {
    @IBInspectable var cornerRadius : CGFloat {
    get {
        return layer.cornerRadius
    }
    set {
        layer.cornerRadius = newValue
        layer.masksToBounds = (newValue > 0)
    }
    
    
  }
    
}