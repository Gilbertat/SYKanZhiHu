//
//  SYRankingViewController.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/17.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYRankingViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var page = 0
    var dataSource:Array<topUserModel> = Array()
    var otherArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        
        tableView.estimatedRowHeight = 85.5
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    func loadData() {
        //拼接请求URL
        var urlString = ApiConfig.API_ZhTopUsers_Url
        if 1 == self.segmentedControl.selectedSegmentIndex {
            urlString = "\(urlString)follower"
        } else {
            urlString = "\(urlString)agree"
        }
        urlString = "\(urlString)/\(++self.page)/50"
        
        SYHttp.get(urlString, params: nil, success: { [unowned self] (json) -> Void in
            let data = try? NSJSONSerialization.JSONObjectWithData(json as! NSData, options: [])
            let array:NSArray = (data!["topuser"] as? NSArray)!
            self.otherArray.addObjectsFromArray(array as [AnyObject])
            for dict in array {
                let userModel:topUserModel = topUserModel(dict: dict as! NSDictionary)
                self.dataSource.append(userModel)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
            
            }) { (error) -> Void in
                print(error)
        }
        
    }
    
    @IBAction func changeAction(sender: AnyObject) {
        self.page = 0
        self.dataSource = Array()
        self.otherArray = NSMutableArray()
        self.tableView.reloadData()
        self.loadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showUser" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let model:topUserModel = self.dataSource[indexPath.row]
                let destinationController = segue.destinationViewController as! SYUserViewController
                destinationController.userHash = model.hash!
                destinationController.title = model.name
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

extension SYRankingViewController:UITableViewDataSource,UITableViewDelegate {


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let model:topUserModel = self.dataSource[indexPath.row]
        let other = self.otherArray[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("topUser", forIndexPath: indexPath) as! SYTopUserTableViewCell
        cell.avatarImageView.kf_setImageWithURL(NSURL(string: model.avatar!)!, placeholderImage: UIImage(named:"DefaultAvatar"), optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
            UIGraphicsBeginImageContextWithOptions(cell.avatarImageView.bounds.size, false, UIScreen.mainScreen().scale)
            UIBezierPath(roundedRect: cell.avatarImageView.bounds, cornerRadius: 30).addClip()
            
            image?.drawInRect(cell.avatarImageView.bounds)
            cell.avatarImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
        cell.nameLabel.text = model.name
        cell.indexLabel.text = "\(indexPath.row + 1)"
        cell.SignatureLabel.text = model.signature
        
        var string = other["follower"]!
        
        if 1 == self.segmentedControl.selectedSegmentIndex {
            cell.valueLabel.text = "粉丝数:\(string!)"
        } else {
            string = other["agree"]
            cell.valueLabel.text = "赞同数:\(string!)"
        }
        
        return cell
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == self.dataSource.count - 1 && self.page < 10 {
            self.loadData()
        }
    }

}





