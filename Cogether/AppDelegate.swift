//
//  AppDelegate.swift
//  Cogether
//
//  Created by tongho on 2017/5/12.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit
import SwiftyJSON




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    enum shortCutIdentifier:String{
        case post //帖子
        case discover
        case me
        
        init?(fullType: String) {
            guard let last = fullType.components(separatedBy: ".").last else {return nil}
                self.init(rawValue: last)
            }
        var type:String {
                return Bundle.main.bundleIdentifier!+".\(self.rawValue)"
        }
    
    }
    
    static let kApplicationShortcutUserInfoIcon = "ApplicationShortcutUserInfoIconKey"

    static let tintColor = UIColor(red: 0/255.0, green: 139/255.0, blue:203/255.0, alpha:1)
    
    let userHelper = THUserHelper.shared



    var window: UIWindow?

    /// Saved shortcut item used as a result of an app launch, used later when app is activated.
    var launchedShortcutItem: UIApplicationShortcutItem?

    let mainController = UITabBarController()
    //let setting = AppSetting.sharedSetting
    
   
    
    
    //消息通知点击后处理
    func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var handle = false
        
        guard shortCutIdentifier(fullType: shortcutItem.type) != nil else { return false }

        guard let shortCutType = shortcutItem.type as String? else { return false }

        switch shortCutType {
        case shortCutIdentifier.post.type:
            mainController.selectedIndex = 0
            handle = true
        case shortCutIdentifier.discover.type:
            mainController.selectedIndex = 1
            handle = true
        case shortCutIdentifier.me.type:
            mainController.selectedIndex = 2
            handle = true
        default:
            break
            
        }
        return handle
    }

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame:UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        //设置全局按钮排他性
        UIButton.appearance().isExclusiveTouch = true
        
        if userHelper.isLogin() == true {
            //已经登录了，进入home
            self.homePageViewShow()
        
        }else{
            //进入登录界面
            self.loginViewShow()
        }
        
        
        
        
        window?.makeKeyAndVisible()
        window?.tintColor = AppDelegate.tintColor
        //set The apperance of the switch
        UISwitch.appearance().onTintColor = AppDelegate.tintColor
        //set the apparance of the navigation bar
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = AppDelegate.tintColor
        UINavigationBar.appearance().tintColor = .white
        
        
        
        return true
    }
    
    
    func rootViewController() -> [UIViewController] {
        var controllerArray = [UIViewController]()
        
        let boardListViewController = PostViewController()
        //boardListViewController.title = "版面列表"
        boardListViewController.tabBarItem = UITabBarItem(title: "帖子", image: #imageLiteral(resourceName: "List"), tag: 0)
        let favListViewController = DiscoverViewController()
       // favListViewController.title = "收藏夹"
        favListViewController.tabBarItem = UITabBarItem(title: "发现", image: #imageLiteral(resourceName: "Nodes"), tag: 1)
        let userViewController = MyInfoViewController()
      //  userViewController.title = "我"
        userViewController.tabBarItem = UITabBarItem(title: "我", image: #imageLiteral(resourceName: "User"), tag: 2)
        controllerArray.append(BaseNavigationController(rootViewController: boardListViewController))
        controllerArray.append(BaseNavigationController(rootViewController: favListViewController))
        controllerArray.append(BaseNavigationController(rootViewController: userViewController))
        return controllerArray

    }
    
    
    //进入主界面
    func homePageViewShow(){
        //暂时在此处获取各种第三方token之类
        self.getToken()
        
        
        mainController.viewControllers = rootViewController()
        //进入后默认显示第一个 版面列表
        mainController.selectedIndex = 0
        window?.rootViewController = mainController

    }
    
    //进入登录界面
    func loginViewShow(){
        let sb = UIStoryboard(name: "Main", bundle:nil)
        let loginVc = sb.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        window?.rootViewController = (UINavigationController(rootViewController: loginVc))
      
    }
    
    //获取token
    func getToken(){
        NetworkTools.shareInstance.requestData(methodType: .GET, urlString: getTokenAPI, parameters: nil ) { (result, error) in
            
            if error != nil {
                LXFLog(error)
            } else {
                let json = JSON(result!)
                let code = json["code"]
                if code == 100{
                     THUserHelper.shared.token = json["body"]["token"].string
                    print(THUserHelper.shared.token!)
                }
                else {
                    //token获取失败
                    }
                }
            }
                    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

