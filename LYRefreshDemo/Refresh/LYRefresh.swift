//
//  LYRefresh.swift
//  taoxinSwiftIphoneApp
//
//  Created by d y n on 2017/8/16.
//  Copyright © 2017年 Xaelink. All rights reserved.
//

import Foundation
import UIKit

//if:满足条件执行
//guard不满足条件才执行，相当于oc 的ASSert
//set的参数是newValue，是隐士参数

extension UIScrollView {
    
    var isHasObServer:Bool {
        get {
            let result = getAssociated(key: "isHasObServer")
            //guard就是assert
            guard result != nil else {
                return false
            }
            return result as! Bool
            
        }
        //set的参数是newValue，是隐士参数
        set {
            setAssociated(key: "isHasObServer", object: newValue)
        }
    }
    
    //当前刷新对象
    var refreshObj: LYRefreshObject {
        get {
            let result = getAssociated(key: "refreshObj")
            guard result != nil else {
                return .none
            }
            return result as! LYRefreshObject
            
        }
        set {
            setAssociated(key: "refreshObj", object: newValue)
            
        }
    }
    
    //上次刷新对象
    var lastRefreshObj: LYRefreshObject {
        get {
            let result = getAssociated(key: "lastRefreshObj")
            guard result != nil else {
                return .none
            }
            return result as! LYRefreshObject
            
        }
        set {
            setAssociated(key: "lastRefreshObj", object: newValue)
        }
    }
    
    //header
    public var  refreshHeader: LYRefreshHeader? {
        get {
            let result = getAssociated(key: "refreshHeader") as? LYRefreshHeader
            return result
            
        }
        
        set {
            guard newValue != nil else {
                print("header 为空")
                return
            }
            setAssociated(key: "refreshHeader", object: newValue!)
            let result = getAssociated(key: "refreshHeader") as? LYRefreshHeader
            
            if  result != nil  {
                self.addSubview(result!)
            }
            //添加滑动监听
            self.addOffsetObserver()
            
            //添加scrollview的拖拽手势监听
            weak var weakSelf = self
            weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(self.scrollViewDragging(_:)))

            
        }
    }
    
    //footer
    public var  refreshFooter: LYRefreshFooter? {
        get {
            let result = getAssociated(key: "refreshFooter") as? LYRefreshFooter
            return result
            
        }
        
        set {
            guard newValue != nil else {
                print("footer 为空")
                return
            }
            setAssociated(key: "refreshFooter", object: newValue!)
            let result = getAssociated(key: "refreshFooter") as? LYRefreshFooter
            
            if  result != nil  {
                result!.isHidden = true

                self.addSubview(result!)
            }
            //添加滑动监听
            self.addOffsetObserver()
            //添加scrollview的拖拽手势监听
            weak var weakSelf = self
            weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(self.scrollViewDragging(_:)))
        }
    }

}

//动态绑定属性
extension UIScrollView {
    
    fileprivate func getAssociated(key:String)->Any? {
        let assKey = UnsafeRawPointer(bitPattern: key.hashValue)
        let result = objc_getAssociatedObject(self, assKey)
        return result
    }
    
    fileprivate func setAssociated(key:String,object:Any) {
        let assKey = UnsafeRawPointer(bitPattern: key.hashValue)
        objc_setAssociatedObject(self, assKey, object, .OBJC_ASSOCIATION_RETAIN)
        
    }
}


//需要的几个方法
extension UIScrollView {
    
    //header
    //是否正在刷新
    public func isHeaderRefreshing() -> Bool {
        guard self.refreshHeader != nil else {
            return false
        }
        return (self.refreshHeader!.refreshStatus == LYRefreshHeaderStatus.refreshing) ? true: false
    }
    //结束刷新
    public func endHeadRefreshing() {
        
        guard self.refreshHeader != nil else{
            return
        }
        weak var weakSelf = self

        let insetTop = self.contentInset.top
        
        if self.lastRefreshObj == .header || self.lastRefreshObj == .none {
            weakSelf!.setContentOffset(CGPoint.init(x: 0, y: -insetTop), animated: true)
        }
        self.refreshHeader?.setStatus(status: .end)
        self.lastRefreshObj = LYRefreshObject.header
        
        
    }
    //footer
    //是否正在刷新

    public func isFooterRefreshing() -> Bool {
        guard self.refreshFooter != nil else{
            return false
        }
        
        return self.refreshFooter!.refreshStatus == .refreshing ? true: false
    }
    
    //结束刷新
    public func endFooterRefreshing() {
        guard self.refreshFooter != nil else{
            return
        }
        weak var weakSelf = self
        let size = weakSelf!.contentSize
        weakSelf!.contentSize = CGSize(width: size.width, height: size.height-LYRefreshFooterHeight)
        //数据没有填满frame
        if size.height < weakSelf!.bounds.size.height {
            
            weakSelf!.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
        }
            //数据已经充满frame
        else
        {
            let offSet = weakSelf!.contentSize.height - weakSelf!.bounds.size.height
            weakSelf!.setContentOffset(CGPoint.init(x: 0, y: offSet), animated: true)
        }
        self.refreshFooter!.setStatus(status: LYRefreshFooterStatus.normal)
        self.refreshFooter!.isHidden = true
        
        lastRefreshObj = .footer
    }
    //footer数据全部加载完成
    public func setDataAllLoadOver() {
        guard self.refreshFooter != nil else{
            return
        }
        weak var weakSelf = self
        let size = weakSelf?.contentSize
        self.refreshFooter?.isHidden = false
        self.refreshFooter?.frame = CGRect(x: LYRefreshFooterX, y: size!.height, width: LYRefreshFooterWidth, height: LYRefreshFooterHeight)
        weakSelf?.contentSize = CGSize(width: size!.width, height: size!.height + LYRefreshFooterHeight)
        self.refreshFooter?.setStatus(status: .loadover)
    }
    
    //下拉刷新的footer重置
    public func reSetDataLoad () {
        guard self.refreshFooter != nil else{
            return
        }
        self.refreshFooter?.isHidden = true
        self.refreshFooter?.setStatus(status: .normal)        
    }
    //添加contentOffset观察者
    func addOffsetObserver()  {
        //第一次添加观察者
        weak var weakSelf = self
        guard self.isHasObServer == true else {
            self.addObserver(weakSelf!,
                             forKeyPath: "contentOffset",
                             options: NSKeyValueObservingOptions.new,
                             context: nil)
            self.isHasObServer = true
            return
        }
    }
    
    //一次观察者
    public func removeOffsetObserver() {
        if self.isHasObServer {
            weak var weakself = self
            self.removeObserver(weakself!,
                                forKeyPath: "contentOffset",
                                context: nil )
        }
    }
}

//未知相关监听方法
extension UIScrollView {
    
     //MARK: 滑动监测
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            
            //当前的content 偏移量
            let offSet = self.contentOffset.y
            //scrollview 视图的高度
            let scorllHeight = self.bounds.size.height
            
            //content与frame的差量
            let inset = self.contentInset
            
            //显示的偏移量
            var currentOffSet = offSet + scorllHeight - inset.bottom
            
            //cell的总高度
            let maxNumOffset = self.contentSize.height
            
            //数据未充满屏幕的情况,即cell未占满scrollview的frame
            if scorllHeight > maxNumOffset {
              currentOffSet = offSet + maxNumOffset - inset.bottom
            }
            
            //y为负数死向下拉，
            if offSet < 0
            {
                guard self.refreshHeader != nil else {
                    return
                }
                self.scrollHeader(offSet)
                self.refreshObj = LYRefreshObject.header
                
            }
            //数据占满scroll的frame 同时滑动到最底部
            else if  currentOffSet > maxNumOffset && maxNumOffset >= scorllHeight
            {
                guard self.refreshFooter != nil else {
                    return
                }
                
                guard self.refreshFooter!.refreshStatus != LYRefreshFooterStatus.loadover else {
                    return
                }
                //currentOffSet-maxNumOffset滑动到底部之后的拖拽y值
                self.scrollFooter(currentOffSet-maxNumOffset)
                
                self.refreshObj = .footer
            }
            else {
                self.refreshObj = .none
            }
        }
    }
    
    //下拉刷新
    func scrollHeader(_ offset:CGFloat)  {
        guard self.refreshHeader != nil else {
            print("Header加载失败")
            return
        }
        
        //不处理刷新中状态
        guard self.refreshHeader?.refreshStatus != LYRefreshHeaderStatus.refreshing else {
            return
        }
        //content与frame的差量
        let insetTop = self.contentInset.top
        //header已完全展示.向下为负
        if offset + insetTop < -LYRefreshHeaderHeight
        {
            self.refreshHeader?.setStatus(status: .waitRefresh)
        }
        //header未完全展示
        else if offset + insetTop == 0
        {
            self.refreshHeader?.setStatus(status: .normal)
        }
        else
        {
            guard self.refreshHeader?.refreshStatus != LYRefreshHeaderStatus.end else {
                return
            }
            self.refreshHeader?.setStatus(status: .normal)
        }
    }
    
    //加载更多
    func scrollFooter(_ offset:CGFloat)  {
        weak var weakSelf = self

        guard self.refreshFooter != nil else {
            print("Footer加载失败")
            return
        }
        
        //不处理刷新中状态
        guard self.refreshFooter?.refreshStatus != LYRefreshFooterStatus.refreshing else {
            return
        }
        self.refreshFooter?.isHidden = false
        self.refreshFooter?.frame = CGRect(x: LYRefreshFooterX, y: weakSelf!.contentSize.height, width: LYRefreshFooterWidth, height: LYRefreshFooterHeight)
        
        //未完全展示
        if offset > LYRefreshFooterHeight {
           self.refreshFooter?.setStatus(status: .waitRefresh)
        }
        else
        {
            self.refreshFooter?.setStatus(status: .normal)
        }
        
    }
    //拖拽
    func scrollViewDragging(_ pan : UIPanGestureRecognizer)  {
        if pan.state == .ended {
            if self.refreshObj == .header {
                self.dragHeader()
                
            }
            else if self.refreshObj == .footer {
                self.dragFooter()
            }
        }
    }
    //header向下拖拽(说明此时header已完全展示，再下拉就是舒心)
    func dragHeader()  {
        weak var weakSelf = self
        guard self.refreshHeader != nil else {
            print("Header加载失败")
            return
        }
        
        //content与frame的差量
        let insetTop = self.contentInset.top

        if self.refreshHeader!.refreshStatus == .waitRefresh {
            weakSelf!.setContentOffset(CGPoint.init(x: 0,
y: -(LYRefreshHeaderHeight+insetTop)),
                                                    animated: true)
           
            //切换状态
            self.refreshHeader?.setStatus(status: .refreshing)
            if self.refreshHeader?.lyRefrehBLock! != nil
            {
                self.refreshHeader?.lyRefrehBLock!()
            }
            
        }
    }
    
    //footer向下拖拽(说明此时footer已完全展示，再下拉就是加载更多)
    func dragFooter()  {
        weak var weakSelf = self
        guard self.refreshFooter != nil else {
            print("Footer加载失败")
            return
        }
        if self.refreshFooter!.refreshStatus == .waitRefresh {
            let size = weakSelf?.contentSize
            weakSelf?.contentSize = CGSize(width: size!.width, height: size!.height+LYRefreshFooterHeight)
            //数据没有填满frame
            if size!.height < weakSelf!.bounds.size.height {
                
                weakSelf!.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            }
                //数据已经充满frame
            else
            {
                let offSet = weakSelf!.contentSize.height - weakSelf!.bounds.size.height
                weakSelf!.setContentOffset(CGPoint.init(x: 0, y: offSet), animated: true)
                
            }
            //切换状态
            self.refreshFooter?.setStatus(status: .refreshing)
            
            if self.refreshFooter?.lyRefrehBLock! != nil
            {
                self.refreshFooter?.lyRefrehBLock!()
            }
            
           
        }
    }

    
    
}


