//
//  TokenHelper.swift
//  Cogether
//
//  Created by tongho on 2017/6/22.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import Qiniu

class TokenHelper: NSObject {
    
    static let shared:QNUploadManager = {
       // let isHttps = true
       // let httpsZone = QNAutoZone()
        let zone = QNZone.zone1()
        let config = QNConfiguration.build({ (builder) in
            builder?.setZone(zone)
            
            
        })
        
        return QNUploadManager.init(configuration: config)
    //let tools = NetworkTools()
    //return tools
    }()
     private override init() {}
    
    
    }

    


