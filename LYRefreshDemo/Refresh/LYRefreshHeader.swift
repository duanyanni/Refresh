//
//  LYRefreshHeader.swift
//  taoxinSwiftIphoneApp
//
//  Created by d y n on 2017/8/16.
//  Copyright © 2017年 Xaelink. All rights reserved.
//

import UIKit


 public final class LYRefreshHeader: UIView {

    //下拉刷新闭包
    var lyRefrehBLock: (() ->())!
    
    //状态
    var refreshStatus:LYRefreshHeaderStatus!
    //图片
    lazy   public var  image : UIImageView = {
        let tempImageView = UIImageView(frame: CGRect.init(x: 0, y: 0, width: 18, height: 30))
        tempImageView.center = CGPoint(x: 40, y: LYRefreshHeaderHeight/2)
        tempImageView.image = UIImage(named: "lc_refresh_down")
        return tempImageView
    }()
    
    //文字
    lazy  public var contentLable : UILabel = {
        let tempLable = UILabel(frame: self.bounds)
        tempLable.numberOfLines = 0
        tempLable.backgroundColor = UIColor.clear
        tempLable.textColor = UIColor.white
        tempLable.text = "下拉可以刷新"
        tempLable.font = UIFont(name: "Heiti SC", size: 14)
        tempLable.textAlignment = .center
        return tempLable
        
    }()
    
    //齿轮图标
    lazy public var activityView : UIActivityIndicatorView = {
        let tempActivyView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        tempActivyView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        tempActivyView.center = CGPoint(x: 40, y: LYRefreshHeaderHeight/2)

        return tempActivyView
    }()
    
    
    
    
    
    //MARK: 各种初始化方法
    public override init(frame: CGRect) {
        super.init(frame: frame)
        buildSubView()
    }
    
    public init (refreshBlock: @escaping (()->Void)){
        super.init(frame: CGRect(x: LYRefreshHeaderX, y: LYRefreshHeaderY, width: LYRefreshHeaderWidth, height: LYRefreshHeaderHeight))
        self.lyRefrehBLock = refreshBlock
        self.buildSubView()
        
    }
    public init (width: CGFloat, refreshBlock: @escaping (()->Void)) {
        super.init(frame: CGRect(x: LYRefreshHeaderX, y: LYRefreshHeaderY, width: width, height: LYRefreshHeaderHeight))
        self.lyRefrehBLock = refreshBlock
        self.buildSubView()
    }
    
    required  public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 设置状态
    func setStatus(status:LYRefreshHeaderStatus)  {
        self.refreshStatus = status
        switch status {
        case .normal:
            self.setNormalStatus()
            break
            
        case .waitRefresh:
            self.setWaitRefreshStatus()
            break
            
        case .refreshing:
            self.setRefreshingStatus()
            break
            
        case .end:
            self.setEndStatusStatus()
            break
        }
    }
    //MARK: 私有方法
    //组建子视图
    func buildSubView()  {
        self.backgroundColor = UIColor.green
        self.addSubview(self.contentLable)
        self.addSubview(self.image)
        self.addSubview(self.activityView)
        
    }

}

extension LYRefreshHeader {
    //添加各种状态切换的ui处理方法
    func setNormalStatus() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.activityView.isHidden = true
        self.contentLable.text = "下拉可以刷新"
        self.image.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations:{
            self.image.transform = CGAffineTransform.identity
        })
    }
    
    
    func setWaitRefreshStatus() {
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.activityView.isHidden = true
        self.contentLable.text = "松开立即刷新"
        self.image.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations:{
            self.image.transform = CGAffineTransform(rotationAngle: CGFloat (Double.pi))
        })
    }
    
    func setRefreshingStatus() {
        self.activityView.isHidden = false
        self.activityView.startAnimating()
        self.contentLable.text = "正在刷新数据..."
        self.image.isHidden = true
        //反转180度
            self.image.transform = CGAffineTransform(rotationAngle: CGFloat (Double.pi))
    }
    
    func setEndStatusStatus() {
        self.activityView.isHidden = false
        
        if self.activityView.isAnimating {
            self.activityView.stopAnimating()
        }
        self.contentLable.text = "完成刷新"
        self.image.isHidden = true
    }
}
