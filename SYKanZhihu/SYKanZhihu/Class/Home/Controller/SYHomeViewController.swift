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
    var page = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 85.5
        tableView.rowHeight = UITableViewAutomaticDimension
        self.page = ""
        httpRequest()
    }
    
    func httpRequest() {
        
        let urlString = "\(ApiConfig.API_Url)/\(self.page)"
        SYHttp.get(urlString, params: nil, success: {(json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])
            let array:NSArray = (data!["posts"] as? NSArray)!
            self.page = (array.lastObject!["publishtime"]) as! String //根据此字段获取数据
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
        self.title = "精华"
        navigationController?.hidesBarsOnSwipe = true
    }
    
    //segue传值,用于聚合下列表请求数据
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewList" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let model:HomeModel = self.dataSource[indexPath.row]
                let destinationController = segue.destinationViewController as! SYListDetailViewController
                destinationController.requestDate = model.date!
                destinationController.requestState = model.name!
                destinationController.avaterUrl = model.pic!
                destinationController.catagoryName = model.categoryName![model.name!]!
            }
        }
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
        
        cell.reciveList(model)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == self.dataSource.count - 1 {
            self.httpRequest()
        }
    }
    
    
}

