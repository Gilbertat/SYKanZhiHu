//
//  SYHttpManager.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation
import Alamofire
import Log

class SYHttp {

    /**
     Http get 请求
     
     - parameter url:     请求地址
     - parameter params:  请求参数
     - parameter success: 请求成功回调
     - parameter fail:    请求失败回调
     */
    
    static func get(_ url:String, params:[String:AnyObject]?, success:@escaping (_ json:AnyObject) -> Void,fail:@escaping (_ error:Any) ->Void) {
        var url = url
        
        url = url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        Alamofire.request(.GET, url, parameters: params).responseString(completionHandler: {response in
            switch response.result {
            case.Success(_):
               // Log.debug("请求地址为: \(url) 参数为: \(params)")
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
    
    static func post(_ url:String, params:NSDictionary, success:@escaping (_ json:AnyObject) -> Void, fail:@escaping (_ error:Any) ->Void) {
        
        Alamofire.request(.POST, url,parameters:params as? [String : AnyObject]).responseString(completionHandler: {response in
            switch response.result {
            case .Success(_):
             //   Log.debug("请求地址为: \(url) 参数为: \(params)")
                success(json: response.data!)
            case .Failure(let error):
                print(error)
                fail(error: error)
            }
        })
    }
    
}

