//
//  RefreshFooterView.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/3/4.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import Foundation

import UIKit

class RefreshFooterView: RefreshBaseView {
    
    class func footer() -> RefreshFooterView {
        
        let footer:RefreshFooterView  = RefreshFooterView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width,
            CGFloat(RefreshViewHeight)))

        return footer
        
    }
    
    var lastRefreshCount = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.statusLabel.frame = self.bounds
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        
        if self.superview != nil {
            self.superview?.removeObserver(self, forKeyPath: RefreshContentSize, context: nil)
        }
        
        if newSuperview != nil {
            newSuperview?.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
            adjustFrameWithContentSize()
        }
    }
    
    //重写frame
    func adjustFrameWithContentSize() {
        let contentHeight = self.scrollView.contentSize.height
        let scrollHeight = self.scrollView.frame.size.height - self.scrollviewOriginalInset.top - self.scrollviewOriginalInset.bottom
        var rect = self.frame
        rect.origin.y = contentHeight > scrollHeight ? contentHeight : scrollHeight
        self.frame = rect
    }
    
    //监听scrollview
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if !self.userInteractionEnabled || self.hidden {
            return
        }
        
        if RefreshContentSize == keyPath {
            adjustFrameWithContentSize()
        }
        else if RefreshContentOffSet == keyPath{
            if self.state == .Refreshing {
                return
            }
            adjustFrameWithContentSize()
        }
    }
    
    func adjustStateWithContentOffSet() {
        let currentOffsetY = self.scrollView.contentOffset.y
        let happenOffSetY = self.happenOffSetY()
        if currentOffsetY <= happenOffSetY {
            return
        }
        
        if self.scrollView.dragging {
            let normalToPullingY = happenOffSetY + self.frame.size.height
            if self.state == .Normal && currentOffsetY > normalToPullingY {
                self.state = .Pulling
            }
            else if self.state == .Pulling {
                self.state = .Refreshing
            }
        }
        
    }
    
    override var state:RefreshState {
        willSet {
            if state == newValue {
                return
            }
            oldState = state
            setState(newValue)
        }
        didSet {
            switch state {
            case .Normal:
                self.statusLabel.text = RefreshFooterToRefresh
                if RefreshState.Refreshing == oldState {
                    self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    UIView.animateWithDuration(RefreshAnimationDuration, animations: { () -> Void in
                        self.scrollView.contentInset.bottom = self.scrollviewOriginalInset.bottom
                    })
                }
                else {
                    UIView.animateWithDuration(RefreshAnimationDuration, animations: { () -> Void in
                        self.arrowImageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                    })
                }
                let deltaH = self.heightForContentBreakView()
                let currentCount = self.totalDataCountInScollView()
                if RefreshState.Refreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount {
                    var offset = self.scrollView.contentOffset
                    offset.y = self.scrollView.contentOffset.y
                    self.scrollView.contentOffset = offset
                }
            case .Pulling:
                self.statusLabel.text = RefreshFooterToRefresh
                UIView.animateWithDuration(RefreshAnimationDuration, animations: { () -> Void in
                    self.arrowImageView.transform = CGAffineTransformIdentity
                })
            case .Refreshing:
                self.statusLabel.text = RefreshFooterRefreshing
                self.lastRefreshCount = self.totalDataCountInScollView()
                UIView.animateWithDuration(RefreshAnimationDuration, animations: { () -> Void in
                    var bottom = self.frame.size.height + self.scrollviewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom = bottom - deltaH
                    }
                    var inset = self.scrollView.contentInset
                    inset.bottom = bottom
                    self.scrollView.contentInset = inset
                })
            case .WillRefreshing:
                break
            }
        }
    }
    
    
    func totalDataCountInScollView() -> Int {
        var totalCount = 0
        if self.scrollView is UITableView {
            let tableView = self.scrollView as! UITableView
            
            for i in 0 ..< tableView.numberOfSections {
                totalCount = totalCount + tableView.numberOfRowsInSection(i)
            }
        }
        else if self.scrollView is UICollectionView {
            let collectionView = self.scrollView as! UICollectionView
            
            for i in 0 ..< collectionView.numberOfSections() {
                totalCount = totalCount + collectionView.numberOfItemsInSection(i)
            }
        }
        return totalCount
    }
    
    
    
    func heightForContentBreakView() -> CGFloat {
        let h = self.scrollView.frame.size.height - self.scrollviewOriginalInset.bottom - self.scrollviewOriginalInset.top
        return self.scrollView.contentSize.height - h
    }
    
    func happenOffSetY() -> CGFloat {
        let detailH = self.heightForContentBreakView()
        if detailH > 0 {
            return detailH - self.scrollviewOriginalInset.top
        }
        else {
            return -self.scrollviewOriginalInset.top
        }
    }
    
    func addState(state:RefreshState) {
        self.state = state
    }
}