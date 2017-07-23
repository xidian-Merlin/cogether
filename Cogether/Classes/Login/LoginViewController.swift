//
//  LoginViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/15.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SVProgressHUD
import SwiftyJSON

class LoginViewController: UIViewController {
    
    
  

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var login: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        login.backgroundColor = kSystemBlueColor
        
        let swipeGes = UISwipeGestureRecognizer(target:self, action:#selector(disapperKeyBoard))
        swipeGes.direction = UISwipeGestureRecognizerDirection.down
        view.addGestureRecognizer(swipeGes)
    
        // Do any additional setup after loading the view.
    }

    
    func disapperKeyBoard(sender: UISwipeGestureRecognizer){
        
        if sender.state == .ended {
            print("收回键盘")
           userName.resignFirstResponder()
           passWord.resignFirstResponder()
        }
        sender.cancelsTouchesInView = false
    
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        print("登录按钮被点击了")
        self.loginRequest()
        
        
        
        
    }
   
    @IBAction func regist(_ sender: UIButton) {
        
        print("注册按钮被点击了")
        //进入注册界面
        let sb = UIStoryboard(name:"Main",bundle:nil)
        let registVc = sb.instantiateViewController(withIdentifier: "registView") as!  RegistViewController
        self.navigationController?.pushViewController(registVc, animated: true)
        
    }
    
    
    @IBAction func findPassWord(_ sender: UIButton) {
        print("找回按钮被点击了")
        //junp into the get password page
        let sb = UIStoryboard(name:"Main",bundle:nil)
        let forgetVc = sb.instantiateViewController(withIdentifier: "forgetView") as! ForgetPasswordViewController
        self.navigationController?.pushViewController(forgetVc, animated: true)
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

extension LoginViewController {
    
    //注册后自动进入登录流程
    func loginRequest(){
        //调用登录接口
        
        //提交账号密码等信息
        let params:[String:String] = ["userName":userName.text!,
                                      "password":passWord.text!]
        
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
                
                
                //登录成功，进入主界面
                if code == 100 {
                    
                    //将返回的 token 与 userId 保存起来
                    THUserHelper.shared.token = token
                    THUserHelper.shared.userId = userId
                    
                    //将主界面设置为根界面
                    let appDelegate  = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.homePageViewShow()

                    
                 
                } else {
                    //登录失败再进入登录界面
                    SVProgressHUD.showError(withStatus: message)
              
                }
            }
        }
        
        
    }

    

}

