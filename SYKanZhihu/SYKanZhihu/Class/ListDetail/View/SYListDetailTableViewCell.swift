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
        self.voteLabel.text = model.vote
        self.SummaryLabel.text = model.summary
        self.authorLabel.setTitle(model.authorname, forState: .Normal)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
