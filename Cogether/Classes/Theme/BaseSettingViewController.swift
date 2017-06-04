//
//  BaseSettingViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/12.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

class BaseSettingViewController: UIViewController {
    
    func configUIAppearance(){
    
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUIAppearance()
        //通知名称常量
        let NotifyChatMsgRecv = NSNotification.Name(rawValue:"notifyChatMsgRecv")
        
        
        //发送通知
        NotificationCenter.default.addObserver(self, selector:#selector(handleThemeChanged), name: NotifyChatMsgRecv, object: nil)
        

        // Do any additional setup after loading the view.
    }
    
    func handleThemeChanged(){
        
    
    
    
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
