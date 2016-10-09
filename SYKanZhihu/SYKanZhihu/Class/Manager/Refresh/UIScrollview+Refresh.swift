//
//  UIScrollview+Refresh.swift
//  SYKanZhihu
//
//  Created by shiyue on 16/3/5.
//  Copyright © 2016年 shiyue. All rights reserved.
//

import UIKit

extension UIScrollView {
    func addHeaderWithCallback( _ callback:(() -> Void)!){
        let header:RefreshHeaderView = RefreshHeaderView.header()
        self.addSubview(header)
        header.beginRefreshingCallBack = callback
        header.addState(RefreshState.normal)
    }
    
    func removeHeader()
    {
        
        for view : AnyObject in self.subviews{
            if view is RefreshHeaderView{
                view.removeFromSuperview()
            }
        }
    }
    
    
    func headerBeginRefreshing()
    {
        
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.beginRefreshing()
            }
        }
        
    }
    
    
    func headerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                object.endRefreshing()
            }
        }
        
    }
    
    func setHeaderHidden(_ hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.isHidden = hidden
            }
        }
        
    }
    
    func isHeaderHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshHeaderView{
                let view:UIView  = object as! UIView
                view.isHidden = isHidden
            }
        }
        
    }
    
    func addFooterWithCallback( _ callback:(() -> Void)!){
        let footer:RefreshFooterView = RefreshFooterView.footer()
        
        self.addSubview(footer)
        footer.beginRefreshingCallBack = callback
        
        footer.addState(RefreshState.normal)
    }
    
    
    func removeFooter()
    {
        
        for view : AnyObject in self.subviews{
            if view is RefreshFooterView{
                view.removeFromSuperview()
            }
        }
    }
    
    func footerBeginRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.beginRefreshing()
            }
        }
        
    }
    
    
    func footerEndRefreshing()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                object.endRefreshing()
            }
        }
        
    }
    
    func setFooterHidden(_ hidden:Bool)
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.isHidden = hidden
            }
        }
        
    }
    
    func isFooterHidden()
    {
        for object : AnyObject in self.subviews{
            if object is RefreshFooterView{
                let view:UIView  = object as! UIView
                view.isHidden = isHidden
            }
        }
        
    }
    
    
    
    
}
