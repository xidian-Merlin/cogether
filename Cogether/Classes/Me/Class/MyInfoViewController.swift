//
//  MyInfoViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/17.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

//MARK:- 列表标题
let MeSignature  = "标签"
let MeSchool     = "学校"
let MeEducation  = "学历"
let MeLocation   = "所在地"

let MeForHelpd   = "我的求助帖"
let MeForShare   = "我的分享帖"
let MeCollection = "我的收藏"
let Setting      = "设置"

//MARK:- 标题对应的信息
var MeSignatureInfo  = ""
var MeSchoolInfo     = "西安电子科技大学"
var MeEducationInfo  = "研究生"
var MeLocationInfo   = "陕西西安"

var MeForHelpdInfo   = "0"
var MeForShareInfo   = "0"
var MeCollectionInfo = ""
var SettingInfo      = ""


class MyInfoViewController: UIViewController {
    
    
    //MARK:- 懒加载
    lazy var topView: UIImageView = { [unowned self] in
        let top = UIImageView()
        top.image = UIImage(named:"bgImage")
        top.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(top)
        
        top.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(150)
            
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        return top
        }()
    
    lazy var iconView: UIImageView = { [unowned self] in
        let icon = UIImageView()
        icon.image = UIImage(named:"aau.png")
        icon.backgroundColor = UIColor.clear
        self.topView.addSubview(icon)
        icon.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)
            
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        return icon
        }()
    
    
    //懒加载 编辑按钮，直接添加到iamgeView 上会导致无法点击
    lazy var editButton: UIButton = { [unowned self] in
        
        let edit = UIButton()
        
        edit.setTitle("编辑", for: UIControlState.normal)
        
        edit.backgroundColor = UIColor.clear
        
        
        edit.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13) //文字大小
        edit.setTitleColor(UIColor.white, for: UIControlState.normal) //文字颜色
        self.navigationController?.navigationBar.addSubview(edit)
        edit.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(0)
            make.right.equalToSuperview()
            make.height.width.equalTo(50)
            
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        edit.addTarget(self, action: #selector(editClick) , for: UIControlEvents.touchUpInside)
        
        
        
        return edit
        
        }()


    //懒加载 tablevie
    lazy var tableView1: UITableView = { [unowned self] in
        let tab = UITableView()
        tab.delegate = self
        tab.dataSource = self
        //隐藏多余行
        tab.tableFooterView = UIView()
        tab.backgroundColor = UIColor.hexInt(0xf3f3f3)
        self.view.addSubview(tab)
        tab.snp.makeConstraints { (make) -> Void in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(150-36, 0, 0, 0))
        }
        return tab
        }()
    
   //列表标题数组
    lazy var titleArray:[[String]] = {
        return [[MeSignature, MeSchool, MeEducation, MeLocation ],
                [MeForHelpd, MeForShare, MeCollection, Setting ]
        ]
    }()
    
    //标题信息数组
    lazy var titleInfoArray:[[String]] = {
        return [[MeSignatureInfo, MeSchoolInfo, MeEducationInfo, MeLocationInfo],
                [MeForHelpdInfo, MeForShareInfo, MeCollectionInfo, SettingInfo ]
        ]
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        topView.isHidden = false
        editButton.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let icon = iconView
        let edit = editButton
        let tab = tableView1
        

        // Do any additional setup after loading the view.
    }

    
    func editClick(){
        
        print("编辑")
        //跳转进入编辑界面
        let editVc = EditViewController()
        topView.isHidden = true
        editButton.isHidden = true
         self.hidesBottomBarWhenPushed = true
        
 
        EditSignatureInfo = MeSignatureInfo
        EditNameInfo = "猫咪"
        EditSexInfo = "男"
        EditSchoolInfo = MeSchoolInfo
        EditEducationInfo = MeEducationInfo
        EditLocationInfo = MeLocationInfo
        EditIntroduceInfo = "...."
        
        
        
        
        self.navigationController?.pushViewController(editVc, animated: true)
         self.hidesBottomBarWhenPushed = false
        
     
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
extension MyInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subTitleArr = titleArray[section]
        return subTitleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let subTextArr = titleArray[indexPath.section]
        let subTextInfoArr = titleInfoArray[indexPath.section]
        
        
        let cellID = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = subTextArr[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.detailTextLabel?.text = subTextInfoArr[indexPath.row]
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.detailTextLabel?.textColor = RGBA(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
        if indexPath.section == 1  {
            if indexPath.row == 0 || indexPath.row == 1
            {  cell?.accessoryType = .disclosureIndicator
            }
        }
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 3
            { //跳转进入设置界面
                let settingVc = SettingViewController()
                topView.isHidden = true
                editButton.isHidden = true
                self.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(settingVc, animated: true)
                self.hidesBottomBarWhenPushed = false
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

