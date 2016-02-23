//
//  SYListDetailTableViewCell.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/22.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYListDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var avaterImg: UIImageView!
    @IBOutlet weak var authorLabel: UIButton!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var SummaryLabel: UILabel!
    
    func setAnswer(model:ListDetailModel) {
        
        self.avaterImg.kf_setImageWithURL(NSURL(string: model.avatar!)!)
        
        let vote = Double(model.vote!)
        var stringVote = ""
        if vote >= 1000 {
            let nvalue = vote! / 1000.0
            stringVote = String(format: "%.2gk", nvalue)
        }
        else {
            stringVote = "\(Int(vote!))"
        }
        
        self.voteLabel.text = stringVote
        
        if model.summary == "" {
            self.SummaryLabel.text = "[图片]"
        } else {
            self.SummaryLabel.text = model.summary
        }
        self.authorLabel.setTitle(model.authorname, forState: .Normal)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.voteLabel.clipsToBounds = true
        self.voteLabel.layer.cornerRadius = 2.7
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
