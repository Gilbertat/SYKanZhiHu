//
//  SYUserModel.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/25.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

class userModel {
    
    //用户昵称
    var name:String?
    //用户头像
    var avatar:String?
    //用户签名
    var signature:String?
    //用户描述
    var description:String?
    
    //用户回答数
    var answer:String?
    //用户关注的人
    var followee:String?
    //关注用户的人
    var follower:String?
    //赞
    var agree:String?
    //感谢
    var thanks:String?
    
    //加载用户基本信息
    convenience init(info:NSDictionary) {
        self.init()
        
        self.name = info["name"] as? String
        self.avatar = info["avatar"] as? String
        self.signature = info["signature"] as? String
        self.description = info["description"] as? String
    }
    
    //加载用户附加信息
    convenience init(extra:NSDictionary) {
        self.init()
        
        self.answer = extra["answer"] as? String
        self.followee = extra["followee"] as? String
        self.follower = extra["follower"] as? String
        self.agree = extra["agree"] as? String
        self.thanks = extra["thanks"] as? String
        
    }
    
}