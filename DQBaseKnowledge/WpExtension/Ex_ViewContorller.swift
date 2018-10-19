//
//  Ex_ViewContorller.swift
//  worldPorject
//
//  Created by xxxxx on 2018/6/25.
//  Copyright © 2018年 XXX. All rights reserved.
//

import Foundation

@objc extension UIViewController {
   @objc func getCurrentController()->DQBaseViewController? {
        guard let AppWindow = UIApplication.shared.delegate?.window as? UIWindow else {
            return nil
        }
        guard let baseBarCtl = AppWindow.rootViewController as? DQBaseTabBarController else {
            return nil
        }
        guard let selectNaviCtl = baseBarCtl.selectedViewController as?  DQBaseNavigationController else {
            return nil
        }
        if let currentController = selectNaviCtl.viewControllers.last {
            guard let ctl = currentController as? DQBaseViewController else {
                return nil
            }
            return ctl
        }
        return nil
    }
    
  @objc func getThePastController()->DQBaseViewController? {
        guard let AppWindow = UIApplication.shared.delegate?.window as? UIWindow else {
            return nil
        }
        guard let baseBarCtl = AppWindow.rootViewController as? DQBaseTabBarController else {
            return nil
        }
        guard let selectNaviCtl = baseBarCtl.selectedViewController as?  DQBaseNavigationController else {
            return nil
        }
        guard selectNaviCtl.viewControllers.count>=2 else {
            return nil
        }
        let thePastController = selectNaviCtl.viewControllers[selectNaviCtl.viewControllers.count-2]
        guard let ctl = thePastController as? DQBaseViewController else {
            return nil
        }
        return ctl
    }
}
