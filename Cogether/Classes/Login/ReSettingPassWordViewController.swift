//
//  ReSettingPassWordViewController.swift
//  Cogether
//
//  Created by 123 on 2017/7/22.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class ReSettingPassWordViewController: UIViewController {
    
    var userName:String?
    
    @IBOutlet weak var submitBtn: UIButton!
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
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: reSetPassWordAPI, parameters: params as [String : String] ) { (result, error) in
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result!)
                //print(json)
                let code = json["code"]
                let message = json["message"].string
                
                //密码修改成功，进入登陆界面重新输入密码
                if code == 100 {
                    self.enterLogin()
                } else{
                    
                    SVProgressHUD.showError(withStatus:message)
                }
          
                
            }
        }
        
        
        //注册成功，自动进入登录流程
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "重置密码"
        submitBtn.backgroundColor = kSystemBlueColor
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

extension ReSettingPassWordViewController {
    //注册后自动进入登录流程
    func enterLogin(){
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
        
    
    
}
