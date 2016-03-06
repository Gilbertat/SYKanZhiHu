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
        
        self.avaterImg.kf_setImageWithURL(NSURL(string: model.avatar!)!, placeholderImage: UIImage(named:"DefaultAvatar"), optionsInfo: nil) { (image, error, cacheType, imageURL) -> () in
            
            UIGraphicsBeginImageContextWithOptions(self.avaterImg.bounds.size, false, UIScreen.mainScreen().scale)
            UIBezierPath(roundedRect: self.avaterImg.bounds, cornerRadius: 12.5).addClip()
            
            image?.drawInRect(self.avaterImg.bounds)
            self.avaterImg.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
        }
        
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
    
    //swift getter setter 方法
    override var frame:CGRect {
        get {
            return super.frame
        }
        set (newframe) {
            var frame = newframe
            frame.origin.x += 10
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }
    
    override func drawRect(rect: CGRect) {
        
        //切左下右下圆角 添加border
        let borderLayer = CAShapeLayer()
        borderLayer.frame = self.bounds
        borderLayer.path = UIBezierPath(roundedRect:self.bounds, byRoundingCorners:[.BottomLeft,.BottomRight], cornerRadii: CGSizeMake(5.0, 5.0)).CGPath
        borderLayer.shadowPath = UIBezierPath(rect: self.bounds).CGPath
        borderLayer.lineWidth = 0.5
        borderLayer.strokeColor = UIColor.lightGrayColor().CGColor
        borderLayer.fillColor = UIColor.clearColor().CGColor
        
        let layers:NSArray = self.layer.sublayers! as NSArray
        
        if ((layers.lastObject!.isKindOfClass(CAShapeLayer))) {
            layers.lastObject?.removeFromSuperlayer()
        }
        self.layer.addSublayer(borderLayer)

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
