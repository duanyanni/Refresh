//
//  LYRefreshEnum.swift
//  taoxinSwiftIphoneApp
//
//  Created by d y n on 2017/8/16.
//  Copyright © 2017年 Xaelink. All rights reserved.
//

import Foundation

//head 刷新状态
enum LYRefreshHeaderStatus {
    case   normal,  waitRefresh,    refreshing,  end
}

//footer 刷新状态
enum LYRefreshFooterStatus {
    case   normal,  waitRefresh,    refreshing,  loadover
}

//当前刷新对象
enum LYRefreshObject {
    case   none,  header,footer
}
