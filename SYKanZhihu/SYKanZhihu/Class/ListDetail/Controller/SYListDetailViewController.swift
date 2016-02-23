//
//  SYListDetailViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/22.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit
import Kingfisher

class SYListDetailViewController: UIViewController {

    //用于请求数据
    var requestDate = ""
    var requestState = ""
    var avaterUrl = ""
    var dataSource:Array<ListDetailModel> = Array()
    @IBOutlet weak var tableView: UITableView!
    var avaterView = UIImageView()
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.avaterView.frame = CGRectMake(0, 0, self.SCREEN_WIDTH, self.SCREEN_WIDTH / 2)
        avaterView.kf_setImageWithURL(NSURL(string:self.avaterUrl)!)
        self.tableView.tableHeaderView = avaterView
        
        //请求数据
        self.requestData()
    }
    func requestData() {
        let dataArray = self.requestDate.componentsSeparatedByString("-")
        let data = "\(dataArray[0])\(dataArray[1])\(dataArray[2])"
        let url = "\(ApiConfig.API_List_Url)/\(data)/\(requestState)"
        SYHttp.get(url, params: nil, success: { (json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])
            let array:NSArray = (data!["answers"] as? NSArray)!
            for dict in array {
                let listDetail:ListDetailModel = ListDetailModel(dict: dict as! NSDictionary)
                self.dataSource.append(listDetail)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            

            }) { (error) -> Void in
                print(error) //暂不处理错误
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension SYListDetailViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model:ListDetailModel = self.dataSource[indexPath.section]
        if 0 == indexPath.row {
            let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as! SYListQuestionTableViewCell
            cell.titleLabel.text = model.title
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("answerCell", forIndexPath: indexPath) as! SYListDetailTableViewCell
            cell.avaterImg.kf_setImageWithURL(NSURL(string: model.avatar!)!)
            cell.voteLabel.text = model.vote
            cell.SummaryLabel.text = model.summary
            cell.authorLabel.setTitle(model.authorname, forState: .Normal)
            
            return cell
        }
    }
    
}





