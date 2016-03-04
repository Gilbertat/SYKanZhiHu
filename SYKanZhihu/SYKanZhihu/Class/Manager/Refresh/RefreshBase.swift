//
//  RefreshBase.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/3/4.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation
import UIKit

//刷新状态
enum RefreshState {
    case Pulling            //松开刷新的状态
    case Normal             //普通状态（没刷新）
    case Refreshing         //正在刷新的状态
    case WillRefreshing
}

//控件位置
enum RefreshViewPosition {
    case Header //头部控件
    case Footer //底部控件
}
//刷新文字颜色
let labelTextColor = UIColor(red: 150.0 / 255.0, green: 150.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)

//刷新视图基类,继承UIView
class RefreshBaseView:UIView {
    
    var scrollView:UIScrollView!
    var scrollviewOriginalInset:UIEdgeInsets!
    
    //视图内部控件
    var statusLabel:UILabel! //刷新状态文字
    var arrowImageView:UIImageView! //刷新箭头
    var activityView:UIActivityIndicatorView! //菊花
    
    //开始刷新的回调
    var beginRefreshingCallBack:(() -> Void)?
    
    var oldState:RefreshState? //初始状态
    
    var state:RefreshState = RefreshState.Normal {
        willSet {
        
        }
        didSet {
        
        }
    }
    
    //设置状态
    func setState(newValue:RefreshState) {
        if self.state != RefreshState.Refreshing { //如果当前状态不是在刷新
            scrollviewOriginalInset = self.scrollView.contentInset
        }
        
        if self.state == newValue {
            return
        }
        
        switch newValue {
        case .Normal:
            self.arrowImageView.hidden = false
            self.activityView.stopAnimating()
            
        case .Pulling:
            break
            
        case .Refreshing:
            self.arrowImageView.hidden = true
            activityView.startAnimating()
            beginRefreshingCallBack!()
            
        case .WillRefreshing:
            break
        }
        
    }
    
    //初始化刷新视图控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        //刷新状态文字
        self.statusLabel = UILabel()
        statusLabel.autoresizingMask = .FlexibleWidth
        statusLabel.font = UIFont.boldSystemFontOfSize(13)
        statusLabel.textColor = labelTextColor
        statusLabel.backgroundColor = UIColor.clearColor()
        statusLabel.textAlignment = .Center
        self.addSubview(statusLabel)
        
        //箭头图片
        self.arrowImageView = UIImageView(image: UIImage(named: "arrow.png"))
        self.arrowImageView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin]
        self.addSubview(self.arrowImageView)
        
        //菊花
        self.activityView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        self.activityView.bounds = self.arrowImageView.bounds
        self.activityView.autoresizingMask = self.arrowImageView.autoresizingMask
        self.addSubview(activityView)
        
        //刷新视图属性
        self.autoresizingMask = .FlexibleWidth
        self.backgroundColor = UIColor.clearColor()
        
        //设置默认状态
        self.state = .Normal
        
    }
    //当layout需要调整时自动调用
    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowX:CGFloat = self.frame.size.width * 0.5 - 100
        self.arrowImageView.center = CGPointMake(arrowX, self.frame.size.height * 0.5)
        self.activityView.center = self.arrowImageView.center
    }
    
    //移除
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if self.superview != nil {
            self.superview?.removeObserver(self, forKeyPath: RefreshContentSize, context:nil)
        }
        
        if newSuperview != nil {
            newSuperview?.addObserver(self, forKeyPath: RefreshContentOffSet, options: .New, context:nil)
            var rect:CGRect = self.frame
            rect.size.width = (newSuperview?.frame.size.width)!
            rect.origin.x = 0
            self.frame = frame
            
            self.scrollView = newSuperview as! UIScrollView
            self.scrollviewOriginalInset = self.scrollView.contentInset
        }
        
    }
    
    //显示在屏幕上
    override func drawRect(rect: CGRect) {
        superview?.drawRect(rect)
        if self.state == .WillRefreshing {
            self.state = .Refreshing
        }
    }
    
    //刷新
    //判断是否在刷新
    func isRefreshing() -> Bool {
        return RefreshState.Refreshing == self.state
    }
    
    //开始刷新
    func beginRefreshing() {
        if self.window != nil {
            self.state = .Refreshing
        }
        else {
            state = .WillRefreshing
            superview?.setNeedsDisplay()
        }
    }
    
    //结束刷新
    func endRefreshing() {
        let delayInSeconds = 0.3
        let popTime:dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds))
        
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            self.state = .Normal
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}