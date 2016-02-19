//
//  SYHomeModel.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

class HomeModel {
    
    //文章编号
    var id:String?
    //发表日期
    var date:String?
    //文章名称
    var name:String?
    //抬头图
    var pic:String?
    //发表时间戳
    var publishtime:String?
    //文章包含答案数量
    var count:String?
    //摘要文字
    var excerpt:String?
    
    convenience init(dict:NSDictionary) {
        self.init()
        
        self.id = dict["id"] as? String
        self.date = dict["date"] as? String
        self.name = dict["name"] as? String
        self.pic = dict["pic"] as? String
        self.publishtime = dict["publishtime"] as? String
        self.count = dict["count"] as? String
        self.excerpt = dict["excerpt"] as? String
    }
    
}