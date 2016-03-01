//
//  universalManager.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/23.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation
import UIKit


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