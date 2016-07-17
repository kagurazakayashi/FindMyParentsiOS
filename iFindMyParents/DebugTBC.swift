//
//  DebugTBC.swift
//  iFindMyParents
//
//  Created by 神楽坂雅詩 on 2016/7/17.
//  Copyright © 2016年 KagurazakaYashi. All rights reserved.
//

import UIKit

class DebugTBC: UITableViewController {
    
    let FMP位置提交接口:String = "http://s.aday01.com:18080/uploader";
    
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
    let 字体设置:UIFont = UIFont.systemFontOfSize(9)
    
    func 新增日志条目(内容:String) {
        let 当前日期:NSDate = NSDate()
        let 日期格式化器:NSDateFormatter = NSDateFormatter()
        日期格式化器.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
        let 当前日期字符串:String = 日期格式化器.stringFromDate(当前日期) as String
        日志数据.insertObject(内容, atIndex: 0)
        日志时间.insertObject(当前日期字符串, atIndex: 0)
        tableView.reloadData();
    }
    
    override func viewDidLoad() {
        创建UI()
        新增日志条目("Application loading complete.")
    }
    
    func 创建UI() {
        let 表格头部视图:UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 20))
        表格头部视图.backgroundColor = UIColor.lightGrayColor()
        self.tableView.tableHeaderView = 表格头部视图
        self.tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 日志数据.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let 单元格:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"cell");
        单元格.selectionStyle = .None
        单元格.backgroundColor = UIColor.blackColor();
        单元格.textLabel!.font = 字体设置
        单元格.detailTextLabel!.font = 字体设置
        单元格.textLabel!.textColor = UIColor.lightGrayColor();
        单元格.detailTextLabel!.textColor = UIColor.lightGrayColor();
        单元格.textLabel!.text = 日志时间[indexPath.row] as? String
        单元格.detailTextLabel!.text = 日志数据[indexPath.row] as? String
        return 单元格;
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 25
    }
}
