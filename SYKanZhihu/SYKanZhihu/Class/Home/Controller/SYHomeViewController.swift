//
//  ViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit
import AMScrollingNavbar
import EasyPull

class SYHomeViewController: UIViewController {
    
    var dataSource : Array<HomeModel> = Array()
    @IBOutlet weak var tableView: UITableView!
    var page = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 85.5
        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationController?.navigationBar.isTranslucent = false
        self.tabBarController?.tabBar.isTranslucent = false
   
        self.navigationItem.title = "精华"
        
        self.page = ""
        
        httpRequest()
        
        tableView.easy_addDropPull({
            self.checkNew()
        })
    }
    
    //MARK: -请求网络数据
    func httpRequest() {
        
        let urlString = "\(ApiConfig.API_Url)/\(self.page)"
        
        SYHttp.get(urlString, params:nil, success: {[unowned self](json) -> Void in
            let data = try? JSONSerialization.jsonObject(with: json as! Data, options: [])
            let array:NSArray = (data!["posts"] as? NSArray)!
            self.page = (array.lastObject!["publishtime"]) as! String //根据此字段获取数据
            
            for dict in array {
                let homeModel:HomeModel = HomeModel(dict: dict as! NSDictionary)
                self.dataSource.append(homeModel)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
            
            }) { (error) -> Void in
                
                print(error)
        }
        
    }
    //MARK: -查看文章是否有更新
    func checkNew() {
        let checkString = "\(ApiConfig.API_CheckNew)/\(self.page)"
        
        SYHttp.get(checkString, params: nil, success: {[unowned self] (json) -> Void in
            
            let data = try? JSONSerialization.jsonObject(with: json as! Data, options: [])
            
            let result:Bool = data!["result"] as! Bool
            
            if result == true {
                self.tableView.easy_stopDropPull()
            } else {
                print("no new article")
            }
            
            }) { (error) -> Void in
                print(error)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(tableView, delay: 50.0)
        }
        
    }
    
    //MARK: -segue传值,用于聚合下列表请求数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewList" {
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let model:HomeModel = self.dataSource[(indexPath as NSIndexPath).row]
                let destinationController = segue.destination as! SYListDetailViewController
                destinationController.requestDate = model.date!
                destinationController.requestState = model.name!
                destinationController.avaterUrl = model.pic!
                destinationController.catagoryName = model.categoryName![model.name!]!
            }
        }
    }
    
    //MARK: -点击status bar 显示 navigationbar
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
        return true
    }
    
    //MARK: -跳转到二级页面显示navigationBar
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let navigationController = self.navigationController as? ScrollingNavigationController {
            navigationController.showNavbar(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension SYHomeViewController:UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return dataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! SYHomeTableViewCell
        
        let model:HomeModel = self.dataSource[(indexPath as NSIndexPath).row]
        
        cell.reciveList(model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).row == self.dataSource.count - 1 {
                self.httpRequest()
        }
    }
    
    
}

