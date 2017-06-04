//
//  THPageViewController.swift
//  Cogether
//
//  Created by tongho on 2017/5/17.
//  Copyright © 2017年 tongho. All rights reserved.
//

import UIKit

// MARK:- 代理协议
protocol THPageViewControllerDelegate: NSObjectProtocol {
    // MARK: 获取当前子控制器的角标
    func PageCurrentSubControllerIndex( index: NSInteger, pageViewController: THPageViewController)
}

class THPageViewController: UIViewController {
    
    // MARK:- 代理
    weak var delegate: THPageViewControllerDelegate?
    
    // MARK:- 定义属性
    /// 所有子控制器
    var controllers: [UIViewController] = [UIViewController]()
    /// 父控制器
    var superController: UIViewController!
    var pageVc: UIPageViewController!
    
    // MARK:- init
    init(superController: UIViewController, controllers: [UIViewController]) {
        
        super.init(nibName: nil, bundle: nil)
        // 存储数据
        self.controllers = controllers
        self.superController = superController
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 生命周期
    override func viewDidLoad() {
        // 初始化
        setup()
    }
}

// MARK:- 初始化
extension THPageViewController {
    
    /// 初始化page控制器
    fileprivate func setup() {
        if controllers.count == 0 {return}
        
        let options: [String : Any] = [UIPageViewControllerOptionSpineLocationKey : NSNumber(integerLiteral: UIPageViewControllerSpineLocation.none.rawValue)]
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
        page.delegate = self
        page.dataSource = self
        page.setViewControllers([controllers.first!], direction: .forward, animated: false, completion: nil)
        page.view.frame = self.view.frame
        pageVc = page
        
        self.view.addSubview(page.view)
    }
}

// MARK:- 向外提供的方法
extension THPageViewController {
    // MARK: 设置当前子控制器
    func setCurrentSubControllerWith(index: NSInteger) {
        pageVc.setViewControllers([controllers[index]], direction: .forward, animated: false, completion: nil)
    }
}


// MARK: 代理与数据源
extension THPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    /// 前一个控制器
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = controllers.index(of: viewController) else {return nil}
        if index == 0 || index == NSNotFound {
            return nil
        }
        return controllers[index - 1]
    }
    
    /// 后一个控制器
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.controllers.index(of: viewController) else {return nil}
        if index == NSNotFound || index == controllers.count - 1 {
            return nil
        }
        return controllers[index + 1]
    }
    
    /// 返回控制器数量
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return controllers.count
    }
    
    /// 跳转到另一个控制器界面时调用
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?[0] else {return}
        let index = indexForViewController(controller: vc)
        delegate?.PageCurrentSubControllerIndex(index: index, pageViewController: self)
    }
    
    /// 获取当前子控制器的角标
    func indexForViewController(controller: UIViewController) -> NSInteger {
        return controllers.index(of: controller)!
    }
}


