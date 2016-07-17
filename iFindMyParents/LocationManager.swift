//
//  LocationManager.swift
//  iFindMyParents
//
//  Created by 神楽坂雅詩 on 2016/7/17.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import MapKit

protocol LocationManagerDelegate {
    func 位置引擎提示(信息:String)
    func 位置引擎信息(经度:Double, 纬度:Double)
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var 代理:LocationManagerDelegate? = nil
    var 精度:CLLocationDistance = 100
    let 位置管理器:CLLocationManager = CLLocationManager();
    
    func 初始化位置引擎() -> Bool {
        代理?.位置引擎提示(信息: "Getting location service permissions ...")
        if (CLLocationManager.locationServicesEnabled() == false) {
            代理?.位置引擎提示(信息: "[ERR] Location service is disabled.")
            return false
        }
        位置管理器.requestWhenInUseAuthorization()
        位置管理器.delegate = self
        位置管理器.desiredAccuracy = kCLLocationAccuracyBest
        代理?.位置引擎提示(信息: "desiredAccuracy : AccuracyBest")
        位置管理器.distanceFilter = 精度
        代理?.位置引擎提示(信息: "distanceFilter : \(精度)m")
        位置管理器.startUpdatingLocation()
        代理?.位置引擎提示(信息: "Start updating location.")
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let 当前位置:CLLocation? = locations.last;
        if (当前位置 != nil) {
            let 经度:CLLocationDegrees = 当前位置!.coordinate.longitude
            let 纬度:CLLocationDegrees = 当前位置!.coordinate.latitude
            代理?.位置引擎信息(经度: Double(经度), 纬度: Double(纬度))
        } else {
            代理?.位置引擎提示(信息: "[ERR] Failed to get location.");
        }
    }
    
}
