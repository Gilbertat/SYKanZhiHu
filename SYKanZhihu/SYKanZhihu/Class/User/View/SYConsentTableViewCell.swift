//
//  SYConsentTableViewCell.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/29.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYConsentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    func refreshView(model:ConsentModel) {
        
        let vote = Double(model.agree!)
        var stringVote = ""
        if vote >= 1000 {
            let nvalue = vote! / 1000.0
            stringVote = String(format: "%.2gk", nvalue)
        }
        else {
            stringVote = "\(Int(vote!))"
        }
        
        self.agreeLabel.text = stringVote
        
        self.titleLabel.text = model.title
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
