//
//  AppDelegate.swift
//  iFindMyParents
//
//  Created by 神楽坂雅詩 on 2016/7/17.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("appdele"), object: "Application will resign active") //挂起
        NotificationCenter.default.post(name: Notification.Name("loguioff"), object: nil)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("appdele"), object: "Application did enter background")
        NotificationCenter.default.post(name: Notification.Name("loguioff"), object: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("appdele"), object: "Application will enter foreground") //应用程序将进入前台
        NotificationCenter.default.post(name: Notification.Name("loguion"), object: nil)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("appdele"), object: "Application did become active") //复原
        NotificationCenter.default.post(name: Notification.Name("loguion"), object: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("appdele"), object: "Application will terminate") //应用程序将被终止
    }


}

