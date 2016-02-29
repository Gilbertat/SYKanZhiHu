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
    let articleDetail = SYArticleDetailViewController()
    var dataSource:Array<ConsentModel> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.title = "高票答案"
        
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "consentDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let model:ConsentModel = self.dataSource[indexPath.row]
                let destinationViewController = segue.destinationViewController as! SYArticleDetailViewController
                var url = ""
                if model.ispost == "0" {
                    url = ApiConfig.API_ZhiHu_Url + model.link!
                } else {
                    url = ApiConfig.API_ZhuanLan_Url + model.link!
                }
                destinationViewController.navigationItem.title = model.title!
                destinationViewController.url = url
            }
        }
    }
    
      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
extension SYConsentViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("consent", forIndexPath: indexPath) as! SYConsentTableViewCell
        
        let model:ConsentModel = self.dataSource[indexPath.row]
        
        cell.refreshView(model)
        
        return cell
    }
}