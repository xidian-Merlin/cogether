//
//  EditViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/19.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

/// 定义枚举类型  进入该页面的方式
enum EnterType:Int {

    case REGIST
    case SETTINGINFO
}

//MARK:- 列表标题
let EditSignature  = "标签"
let EditName       = "姓名"
let EditSex        = "性别"

let EditSchool     = "学校"
let EditEducation  = "学历"
let EditLocation   = "地区"
let EditIntroduce  = "介绍"

var EditSignatureInfo :String?
var EditNameInfo:String?
var EditSexInfo:String?
var EditSchoolInfo:String?
var EditEducationInfo:String?
var EditLocationInfo:String?
var EditIntroduceInfo:String?








class EditViewController: UIViewController {
    
    
    
    var enterStyle : EnterType?
    
    
    var overLayView : OverLayView!
    
    
    
    //MARK:- 懒加载topview
    lazy var topView: UIView = { [unowned self] in
        let top = UIView()
        top.backgroundColor = UIColor.white
       
        self.view.addSubview(top)
        top.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(64)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(150)
            
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        return top
        }()
    
    
    //MARK:- 懒加载 button
    lazy var iconButton: UIButton = { [unowned self]  in
        let icon = UIButton()
        icon.addTarget(self, action:#selector(changeIcon), for: UIControlEvents.touchUpInside)
        let mLable = UILabel()
//        
       self.topView.addSubview(icon)
        
        self.topView.addSubview(mLable)
        mLable.font = UIFont.boldSystemFont(ofSize: 13)
        mLable.textColor = UIColor.lightGray
        mLable.textAlignment = NSTextAlignment.center

        mLable.text = "点击更换"
        
        icon.snp.makeConstraints{  (make) -> Void in
            make.top.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(60)

        
        }
        
        mLable.snp.makeConstraints{ (make) -> Void in
            
            make.top.equalTo(85)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
            make.width.equalTo(100)
        
        }
        
        return icon
        
        }()
    
    
    //MARK:- 懒加载 tableview
    lazy var editTableview: UITableView = { [unowned self] in
    
    
        let infoTable = UITableView()
        
        infoTable.delegate = self
        infoTable.dataSource = self
        //隐藏多余行
        infoTable.tableFooterView = UIView()
        infoTable.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        self.view.addSubview(infoTable)
        
        infoTable.snp.makeConstraints({ (make) in
             make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(220, 0, 0, 0))
        })
        
        return infoTable
    
    }()
    
    
    

    //MARK:- 懒加载列表数据
    lazy var titleArray:[String] = {
        return [EditSignature, EditName, EditSex, EditSchool,EditEducation,EditLocation,EditIntroduce]
    }()
    
//    let EditSignatureInfo  = ""
//    var EditNameInfo:String?
//    var EditSexInfo:String?
//    var EditSchoolInfo:String?
//    var EditEducationInfo:String?
//    var EditLocationInfo:String?
//    var EditIntroduceInfo:String?
     //MARK:- 标题信息数组
    lazy var titleInfoArray:[String] = {
        return [EditSignatureInfo, EditNameInfo, EditSexInfo, EditSchoolInfo,EditEducationInfo,EditLocationInfo,EditIntroduceInfo]
                
    }() as! [String]
    
    
   //-MARK:- 懒加载 editName 视图
    lazy var editNameView: UIView = { [unowned self] in
        let editName = UIView()
        editName.backgroundColor = UIColor.white
        
        self.setUpOverLayerView()
        
        //在overlayview上添加 editname 视图
        self.overLayView.addSubview(editName)
        editName.snp.makeConstraints { (make) -> Void in
            
            make.top.equalTo(180)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(150)
            
            //make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        self.navigationController?.view.addSubview(self.overLayView)

        //在修改✊上面添加按键与文本框
        let lable = UILabel()
        lable.text = "编辑姓名"
        editName.addSubview(lable)
        lable.snp.makeConstraints({ (make) in
            make.top.equalTo(5)
            make.centerX.equalTo(editName.snp.centerX)
            make.height.equalTo(24)
            make.width.equalTo(100)
        })
        

        return editName
        }()

    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        
        iconButton.setImage(UIImage(named:"aau"),for:.normal)  //设置图标
        
        //设置导航栏按钮
        self.setUpNavBar()
        self.editTableview.reloadData()
        
        //蒙版
        self.overLayView = OverLayView()
        

        // Do any additional setup after loading the view.
    }

    
    //设置导航栏
    func setUpNavBar(){
        
        self.title = "编辑信息"
       // init(title: String?, style: UIBarButtonItemStyle, target: Any?, action: Selector?)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(back))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(submit))
     
    
    }
    
    func back(){
        //返回上一层
        self.navigationController?.popViewController(animated:true)
    
    }
    
    func submit()  {
        //根据进入的方式的不同，选择不一样的API接口
        var enterAPI : String?
        if self.enterStyle! == .REGIST{
            enterAPI = completeUserInfoAPI
        } else {
            enterAPI = modifyUserInfoAPI
        }
        
       
        //将修改信息提交到服务器
        let params:[String:Any] = ["avator": "",
                                      "education": "研究生",
                                      "gender": 1,
                                      "introduction": "test",
                                      "label": "ios,Swift,Objective-c",
                                      "location": "陕西西安",
                                      "nickName": "ios测试人员1",
                                      "school": "西安电子科技大学",
                                      "userId": THUserHelper.shared.userId!]

        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: enterAPI!, parameters: params as? [String : Any] ) { (result, error) in
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result)
                print(json)
                let code = json["code"]
                let message = json["message"].string
                
                
                
                if code == 100{
                    print("完善个人信息成功")
                    if self.enterStyle! == .REGIST{

                    //当由注册方式进入，如果返回成功，进入主界面
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    //将主页面设置为根目录
                    appDelegate.homePageViewShow()
                    }
                    else {
                        //编辑修改方式进入，如果返回成功
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    

                  
                    
                }
                else {
                    print("完善个人信息失败")
                    SVProgressHUD.showError(withStatus: message)
                    
                }
                
            }
        }
        

        
        
    }
    
    
    //改变头像
    func changeIcon(){
        
        //判断相机是否可用，如果可用就有拍照选项，反正则没有。
        
        let actionSheet: UIActionSheet
        // 判断相机是否可用
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet = UIActionSheet(title: "请选择头像来源", delegate: self as? UIActionSheetDelegate,
                                        cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                        otherButtonTitles: "从相册选择", "拍照")
        } else {
            actionSheet = UIActionSheet(title: "请选择头像来源", delegate: self as? UIActionSheetDelegate,
                                        cancelButtonTitle: "取消", destructiveButtonTitle: nil,
                                        otherButtonTitles: "从相册选择")
        }
        actionSheet.show(in: view)

        
    }
    
    func setUpOverLayerView(){
        self.overLayView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.overLayView.addTarget(self, action: #selector(disappearLayer), for: .touchUpInside)
    
    
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
extension EditViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   
        
        
        let cellID = "cellId"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .value2, reuseIdentifier: cellID)
        }
        cell?.textLabel?.text = titleArray[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.detailTextLabel?.text = titleInfoArray[indexPath.row]
        cell?.textLabel?.textAlignment = NSTextAlignment.left
        cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 15)
        cell?.detailTextLabel?.textColor = RGBA(r: 0.0, g: 0.0, b: 0.0, a: 1.0)
       
       cell?.accessoryType = .disclosureIndicator
          
        return cell!
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        switch indexPath.row {
        case 0:
            print("点击了0行")
        case 1:
            print("点击了第1行")
            
            
            editNameView.isHidden = false
            self.overLayView.isHidden = false
            
            
            //添加蒙版
        default:
            print("balabalabala")
        }
        
    }
    
    func disappearLayer(){
      self.overLayView.isHidden = true
    
    
    }
    
}
//实现UIActionSheetDelegate，判断所选择的项

// MARK: - UIActionSheetDelegate
extension EditViewController: UIActionSheetDelegate {
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        var sourceType: UIImagePickerControllerSourceType = .photoLibrary
        switch buttonIndex {
        case 1: // 从相册选择
            sourceType = .photoLibrary
        case 2: // 拍照
            sourceType = .camera
        default:
            return
        }
        let pickerVC = UIImagePickerController()
        pickerVC.view.backgroundColor = UIColor.white
        pickerVC.delegate = self
        pickerVC.allowsEditing = true
        pickerVC.sourceType = sourceType
        present(pickerVC, animated: true, completion: nil)
    }
}


extension EditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func imagePickerController(picker: UIImagePickerController,
                                       didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismiss(animated: true, completion: nil)
        if (info[UIImagePickerControllerEditedImage] as? UIImage) != nil {
            //将图片发给七牛云图片存储服务器
            
            
            //存储成功，返回图片url，将设置的图片在界面上显示
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

