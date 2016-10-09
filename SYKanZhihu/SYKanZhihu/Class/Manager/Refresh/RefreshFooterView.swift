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
        
        let footer:RefreshFooterView  = RefreshFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width,
            height: CGFloat(RefreshViewHeight)))

        return footer
        
    }
    
    var lastRefreshCount = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.statusLabel.frame = self.bounds
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if self.superview != nil {
            self.superview?.removeObserver(self, forKeyPath: RefreshContentSize, context: nil)
        }
        
        if newSuperview != nil {
            newSuperview?.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
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
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !self.isUserInteractionEnabled || self.isHidden {
            return
        }
        
        if RefreshContentSize == keyPath {
            adjustFrameWithContentSize()
        }
        else if RefreshContentOffSet == keyPath{
            if self.state == .refreshing {
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
        
        if self.scrollView.isDragging {
            let normalToPullingY = happenOffSetY + self.frame.size.height
            if self.state == .normal && currentOffsetY > normalToPullingY {
                self.state = .pulling
            }
            else if self.state == .pulling {
                self.state = .refreshing
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
            case .normal:
                self.statusLabel.text = RefreshFooterToRefresh
                if RefreshState.refreshing == oldState {
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                    UIView.animate(withDuration: RefreshAnimationDuration, animations: { () -> Void in
                        self.scrollView.contentInset.bottom = self.scrollviewOriginalInset.bottom
                    })
                }
                else {
                    UIView.animate(withDuration: RefreshAnimationDuration, animations: { () -> Void in
                        self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                    })
                }
                let deltaH = self.heightForContentBreakView()
                let currentCount = self.totalDataCountInScollView()
                if RefreshState.refreshing == oldState && deltaH > 0 && currentCount != self.lastRefreshCount {
                    var offset = self.scrollView.contentOffset
                    offset.y = self.scrollView.contentOffset.y
                    self.scrollView.contentOffset = offset
                }
            case .pulling:
                self.statusLabel.text = RefreshFooterToRefresh
                UIView.animate(withDuration: RefreshAnimationDuration, animations: { () -> Void in
                    self.arrowImageView.transform = CGAffineTransform.identity
                })
            case .refreshing:
                self.statusLabel.text = RefreshFooterRefreshing
                self.lastRefreshCount = self.totalDataCountInScollView()
                UIView.animate(withDuration: RefreshAnimationDuration, animations: { () -> Void in
                    var bottom = self.frame.size.height + self.scrollviewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom = bottom - deltaH
                    }
                    var inset = self.scrollView.contentInset
                    inset.bottom = bottom
                    self.scrollView.contentInset = inset
                })
            case .willRefreshing:
                break
            }
        }
    }
    
    
    func totalDataCountInScollView() -> Int {
        var totalCount = 0
        if self.scrollView is UITableView {
            let tableView = self.scrollView as! UITableView
            
            for i in 0 ..< tableView.numberOfSections {
                totalCount = totalCount + tableView.numberOfRows(inSection: i)
            }
        }
        else if self.scrollView is UICollectionView {
            let collectionView = self.scrollView as! UICollectionView
            
            for i in 0 ..< collectionView.numberOfSections {
                totalCount = totalCount + collectionView.numberOfItems(inSection: i)
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
    
    func addState(_ state:RefreshState) {
        self.state = state
    }
}
