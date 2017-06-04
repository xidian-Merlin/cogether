//
//  THUserHelper.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

class THUserHelper: NSObject {
    
    var token:String?
    var userId:Int?
    
    let userDefaults = UserDefaults.standard
    static let shared = THUserHelper.init()
     private override init(){}
    
    func isLogin() -> Bool {
        if UserDefaults.standard.object(forKey: "isLogin") == nil {
            return false
        }
        return (UserDefaults.standard.object(forKey: "isLogin") != nil) 
    }
    
    func saveLoginMark(value : Bool) {
        UserDefaults.setValue(value, forKey: "isLogin")
    }
    
    
    

}
