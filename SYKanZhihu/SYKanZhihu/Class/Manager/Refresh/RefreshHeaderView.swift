//
//  RefreshHeaderView.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/3/5.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

class RefreshHeaderView: RefreshBaseView {
    class func header() -> RefreshHeaderView {
        let header:RefreshHeaderView = RefreshHeaderView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width,CGFloat(RefreshViewHeight)))
        
        return header
    }
    //最后更新时间
    var lastUpdateTime = NSDate() {
        willSet {
        
        }
        didSet{
            NSUserDefaults.standardUserDefaults().setObject(lastUpdateTime, forKey: RefreshHeaderTimeKey)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.updateTimeLabel()
        }
    }
    //更新时间label
    var lastUpdateTiemLabel:UILabel!
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        self.lastUpdateTiemLabel = UILabel()
        self.lastUpdateTiemLabel.autoresizingMask = .FlexibleWidth
        self.lastUpdateTiemLabel.font = UIFont.boldSystemFontOfSize(12)
        self.lastUpdateTiemLabel.textColor = UIColor.clearColor()
        self.lastUpdateTiemLabel.backgroundColor = UIColor.clearColor()
        self.lastUpdateTiemLabel.textAlignment = .Center
    
        self.addSubview(self.lastUpdateTiemLabel)
    
        //判断NSUserDefault有没有记录时间
        if NSUserDefaults.standardUserDefaults().objectForKey(RefreshHeaderTimeKey) == nil {
            self.lastUpdateTime = NSDate()
        }
        else {
            self.lastUpdateTime = NSUserDefaults.standardUserDefaults().objectForKey(RefreshHeaderTimeKey) as! NSDate
        }
        self.updateTimeLabel()
    
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let stateX:CGFloat = 0
        let stateY:CGFloat = 0
        let stateHeight = self.frame.size.height * 0.5
        let stateWidth = self.frame.size.width
        
        //状态label
        self.statusLabel.frame = CGRectMake(stateX, stateY, stateWidth, stateHeight)
        //时间标签
        let lastUpdateX:CGFloat = 0
        let lastUpdateY = stateHeight
        let lastUpdateHeight = stateHeight
        let lastUpdateWidth = stateWidth
        
        self.lastUpdateTiemLabel.frame = CGRectMake(lastUpdateX, lastUpdateY, lastUpdateWidth, lastUpdateHeight)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        //设置子类尺寸
        var rect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    //更新时间
    func updateTimeLabel() {
        //获取时间
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = formatter.stringFromDate(self.lastUpdateTime)
        //更新时间
        self.lastUpdateTiemLabel.text = "最后刷新时间:" + time
    }
    
    //监听scrollview变化
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !self.userInteractionEnabled || self.hidden {
            return
        }
        
        if self.state == .Refreshing {
            return
        }
        
        if RefreshContentOffSet == keyPath! {
            self.adjustStateWithContentOffSet()
        }
    }
    
    //设置状态
    override  var state:RefreshState {
        willSet {
            if  state == newValue{
                return;
            }
            oldState = state
            setState(newValue)
        }
        didSet{
            switch state{
            case .Normal:
                self.statusLabel.text = RefreshHeaderToRefresh
                if RefreshState.Refreshing == oldState {
                    self.arrowImageView.transform = CGAffineTransformIdentity
                    self.lastUpdateTime = NSDate()
                    UIView.animateWithDuration(RefreshAnimationDuration, animations: {
                        var contentInset:UIEdgeInsets = self.scrollView.contentInset
                        contentInset.top = self.scrollviewOriginalInset.top
                        self.scrollView.contentInset = contentInset
                    })
                    
                }else {
                    UIView.animateWithDuration(RefreshAnimationDuration, animations: {
                        self.arrowImageView.transform = CGAffineTransformIdentity
                    })
                }
                
            case .Pulling:
                self.statusLabel.text = RefreshHeaderRelease
                UIView.animateWithDuration(RefreshAnimationDuration, animations: {
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI ))
                })
                
            case .Refreshing:
                self.statusLabel.text =  RefreshHeaderRefreshing as String;
                
                UIView.animateWithDuration(RefreshAnimationDuration, animations: {
                    let top:CGFloat = self.scrollviewOriginalInset.top + self.frame.size.height
                    var inset:UIEdgeInsets = self.scrollView.contentInset
                    inset.top = top
                    self.scrollView.contentInset = inset
                    var offset:CGPoint = self.scrollView.contentOffset
                    offset.y = -top
                    self.scrollView.contentOffset = offset
                })
            case .WillRefreshing:
                break
            }
        }
    }

    
    //调整
    func adjustStateWithContentOffSet() {
        let currentOffSetY = self.scrollView.contentOffset.y
        let happenOffSetY = -self.scrollviewOriginalInset.top
        
        if currentOffSetY >= happenOffSetY {
            return
        }
        
        if self.scrollView.dragging {
            let normalToPullingOffSetY = happenOffSetY - self.frame.size.height
            if self.state == .Normal && currentOffSetY < normalToPullingOffSetY {
                self.state == .Pulling
            }
            else if self.state == .Pulling && currentOffSetY >= normalToPullingOffSetY {
                self.state == .Normal
            }
        }
        else if self.state == .Pulling {
            self.state = .Refreshing
        }
    }
    
    func addState(state:RefreshState){
        self.state = state
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


