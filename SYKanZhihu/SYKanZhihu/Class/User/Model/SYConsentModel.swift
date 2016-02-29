//
//  SYConsentModel.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/29.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

class ConsentModel{
    
    //答案标题
    var title:String?
    
    //答案链接
    var link:String?
    
    //答案赞同数
    var agree:String?
    
    //是否有专栏
    var ispost:String?
    
    
    convenience init(dict:NSDictionary) {
        self.init()
        
        self.title = dict["title"] as? String
        self.link = dict["link"] as? String
        self.agree = dict["agree"] as? String
        self.ispost = dict["ispost"] as? String
    }
    
}