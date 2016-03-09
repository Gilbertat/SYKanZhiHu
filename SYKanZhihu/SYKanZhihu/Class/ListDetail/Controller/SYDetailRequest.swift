//
//  SYDetailRequest.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/3/8.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation




class DetailListRequest {
    
    var page = ""
    var dataSource : Array<HomeModel> = Array()


    func httpRequest() {
        
        let urlString = "\(ApiConfig.API_Url)/\(self.page)"
        
        SYHttp.get(urlString, params: nil, success: {(json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])
            let array:NSArray = (data!["posts"] as? NSArray)!
            self.page = (array.lastObject!["publishtime"]) as! String //根据此字段获取数据
            
            for dict in array {
                let homeModel:HomeModel = HomeModel(dict: dict as! NSDictionary)
                self.dataSource.append(homeModel)
            }
            
            }) { (error) -> Void in
                
                print(error)
        }
    }
    
    func sendModel(tag:Int) -> HomeModel {
        
        let model:HomeModel = self.dataSource[tag]
        
        return model
    }
    
}