//
//  SYListDetailModel.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/22.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

class ListDetailModel {
    
    //标题
    var title:String?
    //日期
    var time:String?
    //问题ID
    var questionid:String?
    //回答ID
    var answerid:String?
    //用户名称
    var authorname:String?
    //用户hash
    var authorhash:String?
    //用户头像
    var avatar:String?
    //用户回答
    var summary:String?
    //赞同数
    var vote:String?
    //更新状态说明
    var categoryName:Dictionary<String,String>?
    
    convenience init(dict:NSDictionary) {
        self.init()
        self.title = dict["title"] as? String
        self.time = dict["time"] as? String
        self.questionid = dict["questionid"] as? String
        self.answerid = dict["answerid"] as? String
        self.authorname = dict["authorname"] as? String
        self.authorhash = dict["authorhash"] as? String
        self.avatar = dict["avatar"] as? String
        self.vote = dict["vote"] as? String
        self.summary = dict["summary"] as? String
        self.categoryName = ["recent":"近日热门",
                            "yesterday":"昨日最新",
                            "archive":"历史精华"]
    }
    
    
}