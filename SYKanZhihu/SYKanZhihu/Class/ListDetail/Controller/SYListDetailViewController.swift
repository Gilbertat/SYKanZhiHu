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
    var catagoryName = ""
    var dataSource:Array<ListDetailModel> = Array()
    @IBOutlet weak var tableView: UITableView!
    var avaterView = UIImageView()
    let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        //tableHeaderView
        self.avaterView.frame = CGRect(x: 0, y: 0, width: self.SCREEN_WIDTH, height: self.SCREEN_WIDTH / 2)
        avaterView.kf_setImageWithURL(URL(string:self.avaterUrl)!)
        self.tableView.tableHeaderView = avaterView
        
        //设置title
        let dataArray = requestDate.components(separatedBy: "-")
        let date = "\(dataArray[0])年\(dataArray[1])月\(dataArray[2])日"
        
        self.title = date + self.catagoryName
        
        
        //请求数据
        self.requestData()
    }
    func requestData() {
        
        //拼接url
        let dataArray = self.requestDate.components(separatedBy: "-")
        let data = "\(dataArray[0])\(dataArray[1])\(dataArray[2])"
        let url = "\(ApiConfig.API_List_Url)/\(data)/\(requestState)"
        
        SYHttp.get(url, params: nil, success: { [unowned self] (json) -> Void in
            let data = try? JSONSerialization.jsonObject(with: json as! Data, options: [])
            let array:NSArray = (data!["answers"] as? NSArray)!
            for dict in array {
                let listDetail:ListDetailModel = ListDetailModel(dict: dict as! NSDictionary)
                self.dataSource.append(listDetail)
            }
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
            
            
            }) { (error) -> Void in
                print(error) //暂不处理错误
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let buttonPosition = (sender as AnyObject).convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: buttonPosition)
        let model:ListDetailModel = self.dataSource[((indexPath as NSIndexPath?)?.section)!]
        let destinationController = segue.destination as! SYUserViewController
        destinationController.userHash = model.authorhash!
        destinationController.navigationItem.title = model.authorname
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

extension SYListDetailViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //取消cell长按效果
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        //根据section取model数据
        let model:ListDetailModel = self.dataSource[((indexPath as NSIndexPath).section)]
        
        //根据section row 获取值
        var string = ApiConfig.API_Aritical_Url + model.questionid!
        
        if (indexPath as NSIndexPath).row == 1 {
            string = ApiConfig.API_Aritical_Url + model.questionid! + "/answer/" + model.answerid!
        }
        
        UIApplication.shared.openURL(URL(string: string)!)
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model:ListDetailModel = self.dataSource[(indexPath as NSIndexPath).section]
        
        if 0 == (indexPath as NSIndexPath).row {
            let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath) as! SYListQuestionTableViewCell
            
            cell.titleLabel.text = model.title
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "answerCell", for: indexPath) as! SYListDetailTableViewCell
            
            
            cell.setAnswer(model)
            
            return cell
        }
    }
    
    
}





