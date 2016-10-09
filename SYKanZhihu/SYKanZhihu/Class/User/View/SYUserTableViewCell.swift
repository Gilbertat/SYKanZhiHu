//
//  SYUserTableViewCell.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/2/25.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class SYUserTableViewCell: UITableViewCell {

    @IBOutlet weak var avaterImageView: UIImageView!
    @IBOutlet weak var signatureScrollView: UIScrollView!
    @IBOutlet weak var answersNumberLabel: UILabel!
    @IBOutlet weak var folowLabel: UILabel!
    @IBOutlet weak var folwerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var agreeLabel: UILabel!
    @IBOutlet weak var thanksLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func receiveUserModel(_ userInfo:userModel) {
        
        self.avaterImageView.kf_setImageWithURL(URL(string: userInfo.avatar!)!, placeholderImage: UIImage(named: "DefaultAvatar"))
        let signLabel = UILabel()
        signLabel.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        signLabel.text = userInfo.signature
        if signLabel.text == "" {
            signLabel.text = userInfo.name
        }
        signLabel.textColor = self.descriptionLabel.textColor
        signLabel.sizeToFit()
        self.signatureScrollView.addSubview(signLabel)
        self.signatureScrollView.contentSize = signLabel.bounds.size
        self.descriptionLabel.text = userInfo.description
        self.answersNumberLabel.text = userInfo.answer
        self.folowLabel.text = userInfo.followee
        self.folwerLabel.text = userInfo.follower
        self.agreeLabel.text = userInfo.agree
        self.thanksLabel.text = userInfo.thanks
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
