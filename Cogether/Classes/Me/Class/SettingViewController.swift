//
//  SettingViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/27.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

//MARK:- 列表标题
let RecieveInfo = "是否接受通知"

let FeedBack    = "意见反馈"
let VersionInfo  = "版本信息"

let ResetPassWord = "修改密码"
let LoginOut = "退出登录"

class SettingViewController: UIViewController {
    

    
    
    //MARK:- 懒加载tableview
   
    lazy var tableView1: UITableView = { [unowned self] in
        let tab = UITableView()
        tab.delegate = self
        tab.dataSource = self
        //隐藏多余行
        tab.tableFooterView = UIView()
        tab.backgroundColor = UIColor.hexInt(0xf3f3f3)
        self.view.addSubview(tab)
        tab.snp.makeConstraints { (make) -> Void in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        return tab
        }()
    
    //MARK:- 懒加载数据源
    lazy var titleArray:[[String]] = {
        return [[RecieveInfo],
                [FeedBack,VersionInfo],
                [ResetPassWord,LoginOut]]
    
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设置"
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        self.tableView1.backgroundColor = UIColor.hexInt(0xf3f3f3)
        

        // Do any additional setup after loading the view.
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

extension SettingViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.titleArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subTextArr = titleArray[indexPath.section]
        let cellID = "settingcell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = subTextArr[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor.lightGray
        if indexPath.section == 0  {
            if indexPath.row == 0
            {  cell?.accessoryType = .detailDisclosureButton
            }
        }
        if indexPath.section == 2  {
            if indexPath.row == 0 || indexPath.row == 1
            {  cell?.accessoryType = .disclosureIndicator
            }
        }
        
        return cell!

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if indexPath.row == 1 {
                //点击了退出登录
                self.loginOut()
                
            }
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    

}


extension SettingViewController{
    func loginOut(){
    //退出登录
        print("退出登录")
        let alertController = UIAlertController(title: "提示",
                                                message: "确定要退出登录吗？", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "确定", style: .default, handler: {
            action in
            //将登录界面设置为根界面
            let appDelegate  = UIApplication.shared.delegate as! AppDelegate
            appDelegate.loginViewShow()
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    
    }

}
