//
//  DebugTBC.swift
//  iFindMyParents
//
//  Created by 神楽坂雅詩 on 2016/7/17.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class DebugTBC: UITableViewController, LocationManagerDelegate {
    
    let FMP位置提交接口:String = "http://s.aday01.com:18080/uploader"
    
    /*
    向 http://s.aday01.com:18080/uploader?user=用户 提交POST请求，请求数据体为JSON格式
     {"action":"操作" , "imei":"手机串号","date":"时间","data":{}}
     操作为 gps时，data内JSON格式为 {"lat":"","lon":"","radius":""} 分别为精度 纬度 偏差范围
     操作为 cell 时 ，data内JSON格式为 {"mcc":"","mnc":"","lac":"","cid":""}
     gps模式就是通过手机GPS定位的数据直接传上来，cell模式就是通过手机读取基站信息，直接传输基站属性给服务器，服务器会自动去查询基站位置（越过GPS权限）
     安装之后用自带的手机浏览器访问 http://s.aday01.com:18080/setfmp 来设置
 */
    
    var 日志数据:NSMutableArray = NSMutableArray()
    var 日志时间:NSMutableArray = NSMutableArray()
    let 字体设置:UIFont = UIFont.systemFont(ofSize: 9)
    //var 计时器:MSWeakTimer
    let 位置引擎:LocationManager = LocationManager()
    
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
    
    func 定时扫描() {
        
    }
    
    override func viewDidLoad() {
        创建UI()
        新增日志条目(信息内容: "Application loading complete.")
        启动任务()
    }
    
    func 启动任务() {
        //计时器 = MSWeakTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(self.定时扫描), userInfo: nil, repeats: false, dispatchQueue: dispatch_get_main_queue())
        位置引擎.代理 = self
        位置引擎.精度 = 100
        位置引擎.初始化位置引擎()
    }
    
    func 位置引擎提示(信息:String) {
        新增日志条目(信息内容: 信息)
    }
    
    func 位置引擎信息(经度:Double, 纬度:Double) {
        let 信息:String = "longitude=\(经度), latitude=\(纬度)"
        新增日志条目(信息内容: 信息)
    }
    
    func 创建UI() {
        let 表格头部视图:UIView = UIView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.frame.size.width, height: 20)))
        表格头部视图.backgroundColor = UIColor.lightGray()
        self.tableView.tableHeaderView = 表格头部视图
        self.tableView.backgroundColor = UIColor.black()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
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
