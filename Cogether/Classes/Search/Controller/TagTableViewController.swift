//
//  TagTableViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/18.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

class TagTableViewController: UITableViewController  {

    let searchText = UITextField()
   //MARK:-懒加载导航栏上搜索视图
    lazy var searchBar:UIView = { [unowned self] in
        let searchView = UIView()
        searchView.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.addSubview(searchView)
        searchView.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(44)
            
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        //在搜索视图上添加搜索框与 确认按钮
        
        let searchButton = UIButton()
        searchButton.setTitle("搜索", for: .normal)
        searchButton.backgroundColor = AppDelegate.tintColor
        
        searchView.addSubview(searchButton)
        searchButton.snp.makeConstraints({ (make) in
            make.right.equalTo(-10)
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.width.equalTo(60)
            
        })
        
        
       
        //初始化后，弹出键盘
        self.searchText.becomeFirstResponder()
        //设置光标右移
        self.searchText.setValue(NSNumber(value: 12), forKey: "paddingLeft")
        

        self.searchText.backgroundColor =  UIColor.hexInt(0xf3f3f3)
        self.searchText.placeholder = "搜索问题／标签"
        
        searchView.addSubview(self.searchText)
        self.searchText.snp.makeConstraints({ (make) in
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(10)
            make.right.equalTo(-80)
        })
        

        
            return searchView
    
    }()
    
    //列表标题数组
    lazy var subtitleArray:[String] = {
        return ["Html","Html5","Css","Css3","JavaScript","JQuery","Json","Ajax","正则表达式","Bootstrap"]
        }()
    
    lazy var titleArray:[String] = {
        return ["热门","前端开发","Android开发","ios开发","Java开发","JavaScript开发","PHP开发","Python开发",".Net开发","开发语言","开发工具", "数据库", "云计算","Linux/Unix"]
    }()
    
    var dic1 = [String:Any]()
    
    override func viewWillAppear(_ animated: Bool) {
        self.searchBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        self.searchBar.isHidden = false
     
        self.navigationItem.hidesBackButton = true
        
        
        //使用的Xib+AutoLayout，以及iOS8之后的自动估算高度
       self.tableView?.estimatedRowHeight = 200;
       self.tableView?.rowHeight = UITableViewAutomaticDimension
        
        
        for i in 0..<titleArray.count {
            dic1[titleArray[i]] = subtitleArray as AnyObject
        
        }
        
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        self.searchBar.isHidden  = true
    }

     override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titleArray.count
    }

    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TagsTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath) as? TagsTableViewCell

        cell?.setTags(tags: dic1[titleArray[indexPath.row]] as! [String])
            
        cell?.lable?.text = titleArray[indexPath.row]
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none

        return cell!
    }
    
    
    //tableview 继承自scrollView 的代理方法
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("我滑动了")
        self.searchText.resignFirstResponder()
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
