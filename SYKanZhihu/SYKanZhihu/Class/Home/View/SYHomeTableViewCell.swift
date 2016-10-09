//
//  SYHomeTableViewCell.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/18.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYHomeTableViewCell: UITableViewCell {


    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var stateLabel:UILabel!
    @IBOutlet weak var describeLabel: UILabel!

   
    func reciveList(_ model:HomeModel) {
        
        self.describeLabel.text = model.excerpt
        let dateArray = model.date?.components(separatedBy: "-") //剔除字段中的“-”
        self.dataLabel.text = "\(dateArray![0])年\(dateArray![1])月\(dateArray![2])日" //拼接字符串
        self.stateLabel.text = model.categoryName![model.name!]
        
    }
    
}
