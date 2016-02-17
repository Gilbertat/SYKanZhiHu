//
//  SYHttpManager.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation
import Alamofire

class SYHttp {
    func syHttpGetRequest(urlString:String, pageNumber:String) {
        
        let url = "\(urlString)/\(pageNumber)"
        print(url)
        Alamofire.request(.GET, url)
            .responseJSON(completionHandler: {response in
                print(response)
            })
    }
}

