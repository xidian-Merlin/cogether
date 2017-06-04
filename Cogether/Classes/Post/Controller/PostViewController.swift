//
//  PostViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/15.
//  Copyright © 2017年 tongho. All rights reserved.


import UIKit


class PostViewController: UIViewController {
    
    // 顶部刷新
   
    let helpCv = HelpViewController()
    let shareCv = ShareViewController()
    

    lazy var temView: UIView = { [unowned self] in
        
        let tem = UIView()
        tem.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        tem.frame = CGRect(x: 0, y: 64, width: kScreenH, height: 40)
        return tem
        
        }()

    //MARK:- 懒加载搜索栏
    lazy var searchBar: UIButton = { [unowned self] in
        
        let myButton = UIButton()
        
        myButton.setTitle("输入问题/标签", for: UIControlState.normal)
    
        myButton.backgroundColor = UIColor.white
        
        myButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
       
        myButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13) //文字大小
        myButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal) //文字颜色
        
        myButton.frame = CGRect(x: 0, y: 70, width: kScreenH, height: 30)
        
        myButton.addTarget(self, action: #selector(btnClick) , for: UIControlEvents.touchUpInside)
        
        return myButton
        
    }()
    
    
    
    //MARK:- 懒加载悬浮按钮
    lazy var floatButton: KYButton = { [unowned self] in
        
        let fButton = KYButton()
        
        self.view.addSubview(fButton)
        
        fButton.snp.makeConstraints{ (make) -> Void in
            
            make.bottom.equalTo(-150)
            make.right.equalTo(-50)
            make.height.width.equalTo(55)
            
        }
        
        return fButton
        
        }()
    
 


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(helpCv)
        self.view.addSubview(helpCv.view)
        
        //添加分享帖，但是先隐藏起来
        self.addChildViewController(shareCv)
        self.view.addSubview(shareCv.view)
        shareCv.view.isHidden = true
        
        
        //最后将搜索框添加
        self.view.addSubview(temView)  //挡住下拉箭头
        self.view.addSubview(searchBar)
        
        
     
       
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        let appsArray:[String] = ["求助帖","分享贴"]
        let segment:UISegmentedControl = UISegmentedControl(items:appsArray)
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(PostViewController.segmentDidchange(_:)),
                            for: .valueChanged)  //添加值改变监听
       // segment.tintColor = UIColor(red: 0/255.0, green: 139/255.0, blue:203/255.0, alpha:1)
        self.navigationItem.titleView = segment
        
        searchBar.titleLabel?.text = "fd"
        
        self.setUpFloatButton()
        
        
            
       

        
        
        
       // let segController = UISegmentedControl(["f","f"])
        

        // Do any additional setup after loading the view.
    }

  
    
    func btnClick(){
        
         print("被电击了搜说")
        let sb = UIStoryboard(name: "search", bundle:nil)
        let vc = sb.instantiateViewController(withIdentifier: "tagViewController") as! TagTableViewController
        //跳转进入搜索界面
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
    
    func segmentDidchange(_ segmented:UISegmentedControl){
        
        //如果选项索引为0，显示求助帖，如果选项索引为1，显示分享帖
        if segmented.selectedSegmentIndex == 0 {
            print("求助帖")
            shareCv.view.isHidden = true
            helpCv.view.isHidden = false
        
            
        }
        else{
         
             helpCv.view.isHidden = true
             shareCv.view.isHidden = false
             print("分享帖")
        }
        
        
        
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

extension PostViewController:KYButtonDelegate {
   
    func setUpFloatButton(){
        floatButton.kyDelegate = self
        floatButton.openType = .popUp
        floatButton.plusColor = UIColor.black
        floatButton.fabTitleColor = UIColor.white
        floatButton.add(color: kSystemBlueColor, title: "分享帖", image: UIImage(named: "aau")!) { (item) in
            
            //跳转进入 发分享帖
            let PostShareVc = PostShareViewController()
            PostShareVc.PostviewTitle = "发分享帖"
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(PostShareVc, animated: true)
            self.hidesBottomBarWhenPushed  = false
            
            
            
//            let alert = UIAlertController(title: "测试", message: "Are you ok?", preferredStyle: .alert)
//            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
//            alert.addAction(ok)
//            self.present(alert, animated: true, completion: nil)
            
        }

        floatButton.add(color: kSystemBlueColor, title: "求助帖", image: UIImage(named: "aau")!) { (item) in
            //跳转进入 发分享帖
            let PostShareVc = PostShareViewController()
            PostShareVc.PostviewTitle = "发求助帖"
            self.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(PostShareVc, animated: true)
            self.hidesBottomBarWhenPushed  = false

            
        }
        
        
        
        
    }
    

}



