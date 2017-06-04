//
//  DicoverSubViewFactory.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

enum SubFindType {
    case AllUser   // 全部
    case NearByUser    // 附近
    case SubFindTypeUnkown    // 未知
   }

class DicoverSubViewFactory: NSObject {
    // MARK:- 生成子控制器
    class func subFindVcWith(identifier: String ) -> UIViewController {
        let subFindType: SubFindType = typeFromTitle(identifier)
        var controller: UIViewController!
        switch subFindType {
        case .AllUser:
            controller = AllUserViewController()
        case .NearByUser:
            controller = NearByViewController()
      
        default:
            controller = UIViewController()
        }
        return controller
    }
    
    // MARK:- 根据唯一标识符查找对应类型
    private class func typeFromTitle(_ title: String) -> SubFindType {
        if title == "全部" {
            return .AllUser
        } else if title == "附近" {
            return .NearByUser
        } else {
            return .SubFindTypeUnkown
        }
    }
}

