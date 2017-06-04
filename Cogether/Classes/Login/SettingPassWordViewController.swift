//
//  SettingPassWordViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/24.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SwiftyJSON
import SVProgressHUD

class SettingPassWordViewController: UIViewController {
    
    var userName:String?
    

    @IBOutlet weak var setPassword: UITextField!
    @IBOutlet weak var setPasswordAgain: UITextField!
    @IBAction func submit(_ sender: UIButton) {
        //比较前后两次输入的密码是否一致
        if   setPassword.text != setPasswordAgain.text {
            
            SVProgressHUD.showError(withStatus: "两次密码输入不一致")
            return
            
        }
       
        //提交注册密码等信息
        let params:[String:String] = ["userName":userName!,
                      "password":setPassword.text!]
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: doRegistAPI, parameters: params as [String : String] ) { (result, error) in
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result)
                print(json)
                let code = json["code"]
                let message = json["message"].string
                
                //注册通过，进入登录流程
                if code == 100 {
                self.loginAfterRegist()
                } else{
                    
                    SVProgressHUD.showError(withStatus:message)
                }
                
                
                
                
              
                
                
                
                
                
            }
        }

        
        //注册成功，自动进入登录流程
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "注册"
        //

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

extension SettingPassWordViewController {
    //注册后自动进入登录流程
    func loginAfterRegist(){
    //调用登录接口
        
        //提交账号密码等信息
        let params:[String:String] = ["userName":userName!,
                                      "password":setPassword.text!]
        
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: doLoginAPI, parameters: params as [String : String] ) { (result, error) in
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result)
                print(json)
                let code = json["code"]
                let message = json["message"].string
                let token = json["body"]["token"].string
                let userId = json["body"]["userId"].int
               
                
                //登录成功，进入设置界面
                if code == 100 {
                    
                    //将返回的 token 与 userId 保存起来
                    THUserHelper.shared.token = token
                    THUserHelper.shared.userId = userId
                    
                    
                    let editVc = EditViewController()
                    editVc.enterStyle = .REGIST  //通过注册方式进入该界面

                    
                    
                    EditSignatureInfo = MeSignatureInfo
                    EditNameInfo = ""
                    EditSexInfo = ""
                    EditSchoolInfo = ""
                    EditEducationInfo = ""
                    EditLocationInfo = ""
                    EditIntroduceInfo = ""

                    self.navigationController?.pushViewController(editVc, animated: true)
                    self.hidesBottomBarWhenPushed = false
                } else {
                    //登录失败再进入登录界面
                    SVProgressHUD.showError(withStatus: message)
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        

    }



}
