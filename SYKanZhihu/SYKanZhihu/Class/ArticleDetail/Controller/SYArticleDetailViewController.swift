//
//  SYArticleDetailViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/24.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYArticleDetailViewController: UIViewController {

    @IBOutlet weak var detailWebView: UIWebView!
    var questionID = ""
    var answerID = ""
    var url = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.settingWebView(url)
        
        self.detailWebView.backgroundColor = UIColor.whiteColor()
    }
    
    func settingWebView(url:String) {
        
        self.detailWebView.scalesPageToFit = true
        let urls = NSURL(string: url)
        self.detailWebView.loadRequest(NSURLRequest(URL: urls!))
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
