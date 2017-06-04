//
//  NearByViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import MJRefresh

class NearByViewController: UIViewController {
    
    
    //MARK:- 懒加载
    lazy var tableView1: UITableView = { [unowned self] in
        let tab = UITableView()
        tab.delegate = self
        tab.dataSource = self
        //隐藏多余行
        tab.tableFooterView = UIView()
        tab.backgroundColor = UIColor.hexInt(0xf3f3f3)
        self.view.addSubview(tab)
        tab.snp.makeConstraints { (make) -> Void in
            //注释：box距离父视图上下左右边距都是20像素
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(5, 0, 0, 0))
        }
        return tab
        }()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView1.reloadData()
        
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self,
                                           refreshingAction: #selector(getDatas))
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView1.mj_header = header


        // Do any additional setup after loading the view.
    }
    
    func getDatas(){
        
        
        print("向服务器请求数据")
        tableView1.mj_header.endRefreshing()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



// MARK:- UITableViewDelegate & UITableViewDataSource
extension NearByViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
