//
//  ShareViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import MJRefresh
import SwiftyJSON
import SVProgressHUD
import SDWebImage

class ShareViewController: UIViewController {
    //向服务器发送的请求页面参数
    var currentPage:Int?
    let cellId = "shareCellID" //获取ceLLID
    
    var content: [shareModel] = [shareModel]() {
        didSet { self.tableView.reloadData() }
    }

    //MARK:- 懒加载
    lazy var tableView: UITableView = { [unowned self] in
        let tab = UITableView()
        tab.delegate = self
        tab.dataSource = self
        
        tab.rowHeight = UITableViewAutomaticDimension
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tab.estimatedRowHeight = 200
        
        
        //隐藏多余行
        tab.tableFooterView = UIView()
        tab.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        let nib = UINib(nibName: "ShareViewCell", bundle: nil)
        tab.register(nib, forCellReuseIdentifier: self.cellId)
        
        self.view.addSubview(tab)
        tab.snp.makeConstraints { (make) -> Void in
            //注释：box距离父视图上下左右边距都是20像素
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(104, 0, 0, 0))
        }
        return tab
        }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //向服务器请求首页推荐
        self.getNewDatas()
        tableView.reloadData()
        
        //下拉刷新
        let header = MJRefreshNormalHeader(refreshingTarget: self,
                                           refreshingAction: #selector(getNewDatas))
        header?.lastUpdatedTimeLabel.isHidden = true
        tableView.mj_header = header
        
        //上拉
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self,
                                               refreshingAction: #selector(getMoreDatas))
        footer?.setTitle("", for: MJRefreshState.idle)
        
        tableView.mj_footer = footer
        

        
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



// MARK:- UITableViewDelegate & UITableViewDataSource
extension ShareViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ShareViewCell? = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath) as? ShareViewCell
        
      //  var url : NSURL = NSURL(string: "http://img0.bdstatic.com/img/image/shouye/xinshouye/sheji202.jpg")!
       // cell?.icon.image = UIImage(data:NSData(contentsOfURL:url as URL)!, scale: 1.0)
        cell?.icon.sd_setImage(with: URL(string: content[indexPath.row].avator!))
        cell?.nickName.text = content[indexPath.row].nickName!
        cell?.title.text = content[indexPath.row].title!
        cell?.content.text = content[indexPath.row].content!
        cell?.reply.text = "回复" + String(describing: content[indexPath.row].commentNum)
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //跳转进入对应的详细内容界面,并将帖子ID传入，获取帖子的详细信息
        let ContentVc = ContentViewController()
        ContentVc.articleId = content[indexPath.row].articleId!
        
        self.navigationController?.pushViewController(ContentVc, animated: true)
        
        
        
    }
}


//MARK:- 服务器请求方法扩展
extension ShareViewController {

    
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
        
        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: getShareRecommendUpdateAPI, parameters: params ) { (result, error) in
            
            //停止旋转
            self.tableView.mj_header.endRefreshing()
            
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
                    let jsonArrayString: String? = json["body"].description
                  
                    if let shares = [shareModel].deserialize(from: jsonArrayString) {
                        //将shares 加入到tableview数据源数组中去
                        self.content = self.content + (shares as![shareModel])
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
        
        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: getShareRecommendLoadMoreAPI, parameters: params ) { (result, error) in
            
            //停止旋转
            self.tableView.mj_footer.endRefreshing()
            
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
