//
//  ViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let http = SYHttp()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        http.syHttpGetRequest(baseUrl, pageNumber: page)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

