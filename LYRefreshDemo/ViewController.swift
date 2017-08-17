//
//  ViewController.swift
//  LYRefreshDemo
//
//  Created by d y n on 2017/8/17.
//  Copyright © 2017年 Xaelink. All rights reserved.
//

import UIKit
let TXWIDTH = UIScreen.main.bounds.size.width
class ViewController:UIViewController,
    UITableViewDelegate,
    UITableViewDataSource
{
    var dataArray: [String]  = Array()
    lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRect.init(x: 0, y: 100, width: TXWIDTH, height: 300), style: UITableViewStyle.plain)
        tempTableView.delegate = self
        tempTableView.dataSource = self
        tempTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tempTableView.backgroundColor = UIColor.yellow
        return tempTableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        // Do any additional setup after loading the view.
        self.view.addSubview(self.tableView)
        self.dataArray.append("11111")
        self.dataArray.append("44444")
        self.dataArray.append("44444")
        self.dataArray.append("44444")
        self.dataArray.append("44444")
        
        self.automaticallyAdjustsScrollViewInsets = false;
        //添加下拉刷新和上拉加载跟多
        tableView.refreshHeader = LYRefreshHeader.init(refreshBlock: { () -> (Void) in
            self.perform(#selector(self.headRefresh), with: nil, afterDelay: 2.0)
        })
        tableView.refreshFooter = LYRefreshFooter.init(refreshBlock: { () -> (Void) in
            self.perform(#selector(self.footerRefresh), with: nil, afterDelay: 2.0)
        })
        
    }
    
    func headRefresh()  {
        if tableView.isHeaderRefreshing() {
            tableView.endHeadRefreshing()
        }
        self.dataArray.removeAll()
        self.dataArray.append("11111")
        self.dataArray.append("44444")
        self.dataArray.append("44444")
        self.dataArray.append("44444")
        self.dataArray.append("44444")
        tableView.reloadData()
        tableView.reSetDataLoad()
        
    }
    func footerRefresh()  {
        if self.tableView.isFooterRefreshing() {
            self.tableView.endFooterRefreshing()
        }
        self.dataArray.append("66666")
        self.dataArray.append("77777")
        self.dataArray.append("66666")
        self.dataArray.append("66666")
        self.tableView.reloadData()
        if self.dataArray.count > 12 {
            tableView.setDataAllLoadOver()
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK:tableview 的delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "aCell")
        aCell.backgroundColor = UIColor.gray
        aCell.textLabel?.text = self.dataArray[indexPath.row]
        return aCell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 0.1))
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 0.1))
    }
}

