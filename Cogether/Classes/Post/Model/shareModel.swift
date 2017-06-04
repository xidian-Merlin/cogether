//
//  shareModel.swift
//  Cogether
//
//  Created by tongho on 2017/5/28.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import HandyJSON

class shareModel: HandyJSON {
//    "articleId":42,"title":"月上柳梢头，相约去青楼","content":"怒发冲冠凭栏处，我身边一壶酒","time":"1495637237049","commentNum":0,"approvalNum":1,"userId":15,"nickName":"八斗之才曹子建","avator":"http://oopqx0v1l.bkt.clouddn.com/1495637437648.png","label":"Web"}
   
    var articleId: Int?
    var title: String?
    var content: String?
    var time: String?
    var commentNum: Int?
    var approvalNum: Int?
    var userId: Int?
    var nickName: String?
    var avator: String?     //url地址
    var lable: String?

      required  init() {} // 如果定义是struct，连init()函数都不用声明；
}
