//
//  AllUserViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD

class AllUserViewController: UIViewController {
    
    
    //向服务器发送的请求页面参数
    var currentPage:Int?
    let cellId = "userCellID" //获取ceLLID
    
    var content: [UserModel] = [UserModel]() {
        
        //属性观测器
        didSet { self.tableView1.reloadData() }
    }
    
    
    //MARK:- 懒加载
    lazy var tableView1: UITableView = { [unowned self] in
        let tab = UITableView()
        tab.delegate = self
        tab.dataSource = self
        //隐藏多余行
        tab.tableFooterView = UIView()
        tab.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        let nib = UINib(nibName: "UserViewCell", bundle: nil)
        tab.register(nib, forCellReuseIdentifier: self.cellId)
        self.view.addSubview(tab)
        tab.snp.makeConstraints { (make) -> Void in
            //注释：box距离父视图上下左右边距都是20像素
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(5, 0, 0, 0))
        }
        return tab
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //向服务器请求首页推荐
        self.getNewDatas()
        self.tableView1.reloadData()
       
        
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self,
                                           refreshingAction: #selector(getNewDatas))
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView1.mj_header = header
        
        //上拉
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self,
                                               refreshingAction: #selector(getMoreDatas))
        footer?.setTitle("", for: MJRefreshState.idle)
        
        tableView1.mj_footer = footer


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
extension AllUserViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserViewCell? = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? UserViewCell
        
      
        cell?.icon.sd_setImage(with: URL(string: content[indexPath.row].avator!))
        cell?.userName.text = content[indexPath.row].nickName!
        cell?.signature.text = content[indexPath.row].introduction!
        cell?.userId = content[indexPath.row].userId
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!

    }
}

//MARK:-服务器请求方法的跳转
extension AllUserViewController {
    func getNewDatas(){
        
        //先清空原来的数据
        self.content.removeAll()
        print("向服务器请求首页数据")
        self.currentPage = 0
        
        //将修改信息提交到服务器
        let params:[String:Any] = [
            "number": 10,
            "page": self.currentPage!,
            "userId": 11]
        
        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: getRecommendUser, parameters: params ) { (result, error) in
            
            //停止旋转
            self.tableView1.mj_header.endRefreshing()
            
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result)
                
                print(json)
                let code = json["code"]
                let message = json["message"].string
                
                
                
                if code == 100{
                    print(json["body"])
                    let jsonArrayString: String? = json["body"].description
                    
                    if let users = [UserModel].deserialize(from: jsonArrayString) {
                        //将shares 加入到tableview数据源数组中去
                        self.content = self.content + (users as![UserModel])
                    }
                    
                    
                }
                else {
                    print("没有更多信息了")
                    SVProgressHUD.showError(withStatus: message)
                    
                }
                
            }
        }
    }
    
    //上拉加载更多
    func getMoreDatas(){
        print("加载更多数据")
        //由当前的帖子数量计算获取
        self.currentPage! += 1
        
        //将修改信息提交到服务器
        let params:[String:Any] = [
            "number": 10,
            "page": self.currentPage!,
            "userId": 11]
        
        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: getMoreRecommendUser, parameters: params ) { (result, error) in
            
            //停止旋转
            self.tableView1.mj_footer.endRefreshing()
            
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result)
                print(json)
                let code = json["code"]
                let message = json["message"].string
                
                
                
                if code == 100{
                    print("完善个人信息成功")
                    print(json["body"])
                    var j = 0
                    for i in json["body"]{
                        if let object = shareModel.deserialize(from: json["body"][j].string){
                            j += 1
                            print(object)
                        }
                        
                    }
                    
                    
                }
                else {
                    print("完善个人信息失败")
                    SVProgressHUD.showError(withStatus: message)
                    //如果没有返回更多，页面回滚
                    self.currentPage! -= 1
                    
                }
                
            }
        }
        
    }





}
