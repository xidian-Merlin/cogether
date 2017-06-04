//
//  UserModel.swift
//  Cogether
//
//  Created by tongho on 2017/6/3.
//  Copyright © 2017年 tongho. All rights reserved.
//


import UIKit
import HandyJSON

class UserModel: HandyJSON {
//{userId：用户Id
//    nickName：用户名
//    avator：头像
//    label：标签
//    introduction：个人介绍
//    }
    var userId : Int?
    var nickName: String?
    var avator: String?
    var introduction: String?
   
    
    required  init() {} // 如果定义是struct，连init()函数都不用声明；
}
