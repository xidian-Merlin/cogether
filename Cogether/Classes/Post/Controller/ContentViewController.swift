//
//  ContentViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/29.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SwiftyJSON

class ContentViewController: UIViewController {
    
    var articleId:Int?
    
    //MARK:-懒加载底部条
    lazy var bottomToolView:UIView = { [unowned self] in
        
        let bottom = UIView()
        self.view.addSubview(bottom)
        bottom.snp.makeConstraints({ (make) in
            make.bottom.equalTo(0)
            make.left.right.equalTo(0)
            make.height.equalTo(44)
        })
        
        //为底部栏添加三个按钮
        
        //先为中间按钮添加约束
        let centerBtn = UIButton()
        centerBtn.setImage(#imageLiteral(resourceName: "User"), for: .normal)
        self.view.addSubview(centerBtn)
        centerBtn.snp.makeConstraints({ (make) in
            make.centerX.equalTo(0)
            make.height.width.equalTo(30)
            make.top.equalTo(7)
        })
        
        let leftBtn = UIButton()
        leftBtn.setImage(#imageLiteral(resourceName: "User"), for: .normal)
        self.view.addSubview(leftBtn)
        leftBtn.snp.makeConstraints({ (make) in
            make.left.equalTo(40)
            make.top.equalTo(7)
            make.width.height.equalTo(30)
        })
        
        let rightBtn = UIButton()
        rightBtn.setImage(#imageLiteral(resourceName: "User"), for: .normal)
        self.view.addSubview(rightBtn)
        rightBtn.snp.makeConstraints({ (make) in
            make.right.equalTo(-40)
            make.top.equalTo(7)
            make.width.height.equalTo(30)
        })
        
        
        
        return UIView()
        
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomToolView.isHidden = false
        
        
        
        
        

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

extension ContentViewController {

    //向服务器请求文章的详细信息
    func getDetailArtical(){
        //将修改信息提交到服务器
        let params:[String:Any] = [
            "id": self.articleId!
           ]
        
        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: getArticleDetailsAPI, parameters: params ) { (result, error) in
            
            //停止旋转
            
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result)
                
//                {articleId：帖子ID
//                    title：帖子标题
//                    label：帖子标签
//                    content：帖子内容
//                    time：发帖时间
//                    userId：发帖用户ID
//                    avator：用户头像
//                    nickName：用户昵称}

                
                
            }


    





}
}
}
