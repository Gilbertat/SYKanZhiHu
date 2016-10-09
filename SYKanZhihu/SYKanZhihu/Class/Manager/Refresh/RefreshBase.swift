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
    case pulling            //松开刷新的状态
    case normal             //普通状态（没刷新）
    case refreshing         //正在刷新的状态
    case willRefreshing
}

//控件位置
enum RefreshViewPosition {
    case header //头部控件
    case footer //底部控件
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
    
    var state:RefreshState = RefreshState.normal {
        willSet {
        
        }
        didSet {
        
        }
    }
    
    //设置状态
    func setState(_ newValue:RefreshState) {
        if self.state != RefreshState.refreshing { //如果当前状态不是在刷新
            scrollviewOriginalInset = self.scrollView.contentInset
        }
        
        if self.state == newValue {
            return
        }
        
        switch newValue {
        case .normal:
            self.arrowImageView.isHidden = false
            self.activityView.stopAnimating()
            
        case .pulling:
            break
            
        case .refreshing:
            self.arrowImageView.isHidden = true
            activityView.startAnimating()
            beginRefreshingCallBack!()
            
        case .willRefreshing:
            break
        }
        
    }
    
    //初始化刷新视图控件
    override init(frame: CGRect) {
        super.init(frame: frame)
        //刷新状态文字
        self.statusLabel = UILabel()
        statusLabel.autoresizingMask = .flexibleWidth
        statusLabel.font = UIFont.boldSystemFont(ofSize: 13)
        statusLabel.textColor = labelTextColor
        statusLabel.backgroundColor = UIColor.clear
        statusLabel.textAlignment = .center
        self.addSubview(statusLabel)
        
        //箭头图片
        self.arrowImageView = UIImageView(image: UIImage(named: "arrow.png"))
        self.arrowImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        self.addSubview(self.arrowImageView)
        
        //菊花
        self.activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.activityView.bounds = self.arrowImageView.bounds
        self.activityView.autoresizingMask = self.arrowImageView.autoresizingMask
        self.addSubview(activityView)
        
        //刷新视图属性
        self.autoresizingMask = .flexibleWidth
        self.backgroundColor = UIColor.clear
        
        //设置默认状态
        self.state = .normal
        
    }
    //当layout需要调整时自动调用
    override func layoutSubviews() {
        super.layoutSubviews()
        let arrowX:CGFloat = self.frame.size.width * 0.5 - 100
        self.arrowImageView.center = CGPoint(x: arrowX, y: self.frame.size.height * 0.5)
        self.activityView.center = self.arrowImageView.center
    }
    
    //移除
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.superview != nil {
            self.superview?.removeObserver(self, forKeyPath: RefreshContentSize, context:nil)
        }
        
        if newSuperview != nil {
            newSuperview?.addObserver(self, forKeyPath: RefreshContentOffSet, options: .new, context:nil)
            var rect:CGRect = self.frame
            rect.size.width = (newSuperview?.frame.size.width)!
            rect.origin.x = 0
            self.frame = frame
            
            self.scrollView = newSuperview as! UIScrollView
            self.scrollviewOriginalInset = self.scrollView.contentInset
        }
        
    }
    
    //显示在屏幕上
    override func draw(_ rect: CGRect) {
        superview?.draw(rect)
        if self.state == .willRefreshing {
            self.state = .refreshing
        }
    }
    
    //刷新
    //判断是否在刷新
    func isRefreshing() -> Bool {
        return RefreshState.refreshing == self.state
    }
    
    //开始刷新
    func beginRefreshing() {
        if self.window != nil {
            self.state = .refreshing
        }
        else {
            state = .willRefreshing
            superview?.setNeedsDisplay()
        }
    }
    
    //结束刷新
    func endRefreshing() {
        let delayInSeconds = 0.3
        let popTime:DispatchTime = DispatchTime.now() + Double(Int64(delayInSeconds)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
            self.state = .normal
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
