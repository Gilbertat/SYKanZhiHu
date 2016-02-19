//
//  ViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit


class SYHomeViewController: UIViewController {

    var dataSource : Array<HomeModel> = Array()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        httpRequest()
    }
    
    func httpRequest() {
        
        SYHttp.get(ApiConfig.API_Url, params: nil, success: {(json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])
            let array:NSArray = (data!["posts"] as? NSArray)!
            for dict in array {
                let homeModel:HomeModel = HomeModel(dict: dict as! NSDictionary)
                self.dataSource.append(homeModel)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            
        }) { (error) -> Void in
                
            print(error)
                
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.title = "首页"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    
}

extension SYHomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SYHomeTableViewCell
        
        let model:HomeModel = self.dataSource[indexPath.row]
        cell.describeLabel.text = model.excerpt
        cell.dataLabel.text = model.date
        cell.stateLabel.text = model.name
        
        return cell
    }
    
}

