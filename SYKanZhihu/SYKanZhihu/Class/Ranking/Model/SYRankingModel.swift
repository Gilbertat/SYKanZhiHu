//
//  SYRankingModel.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

class topUserModel {
    
    //用户名称
    var name:String?
    //用户hash
    var hash:String?
    //用户头像
    var avatar:String?
    //用户签名
    var signature:String?
    
    convenience init(dict:NSDictionary) {
        self.init()
        self.name = dict["name"] as? String
        self.hash = dict["hash"] as? String
        self.avatar = dict["avatar"] as? String
        self.signature = dict["signature"] as? String
    }
}