//
//  FBookMarkModel.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/17.
//  Copyright © 2019 An. All rights reserved.
//
/*
 数据标签模型
 */

import UIKit

class FBookMarkModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID:String!
    /// 章节ID
    var id:String!
    /// 章节名称
    var name:String!
    /// 内容
    var content:String!
    /// 时间
    var time:Date!
    /// 位置
    var location:NSNumber!
    // MARK: -- init
    override init() {
        super.init()
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        content = aDecoder.decodeObject(forKey: "content") as? String
        time = aDecoder.decodeObject(forKey: "time") as? Date
        location = aDecoder.decodeObject(forKey: "location") as?NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(time, forKey: "time")
        aCoder.encode(location, forKey: "location")
    }
}

