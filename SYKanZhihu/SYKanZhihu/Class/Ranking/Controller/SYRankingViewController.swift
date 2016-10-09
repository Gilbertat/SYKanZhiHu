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
        urlString = "\(urlString)/\(self.page += 1)/50"
        
        SYHttp.get(urlString, params: nil, success: { [unowned self] (json) -> Void in
            let data = try? JSONSerialization.jsonObject(with: json as! Data, options: [])
            let array:NSArray = (data!["topuser"] as? NSArray)!
            self.otherArray.addObjects(from: array as [AnyObject])
            for dict in array {
                let userModel:topUserModel = topUserModel(dict: dict as! NSDictionary)
                self.dataSource.append(userModel)
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
            
            }) { (error) -> Void in
                print(error)
        }
        
    }
    
    @IBAction func changeAction(_ sender: AnyObject) {
        self.page = 0
        self.dataSource = Array()
        self.otherArray = NSMutableArray()
        self.tableView.reloadData()
        self.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let model:topUserModel = self.dataSource[(indexPath as NSIndexPath).row]
                let destinationController = segue.destination as! SYUserViewController
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


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:topUserModel = self.dataSource[(indexPath as NSIndexPath).row]
        let other = self.otherArray[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "topUser", for: indexPath) as! SYTopUserTableViewCell
        cell.avatarImageView.kf_setImageWithURL(URL(string: model.avatar!)!, placeholderImage: UIImage(named:"DefaultAvatar"), optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
            UIGraphicsBeginImageContextWithOptions(cell.avatarImageView.bounds.size, false, UIScreen.mainScreen().scale)
            UIBezierPath(roundedRect: cell.avatarImageView.bounds, cornerRadius: 30).addClip()
            
            image?.drawInRect(cell.avatarImageView.bounds)
            cell.avatarImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
        cell.nameLabel.text = model.name
        cell.indexLabel.text = "\((indexPath as NSIndexPath).row + 1)"
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == self.dataSource.count - 1 && self.page < 10 {
            self.loadData()
        }
    }

}





