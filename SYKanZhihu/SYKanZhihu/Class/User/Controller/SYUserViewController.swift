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
    var dataSource:Array<ConsentModel> = Array()
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.infoModel = userModel()
        
        tableView.estimatedRowHeight = 170
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.isUserInteractionEnabled = true
  
        requestData(userHash)
        
    }
    
    func requestData(_ userHash:String) {
        
        let url = "\(ApiConfig.API_User_Url)\(userHash)"
        SYHttp.get(url, params:nil, success: { (json) -> Void in
            let data = try? JSONSerialization.jsonObject(with: json as! Data, options: [])

            let infoDict:NSDictionary = data as! NSDictionary
            let extraModel:NSDictionary = infoDict["detail"] as! NSDictionary
            let consentArray:NSArray = infoDict["topanswers"] as! NSArray
            for dict in consentArray {
                let consentModel:ConsentModel = ConsentModel(dict: dict as! NSDictionary)
                self.dataSource.append(consentModel)
            }
            
            self.infoModel = userModel(info: infoDict, extra: extraModel)
      
          
            DispatchQueue.main.async { () -> Void in
                self.tableView.reloadData()
            }
            
            }) { (error) -> Void in
                
            print(error)
        }
        
    }
    //跳转到用户主页
    @IBAction func homePage(_ sender: AnyObject) {
        
        let url = "\(ApiConfig.API_ZhPersonal_Url)/\(self.userHash)"
        UIApplication.shared.openURL(URL(string: url)!)
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "consent" {
            let destinationViewController = segue.destination as! SYConsentViewController
            destinationViewController.dataSource = self.dataSource
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    

    
}
extension SYUserViewController:UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if 1 == (indexPath as NSIndexPath).section {
            return 44
        }
        else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (indexPath as NSIndexPath).section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userState", for: indexPath) as! SYUserTableViewCell
            if self.infoModel.name == nil {
             
            } else {
                cell.receiveUserModel(self.infoModel)
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userTict", for: indexPath) as! SYHighAnswerTableViewCell
            
            return cell
        }
    }
    
}
