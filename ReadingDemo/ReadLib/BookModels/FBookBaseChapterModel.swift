//
//  FBookBaseChapterModel.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/17.
//  Copyright © 2019 An. All rights reserved.
//
/*
 数据章节基本数据模型
 */
import UIKit

class FBookBaseChapterModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID:String!
    /// 章节ID
    var id:String!
    /// 上一章 章节ID
    var lastChapterId:String?
    /// 下一章：章节ID
    var nextChapterId:String?
    /// 章节名称
    var name:String!
    /// 章节内容范围
    var contentRange:NSRange?
    /// 上一张 章节内容范围
    var lastContentRange:NSRange?
    /// 下一张 章节内容范围
    var nextContentRange:NSRange?
    /// 优先级 (一般章节段落都带有排序的优先级 从 0 开始)
    var priority:NSNumber!
    
    
    // MARK: -- 操作
    func bookChapterModel(isUpdateFont:Bool = false) ->FBookChapterModel? {
        if FBookChapterModel.IsExistBookChapterModel(bookID: bookID, chapterID: id) {
            return FBookChapterModel.bookChapterModel(bookID: bookID, chapterID: id, isUpdateFont: isUpdateFont)
        }
        return nil
    }
    
    // MARK: -- NSCoding
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastChapterId = aDecoder.decodeObject(forKey: "lastChapterId") as? String
        nextChapterId = aDecoder.decodeObject(forKey: "nextChapterId") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        contentRange = aDecoder.decodeObject(forKey: "contentRange") as? NSRange
        lastContentRange = aDecoder.decodeObject(forKey: "lastContentRange") as? NSRange
        nextContentRange = aDecoder.decodeObject(forKey: "nextContentRange") as? NSRange
        priority = aDecoder.decodeObject(forKey: "priority") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(lastChapterId, forKey: "lastChapterId")
        aCoder.encode(nextChapterId, forKey: "nextChapterId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(contentRange, forKey: "contentRange")
        aCoder.encode(lastContentRange, forKey: "lastContentRange")
        aCoder.encode(nextContentRange, forKey: "nextContentRange")
        aCoder.encode(priority, forKey: "priority")
    }
}
