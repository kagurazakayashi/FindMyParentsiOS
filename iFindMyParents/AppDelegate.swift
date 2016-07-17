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
        NotificationCenter.default().post(name: "appdele" as NSNotification.Name, object: "Application will resign active")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default().post(name: "appdele" as NSNotification.Name, object: "Application did enter background")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        NotificationCenter.default().post(name: "appdele" as NSNotification.Name, object: "Application will enter foreground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default().post(name: "appdele" as NSNotification.Name, object: "Application did become active")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default().post(name: "appdele" as NSNotification.Name, object: "Application will terminate")
    }


}

