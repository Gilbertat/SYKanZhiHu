//
//  SYTopUserTableViewCell.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/3/1.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYTopUserTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var SignatureLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
