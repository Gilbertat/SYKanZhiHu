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
    var infoModel:userModel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.infoModel = userModel()
        
        tableView.estimatedRowHeight = 170
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.userInteractionEnabled = true
  
        requestData(userHash)
        
    }
    
    func requestData(userHash:String) {
        
        let url = "\(ApiConfig.API_User_Url)\(userHash)"
        SYHttp.get(url, params:nil, success: { (json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])

            let infoDict:NSDictionary = data as! NSDictionary
            let extraModel:NSDictionary = infoDict["detail"] as! NSDictionary
            
            self.infoModel = userModel(info: infoDict, extra: extraModel)
      
          
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.tableView.reloadData()
            }
            
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
        
        if 1 == indexPath.section {
            return 44
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("userState", forIndexPath: indexPath) as! SYUserTableViewCell
            if self.infoModel.name == nil {
             
            } else {
                cell.receiveUserModel(self.infoModel)
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("userTict", forIndexPath: indexPath) as! SYHighAnswerTableViewCell
            
            return cell
        }
    }
    
}
