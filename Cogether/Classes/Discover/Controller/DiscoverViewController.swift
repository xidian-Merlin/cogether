//
//  DiscoverViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit


class DiscoverViewController: UIViewController {
    
    //MARK:- 懒加载
    lazy var topView: UIView = { [unowned self] in
        let top = UIView()
        top.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(top)
        top.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(44)
        
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        return top
        }()
    
    
    lazy var searchBar: UIButton = { [unowned self] in
        
        let myButton = UIButton()
        
        myButton.setTitle("搜索问题/标签", for: UIControlState.normal)
        
        myButton.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        myButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        
        
        myButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        myButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13) //文字大小
        myButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal) //文字颜色
        
        myButton.frame = CGRect(x: 0, y: 5, width: kScreenH, height: 28)
        
        myButton.addTarget(self, action: #selector(btnClick) , for: UIControlEvents.touchUpInside)
        
        
        
        return myButton
        
        }()
    
  //子标题
    lazy var subTitleArr:[String] = {
        return ["全部","附近"]
    
    }()
    
    /// 子控制器
    lazy var controllers: [UIViewController] = { [unowned self] in
        var cons: [UIViewController] = [UIViewController]()
        for title in self.subTitleArr {
            let con = DicoverSubViewFactory.subFindVcWith(identifier: title)
            cons.append(con)
        }
        return cons
        }()
    
    /// 子标题视图
    lazy var subTitleView: DiscoverSubTitleView = { [unowned self] in
        let view = DiscoverSubTitleView(frame: CGRect(x: 0, y: 69, width: kScreenW, height: 40))
        self.view.addSubview(view)
        return view
        }()
    
    /// 控制多个子控制器
    lazy var PageVc: THPageViewController = {
        let pageVc = THPageViewController(superController: self, controllers: self.controllers)
        pageVc.delegate = self
        self.view.addSubview(pageVc.view)
        return pageVc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        let topV = topView
        topV.addSubview(searchBar)
        
        subTitleView.delegate = self
        subTitleView.titleArray = subTitleArr
        
        //配置子标题视图
        configSubViews()
        
        
        

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




// MARK:- LXFPageViewController代理
extension DiscoverViewController: THPageViewControllerDelegate {
    func  PageCurrentSubControllerIndex(index: NSInteger, pageViewController: THPageViewController) {
        subTitleView.jump2Show(at: index)
    }
}

// MARK:- 配置子标题视图
extension DiscoverViewController {
    func configSubViews() {
        PageVc.view.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view.snp.bottom).offset(-49)
        }
    }
}

// MARK:- LXFFindSubTitleViewDelegate
extension DiscoverViewController: DiscoverSubTitleViewDelegate {
    func findSubTitleViewDidSelected(_ titleView: DiscoverSubTitleView, atIndex: NSInteger, title: String) {
        // 跳转对相应的子标题界面
        PageVc.setCurrentSubControllerWith(index: atIndex)
    }
}
