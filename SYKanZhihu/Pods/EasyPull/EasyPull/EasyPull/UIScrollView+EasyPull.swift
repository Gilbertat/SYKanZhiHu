//
//  UIScrollView+EasyPull.swift
//  Demo
//
//  Created by 荣浩 on 16/2/22.
//  Copyright © 2016年 荣浩. All rights reserved.
//

import UIKit

extension UIScrollView {
// MARK: - associateKeys
    fileprivate struct AssociatedKeys {
        static var ContentOffsetObserver = "easy_ContentOffsetObserver"
        static var OnceToken = "easy_OnceToken"
    }
// MARK: - constant and veriable and property
    fileprivate var Observer: EasyObserver {
        get {
            if let obj = objc_getAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver) as? EasyObserver {
                return obj
            } else {
                let obj = EasyObserver(scrollView: self)
                objc_setAssociatedObject(self, &AssociatedKeys.ContentOffsetObserver, obj, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return obj
            }
        }
    }

// MARK: - public method
    /**
    add drop pull to refresh
    
    - parameter action:         excuting action
    - parameter customDropView: custom view(need to implement the EasyViewManual protocol). default is nil.
    */
    public func easy_addDropPull(_ action: @escaping (() ->Void), customDropView: EasyViewManual? = nil) {
        Observer.dropPullEnable = true
        Observer.dropAction = action
        if let view = customDropView {
            Observer.DropView = view
        }
        addContentOffsetObserver()
    }
    
    /**
     stop drop pull
     */
    public func easy_stopDropPull() {
        Observer.stopDropExcuting()
    }
    /**
     trigger drop Excuting Directly
     */
    public func easy_triggerDropExcuting() {
        Observer.triggerDropExcuting()
    }
    
    /**
     add up pull refresh (Manual Mode)
     
     - parameter action:       excuting action
     - parameter customUpView: custom view(need to implement the EasyViewManual protocol). default is nil.
     */
    public func easy_addUpPullManual(_ action: @escaping (() ->Void), customUpView: EasyViewManual? = nil) {
        Observer.upPullEnable = true
        Observer.upPullMode = .easyUpPullModeManual
        Observer.upAction = action
        if let view = customUpView {
            Observer.UpViewForManual = view
        }
        addContentOffsetObserver()
    }
    
    /**
     add up pull refresh (Automatic Mode)
     
     - parameter action:       excuting action
     - parameter customUpView: custom view(need to implement the EasyViewAutomatic protocol). default is nil.
     */
    public func easy_addUpPullAutomatic(_ action: @escaping (() ->Void), customUpView: EasyViewAutomatic? = nil) {
        Observer.upPullEnable = true
        Observer.upPullMode = .easyUpPullModeAutomatic
        Observer.upAction = action
        if let view = customUpView {
            Observer.UpViewForAutomatic = view
        }
        addContentOffsetObserver()
    }
    
    /**
     stop up pull
     */
    public func easy_stopUpPull() {
        Observer.stopUpExcuting()
    }
    
    /**
     enable up pull
     */
    public func easy_enableUpPull() {
        Observer.enableUpExcuting()
    }
    
    /**
     unable up pull (already load all)
     */
    public func easy_unableUpPull() {
        Observer.unableUpExcuting()
    }
    
    /**
     release all of action
     */
    public func easy_releaseAll() {
        Observer.dropAction = nil
        Observer.upAction = nil
    }
    
// MARK: private method
    fileprivate func addContentOffsetObserver() {
        guard objc_getAssociatedObject(self, &AssociatedKeys.OnceToken) == nil else { return }
        
        objc_setAssociatedObject(self, &AssociatedKeys.OnceToken, "Runed", .OBJC_ASSOCIATION_RETAIN)
        addObserver(Observer, forKeyPath: "contentOffset", options: .new, context: nil)
    }
}
