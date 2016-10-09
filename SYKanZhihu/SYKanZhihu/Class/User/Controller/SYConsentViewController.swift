//
//  SYConsentViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/29.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYConsentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource:Array<ConsentModel> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let view = UIView()
        self.tableView.tableFooterView = view
        
        
        self.title = "高票答案"
        
        tableView.reloadData()
    }
    
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
extension SYConsentViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let model:ConsentModel = self.dataSource[(indexPath as NSIndexPath).row]
        var url = ""
        if model.ispost == "0" {
            url = ApiConfig.API_ZhiHu_Url + model.link!
        } else {
            url = ApiConfig.API_ZhuanLan_Url + model.link!
        }
        
        UIApplication.shared.openURL(URL(string: url)!)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "consent", for: indexPath) as! SYConsentTableViewCell
        
        let model:ConsentModel = self.dataSource[(indexPath as NSIndexPath).row]
        
        cell.refreshView(model)
        
        return cell
    }
}
