//
//  SYHttpManager.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation
import Alamofire

class SYHttp:NSObject {

    /**
     Http get 请求
     
     - parameter url:     请求地址
     - parameter params:  请求参数
     - parameter success: 请求成功回调
     - parameter fail:    请求失败回调
     */
    
    static func get(var url:String, params:[String:AnyObject]?, success:(json:AnyObject) -> Void,fail:(error:Any) ->Void) {
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        Alamofire.request(.GET, url, parameters: params).responseString(completionHandler: {response in
            switch response.result {
            case.Success(_):
                print("请求地址为: \(url) 参数为: \(params)")
                success(json:response.data!)
                
            case .Failure(let error):
                fail(error: error)
                print(error)
            }
        })
    }
    
    /**
     Http post 请求
     
     - parameter url:     请求地址
     - parameter params:  请求参数
     - parameter success: 请求成功回调
     - parameter fail:    请求失败回调
     */
    
    static func post(url:String, params:NSDictionary, success:(json:AnyObject) -> Void, fail:(error:Any) ->Void) {
        
        Alamofire.request(.POST, url,parameters:params as? [String : AnyObject]).responseString(completionHandler: {response in
            switch response.result {
            case .Success(let str):
                print("请求地址为: \(url),请求参数为:\(params)")
                success(json: str)
            case .Failure(let error):
                print(error)
                fail(error: error)
            }
        })
    }
    
}

