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
        self.detailWebView.dataDetectorTypes = UIDataDetectorTypes.PhoneNumber
        
    }
    
    func settingWebView(url:String) {
        
        self.detailWebView.scalesPageToFit = true
        let urls = NSURL(string: url)
        self.detailWebView.loadRequest(NSURLRequest(URL: urls!))
    }
    
    @IBAction func openAnotherApp(sender: AnyObject) {
        var paramStr = "zhihu://com.zhihu.com/"
        if questionID != "" && answerID != "" {
            paramStr = paramStr + "question/\(questionID)/answer/\(answerID)"
        } else {
            paramStr = paramStr + "question/\(questionID)"
        }
        print(paramStr)
        let url = NSURL(string: paramStr)
        let isExit:Bool = UIApplication.sharedApplication().canOpenURL(NSURL(string: paramStr)!)
        if isExit {
            UIApplication.sharedApplication().openURL(url!)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
