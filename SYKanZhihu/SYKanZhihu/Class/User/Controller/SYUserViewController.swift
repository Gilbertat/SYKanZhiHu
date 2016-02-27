//
//  SYUserViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/25.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYUserViewController: UIViewController {
    

    var userHash = "" //请求数据需要
    var infoModel:userModel = userModel()
    var extraModel:userModel = userModel()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 170
  
        requestData(userHash)
        
    }
    
    func requestData(userHash:String) {
        
        let url = "\(ApiConfig.API_User_Url)\(userHash)"
        SYHttp.get(url, params:nil, success: { (json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])

            let infoDict:NSDictionary = data as! NSDictionary
            self.infoModel = userModel(info: infoDict)
            self.extraModel = userModel(extra: infoDict["detail"]! as! NSDictionary)
          
            }) { (error) -> Void in
                
            print(error)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
extension SYUserViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if 0 == indexPath.section {
            return UITableViewAutomaticDimension
        }
        else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("userState", forIndexPath: indexPath) as! SYUserTableViewCell
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("userTict", forIndexPath: indexPath) as! SYHighAnswerTableViewCell
            
            return cell
        }
    }
    
}
