//
//  BaseManager.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

class ApiConfig {
    
    //聚合数据API
    static let API_Url:String = "http://api.kanzhihu.com/getposts"
    //查看是否有新聚合
    static let API_CheckNew:String = "http://api.kanzhihu.com/checknew/"
    //聚合数据下文章列表API
    static let API_List_Url:String = "http://api.kanzhihu.com/getpostanswers"
    //文章列表下详细文章API
    static let API_Aritical_Url:String = "https://www.zhihu.com/question/"
    //请求用户个人数据
    static let API_User_Url:String = "http://api.kanzhihu.com/userdetail2/"
    //知乎官网
    static let API_ZhiHu_Url:String = "https://www.zhihu.com"
    //知乎专栏
    static let API_ZhuanLan_Url:String = "http://zhuanlan.zhihu.com"
    //知乎个人页
    static let API_ZhPersonal_Url:String = "https://www.zhihu.com/people"
    //排名数据
    static let API_ZhTopUsers_Url:String = "http://api.kanzhihu.com/topuser/"
    
}
    
