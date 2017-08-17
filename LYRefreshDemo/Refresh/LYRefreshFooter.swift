//
//  LYRefreshFooter.swift
//  taoxinSwiftIphoneApp
//
//  Created by d y n on 2017/8/16.
//  Copyright © 2017年 Xaelink. All rights reserved.
//

import UIKit

public final  class LYRefreshFooter: UIView {
    //刷新闭包
    var lyRefrehBLock: (() ->())!
    //状态
    var refreshStatus:LYRefreshFooterStatus!
    //文字
    lazy  public var contentLable : UILabel = {
        let tempLable = UILabel(frame: self.bounds)
        tempLable.numberOfLines = 0
        tempLable.backgroundColor = UIColor.clear
        tempLable.textColor = UIColor.white
        tempLable.text = "上拉加载更多数据"
        tempLable.textAlignment = .center

        tempLable.font = UIFont(name: "Heiti SC", size: 14)
        return tempLable
        
    }()
    
    //齿轮图标
    lazy public var activityView : UIActivityIndicatorView = {
        let tempActivyView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tempActivyView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        tempActivyView.center = CGPoint(x: 40, y: LYRefreshFooterHeight/2)
        
        return tempActivyView
    }()

    //MARK: 各种初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buildSubView()
    }
    
    public init (refreshBlock: @escaping (()->Void)){
        super.init(frame: CGRect(x: LYRefreshFooterX, y: LYRefreshFooterY, width: LYRefreshFooterWidth, height: LYRefreshFooterHeight))
        self.lyRefrehBLock = refreshBlock
        self.buildSubView()
        
    }
    public init (width: CGFloat, refreshBlock: @escaping (()->Void)) {
        super.init(frame: CGRect(x: LYRefreshFooterX, y: LYRefreshFooterY, width: width, height: LYRefreshFooterHeight))
        self.lyRefrehBLock = refreshBlock
        self.buildSubView()
    }
    
    required  public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
      //MARK: 设置状态
    func setStatus( status:LYRefreshFooterStatus){
        refreshStatus = status
        switch status {
        case .normal:
            setNormalStatus()
            break
        case .waitRefresh:
            setWaitRefreshStatus()
            break
        case .refreshing:
            setRefreshingStatus()
            break
        case .loadover:
            setEndStatusStatus()
            break
        }
    }

    //MARK: 私有方法
    //组建子视图
    func buildSubView()  {
        self.backgroundColor = UIColor.green
        self.addSubview(self.contentLable)
        self.addSubview(self.activityView)
        
    }
}

extension LYRefreshFooter {
    //添加各种状态切换的ui处理方法
    func setNormalStatus() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.activityView.isHidden = true
        self.contentLable.text = "上拉加载更多数据"
    }
    
    
    func setWaitRefreshStatus() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.activityView.isHidden = true
        self.contentLable.text = "松开加载更多数据"
    }
    
    func setRefreshingStatus() {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        self.contentLable.text = "正在加载更多数据..."
    }
    
    func setEndStatusStatus() {
        self.activityView.isHidden = true
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.contentLable.text = "全部加载完毕"
    }
}

