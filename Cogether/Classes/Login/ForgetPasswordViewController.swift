//
//  ForgetPasswordViewController.swift
//  Cogether
//
//  Created by 123 on 2017/7/17.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SVProgressHUD

class ForgetPasswordViewController: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var telPhoneNumber: UITextField!
    @IBOutlet weak var verifyNumber: UITextField!
    @IBAction func getVeriCode(_ sender: UIButton) {
        //首先向服务器发送请求，检验手机号  11 位限制
        
        //  let params: Parameters = ["userName": telPhoneNumber.text]
        
        let params: Dictionary = ["userName" : telPhoneNumber.text]
        print(checkPhoneAPI)
        NetworkTools.shareInstance.requestData(methodType: .POST, urlString: checkPhoneAPI, parameters: params as? [String : String] ) { (result, error) in
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result!)
                print(json)
                let code = json["code"]
                let message = json["message"].string
                if code == 100{
                    print("验证手机号成功")
                    //如果返回成功，进入获取验证码流程
                    self.getCode()
                    
                }
                else {
                    print("验证手机号失败")
                    SVProgressHUD.showError(withStatus: message)
                    
                }
                
            }
        }
        
        //向三方服务器发送请求，获取验证码  4 位限制
        
        print("获取验证码")
        
        
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        
        
        
        
        //验证 验证码是否正确
        if verifyNumber.text == "" {
            SVProgressHUD.showError(withStatus: "请填入注册码")
            return
            
        }
        
        
        //手机号与验证码都正确，跳转进入填写密码界面
        
        
        
        let sb = UIStoryboard(name:"Main",bundle:nil)
        let settingPassVc = sb.instantiateViewController(withIdentifier: "resetPasswordVc") as!  ReSettingPassWordViewController
        settingPassVc.userName = telPhoneNumber.text
        self.navigationController?.pushViewController(settingPassVc, animated: true)
        
        
        
        
        
        
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "忘记密码"
        self.view.backgroundColor = UIColor.hexInt(0xf3f3f3)
        submitBtn.backgroundColor = kSystemBlueColor
        
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



extension ForgetPasswordViewController{
    
    //获取验证码
    func getCode(){
        
        
    }
    
    
    
    
    
}

