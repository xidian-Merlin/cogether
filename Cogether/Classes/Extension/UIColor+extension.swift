//
//  UIColor+extension.swift
//  Cogether
//
//  Created by tongho on 2017/5/16.
//  Copyright © 2017年 tongho. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func hexInt(_ hexValue: Int) -> UIColor {
        return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16)) / 255.0,
                       
                       green: ((CGFloat)((hexValue & 0xFF00) >> 8)) / 255.0,
                       
                       blue: ((CGFloat)(hexValue & 0xFF)) / 255.0,
                       
                       alpha: 1.0)
    }
    

    
}
