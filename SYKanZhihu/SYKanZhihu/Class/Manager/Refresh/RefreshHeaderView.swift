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
        let header:RefreshHeaderView = RefreshHeaderView(frame: CGRect(x: 0,y: 0, width: UIScreen.main.bounds.width,height: CGFloat(RefreshViewHeight)))
        
        return header
    }
    //最后更新时间
    var lastUpdateTime = Date() {
        willSet {
        
        }
        didSet{
            UserDefaults.standard.set(lastUpdateTime, forKey: RefreshHeaderTimeKey)
            UserDefaults.standard.synchronize()
            self.updateTimeLabel()
        }
    }
    //更新时间label
    var lastUpdateTiemLabel:UILabel!
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        self.lastUpdateTiemLabel = UILabel()
        self.lastUpdateTiemLabel.autoresizingMask = .flexibleWidth
        self.lastUpdateTiemLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.lastUpdateTiemLabel.textColor = UIColor.clear
        self.lastUpdateTiemLabel.backgroundColor = UIColor.clear
        self.lastUpdateTiemLabel.textAlignment = .center
    
        self.addSubview(self.lastUpdateTiemLabel)
    
        //判断NSUserDefault有没有记录时间
        if UserDefaults.standard.object(forKey: RefreshHeaderTimeKey) == nil {
            self.lastUpdateTime = Date()
        }
        else {
            self.lastUpdateTime = UserDefaults.standard.object(forKey: RefreshHeaderTimeKey) as! Date
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
        self.statusLabel.frame = CGRect(x: stateX, y: stateY, width: stateWidth, height: stateHeight)
        //时间标签
        let lastUpdateX:CGFloat = 0
        let lastUpdateY = stateHeight
        let lastUpdateHeight = stateHeight
        let lastUpdateWidth = stateWidth
        
        self.lastUpdateTiemLabel.frame = CGRect(x: lastUpdateX, y: lastUpdateY, width: lastUpdateWidth, height: lastUpdateHeight)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        //设置子类尺寸
        var rect = self.frame
        rect.origin.y = -self.frame.size.height
        self.frame = rect
    }
    
    //更新时间
    func updateTimeLabel() {
        //获取时间
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = formatter.string(from: self.lastUpdateTime)
        //更新时间
        self.lastUpdateTiemLabel.text = "最后刷新时间:" + time
    }
    
    //监听scrollview变化
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !self.isUserInteractionEnabled || self.isHidden {
            return
        }
        
        if self.state == .refreshing {
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
            case .normal:
                self.statusLabel.text = RefreshHeaderToRefresh
                if RefreshState.refreshing == oldState {
                    self.arrowImageView.transform = CGAffineTransform.identity
                    self.lastUpdateTime = Date()
                    UIView.animate(withDuration: RefreshAnimationDuration, animations: {
                        var contentInset:UIEdgeInsets = self.scrollView.contentInset
                        contentInset.top = self.scrollviewOriginalInset.top
                        self.scrollView.contentInset = contentInset
                    })
                    
                }else {
                    UIView.animate(withDuration: RefreshAnimationDuration, animations: {
                        self.arrowImageView.transform = CGAffineTransform.identity
                    })
                }
                
            case .pulling:
                self.statusLabel.text = RefreshHeaderRelease
                UIView.animate(withDuration: RefreshAnimationDuration, animations: {
                    self.arrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI ))
                })
                
            case .refreshing:
                self.statusLabel.text =  RefreshHeaderRefreshing as String;
                
                UIView.animate(withDuration: RefreshAnimationDuration, animations: {
                    let top:CGFloat = self.scrollviewOriginalInset.top + self.frame.size.height
                    var inset:UIEdgeInsets = self.scrollView.contentInset
                    inset.top = top
                    self.scrollView.contentInset = inset
                    var offset:CGPoint = self.scrollView.contentOffset
                    offset.y = -top
                    self.scrollView.contentOffset = offset
                })
            case .willRefreshing:
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
        
        if self.scrollView.isDragging {
            let normalToPullingOffSetY = happenOffSetY - self.frame.size.height
            if self.state == .normal && currentOffSetY < normalToPullingOffSetY {
                self.state == .pulling
            }
            else if self.state == .pulling && currentOffSetY >= normalToPullingOffSetY {
                self.state == .normal
            }
        }
        else if self.state == .pulling {
            self.state = .refreshing
        }
    }
    
    func addState(_ state:RefreshState){
        self.state = state
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


