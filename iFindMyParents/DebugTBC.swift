//
//  DebugTBC.swift
//  iFindMyParents
//
//  Created by 神楽坂雅詩 on 2016/7/17.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit
import CoreTelephony
import AFNetworking

class DebugTBC: UITableViewController, LocationManagerDelegate {
    
    // ===== 公共设置 =====
    let FMP位置提交接口:String = "http://s.aday01.com:18080/uploader"
    let 服务器提交延迟:TimeInterval = 300.0 //两次访问接口相隔的时间，建议5分钟
    var 精度:Double = 100 //偏差范围（米），建议100米
    var 用户名:String = "yashi"
    // = = = = = = = = = =
    
    
    /*
    向 http://s.aday01.com:18080/uploader?user=用户 提交POST请求，请求数据体为JSON格式
     {"action":"操作" , "imei":"手机串号","date":"时间","data":{}}
     操作为 gps时，data内JSON格式为 {"lat":"","lon":"","radius":""} 分别为经度 纬度 偏差范围
     操作为 cell 时 ，data内JSON格式为 {"mcc":"","mnc":"","lac":"","cid":""}
     gps模式就是通过手机GPS定位的数据直接传上来，cell模式就是通过手机读取基站信息，直接传输基站属性给服务器，服务器会自动去查询基站位置（越过GPS权限）
     安装之后用自带的手机浏览器访问 http://s.aday01.com:18080/setfmp 来设置
 */
    
    var 日志数据:NSMutableArray = NSMutableArray()
    var 日志时间:NSMutableArray = NSMutableArray()
    let 字体设置:UIFont = UIFont.systemFont(ofSize: 9)
    let 位置引擎:LocationManager = LocationManager()
    var 网络繁忙:Bool = false
    var UUIDstr:String = ""
    var 上次请求时间:Date? = nil
    
    func 新增日志条目(信息内容:String) {
        let 当前日期:Date = Date()
        let 日期格式化器:DateFormatter = DateFormatter()
        日期格式化器.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
        let 当前日期字符串:String = 日期格式化器.string(from: 当前日期)
        //print("\(当前日期字符串) \(信息内容)")
        日志数据.add(信息内容)
        日志时间.add(当前日期字符串)
        tableView.reloadData()
        // *indexPath = [NSIndexPath indexPathForItem:13 inSection:0];
        let 滚动到位置:IndexPath = IndexPath(item: 日志数据.count-1, section: 0)
        tableView.selectRow(at: 滚动到位置, animated: false, scrollPosition: UITableViewScrollPosition.bottom)
        tableView.deselectRow(at: 滚动到位置, animated: true)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default().addObserver(self, selector: #selector(位置引擎提示(通知:)), name: "appdele", object: nil)
        创建UI()
        新增日志条目(信息内容: "Application loading complete.")
        获取设备信息()
        启动任务()
    }
    
    func 启动任务() {
        位置引擎.代理 = self
        位置引擎.精度 = 精度
        位置引擎.初始化位置引擎()
    }
    
    func 位置引擎提示(通知:Notification) {
        新增日志条目(信息内容: 通知.object! as! String)
    }
    
    func 位置引擎提示(信息:String) {
        新增日志条目(信息内容: 信息)
    }
    
    func 计算是否处于时间冷却中() -> Bool {
        if (上次请求时间 == nil) {
            return true
        } else {
            let 当前日期:Date = Date()
            let 时间差:TimeInterval = 当前日期.timeIntervalSince(上次请求时间!)
            if (时间差 < 服务器提交延迟) {
                return false
            }
            return true
        }
    }
    
    func 位置引擎信息(经度:Double, 纬度:Double) {
        let 信息:String = "longitude=\(经度), latitude=\(纬度)"
        新增日志条目(信息内容: 信息)
        if (网络繁忙 == false) {
            if (计算是否处于时间冷却中() == true) {
                let 当前日期:Date = Date()
                let 日期格式化器:DateFormatter = DateFormatter()
                日期格式化器.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let 当前日期字符串:String = 日期格式化器.string(from: 当前日期)
                let data = ["lat":"\(经度)","lon":"\(纬度)","radius":"\(精度)"]
                let 要提交的参数 = ["action":"gps","imei":UUIDstr,"date":当前日期字符串,"data":data]
                if (JSONSerialization.isValidJSONObject(要提交的参数) == false) {
                    新增日志条目(信息内容: "[ERR] Failed to create JSON.")
                } else {
                    //let 要提交的数据:Data! = try? JSONSerialization.data(withJSONObject: 要提交的参数, options: [])
                    //let 要提交的JSON:String = String(data: 要提交的数据, encoding: String.Encoding.utf8)!
                    //print(要提交的JSON)
                    执行网络请求(要提交的数据: 要提交的参数)
                }
            } else {
                新增日志条目(信息内容: "Wait for timer.")
            }
        } else {
            新增日志条目(信息内容: "Wait for network.")
        }
    }
    
    func 执行网络请求(要提交的数据:AnyObject) {
        网络繁忙 = true
        let 网络会话管理器:AFHTTPSessionManager = AFHTTPSessionManager()
        let 提交到:String = "\(FMP位置提交接口)?user=\(用户名)"
        新增日志条目(信息内容: "Sending request \(提交到)")
        网络会话管理器.post(提交到, parameters: 要提交的数据, progress: { (当前过程:Progress) in
            
            }, success: { (当前网络任务:URLSessionDataTask, 数据:AnyObject?) in
                var 返回信息:String? = 数据 as? String
                if (返回信息 == nil) {
                    返回信息 = "Receive blank data."
                }
                self.新增日志条目(信息内容: 返回信息!)
                self.网络繁忙 = false
                self.上次请求时间 = Date()
        }) { (当前网络任务:URLSessionDataTask?, 错误:NSError) in
            self.新增日志条目(信息内容: "[ERR] \(错误.localizedDescription)")
            self.网络繁忙 = false
            self.上次请求时间 = Date()
        }
    }
 
    func 创建UI() {
        let 表格头部视图:UIView = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 20)))
        表格头部视图.backgroundColor = UIColor.lightGray()
        self.tableView.tableHeaderView = 表格头部视图
        self.tableView.backgroundColor = UIColor.black()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    func 获取设备信息() {
        let 设备:UIDevice = UIDevice()
        //新增日志条目(信息内容: "name : \(设备.name)")
        新增日志条目(信息内容: "Model : \(设备.model)")
        //新增日志条目(信息内容: "localizedModel : \(设备.localizedModel)")
        新增日志条目(信息内容: "System name : \(设备.systemName)")
        新增日志条目(信息内容: "System version : \(设备.systemVersion)")
        let uuidn = 设备.identifierForVendor!.uuidString
        UUIDstr = uuidn.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literalSearch, range: nil)
        新增日志条目(信息内容: "UUID : \(UUIDstr)")
        let 缩放:CGFloat = UIScreen.main().scale
        新增日志条目(信息内容: "Screen scale : \(缩放)")
        let 屏幕:CGRect = UIScreen.main().bounds
        新增日志条目(信息内容: "Screen size : \(屏幕.width) x \(屏幕.height)")
        新增日志条目(信息内容: "Screen resolution : \(屏幕.width*缩放) x \(屏幕.height*缩放)")
        let 移动网络:CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        let 运营商:CTCarrier? = 移动网络.subscriberCellularProvider
        新增日志条目(信息内容: "Carrier name : \(运营商?.carrierName!)")
        新增日志条目(信息内容: "Connect type : \(移动网络.currentRadioAccessTechnology)")
        if (设备.batteryState == UIDeviceBatteryState.unplugged){
            新增日志条目(信息内容: "Battery state : unplugged")
        } else if (设备.batteryState == UIDeviceBatteryState.charging){
            新增日志条目(信息内容: "Battery state : charging")
        } else if (设备.batteryState == UIDeviceBatteryState.full){
            新增日志条目(信息内容: "Battery state : full")
        } else {
            新增日志条目(信息内容: "Battery state : unknown")
        }
        新增日志条目(信息内容: "Battery level : \(设备.batteryLevel*100.0*(-1)) %")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 日志数据.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let 单元格:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"cell");
//        单元格.selectionStyle = .none
        单元格.backgroundColor = UIColor.black()
        单元格.textLabel!.font = 字体设置
        单元格.detailTextLabel!.font = 字体设置
        单元格.textLabel!.textColor = UIColor.lightGray()
        单元格.detailTextLabel!.textColor = UIColor.lightGray()
        单元格.textLabel!.text = 日志时间[indexPath.row] as? String
        单元格.detailTextLabel!.text = 日志数据[indexPath.row] as? String
        return 单元格
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
