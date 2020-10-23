//
//  FBookChapterModel.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/16.
//  Copyright © 2019 An. All rights reserved.
//
/*
 书籍章节模型
 */
import UIKit

class FBookChapterModel: NSObject,NSCoding {
    
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
    /// 优先级 (一般章节段落都带有排序的优先级 从 0 开始)
    var priority:NSNumber!
    /// 上一张 章节内容范围
    var lastContentRange:NSRange?
    /// 上一张 章节内容范围
    var contentRange:NSRange?
    /// 下一张 章节内容范围
    var nextContentRange:NSRange?
    /// 内容
    var content:String!
    /// 本章有多少页
    var pageCount:NSNumber = NSNumber(value: 0)
    /// 每一页的Range数组
    var rangeArray:[NSRange] = []
    /// 记录该章使用的字体属性
    private var bookAttribute:[NSAttributedString.Key:Any] = [:]
    
    
    // MARK: -- init
    
    override init() {
        super.init()
    }
    
    // MARK: -- NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        lastChapterId = aDecoder.decodeObject(forKey: "lastChapterId") as? String
        nextChapterId = aDecoder.decodeObject(forKey: "nextChapterId") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        priority = aDecoder.decodeObject(forKey: "priority") as? NSNumber
        lastContentRange = aDecoder.decodeObject(forKey: "lastContentRange") as? NSRange
        contentRange = aDecoder.decodeObject(forKey: "contentRange") as? NSRange
        nextContentRange = aDecoder.decodeObject(forKey: "nextContentRange") as? NSRange
        content = aDecoder.decodeObject(forKey: "content") as? String
        pageCount = aDecoder.decodeObject(forKey: "pageCount") as! NSNumber
        rangeArray = aDecoder.decodeObject(forKey: "rangeArray") as! [NSRange]
        bookAttribute = aDecoder.decodeObject(forKey: "bookAttribute") as! [NSAttributedString.Key:Any]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(lastChapterId, forKey: "lastChapterId")
        aCoder.encode(nextChapterId, forKey: "nextChapterId")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(priority, forKey: "priority")
        aCoder.encode(lastContentRange, forKey: "lastContentRange")
        aCoder.encode(contentRange, forKey: "contentRange")
        aCoder.encode(nextContentRange, forKey: "nextContentRange")
        aCoder.encode(content, forKey: "content")
        aCoder.encode(pageCount, forKey: "pageCount")
        aCoder.encode(rangeArray, forKey: "rangeArray")
        aCoder.encode(bookAttribute, forKey: "bookAttribute")
    }
    
    // MARK: -- 更新字体
    /// 更新字体
    func updateFont(isSave:Bool = false) {
        
        let bookAttribute = FBookConfigure.shared().bookAttribute(isPaging: true)
        
        if !NSDictionary(dictionary: self.bookAttribute).isEqual(to: bookAttribute) {
            
            self.bookAttribute = bookAttribute
            
            rangeArray = FBookParser.ParserPageRange(string: content, rect: GetBookViewFrame(), attrs: bookAttribute)
            
            pageCount = NSNumber(value: rangeArray.count)
            
            if isSave {save()}
        }
    }
    
    /// 获取数据章节模型
    ///
    /// - Parameters:
    ///   - bookID: 书籍ID
    ///   - chapterID: 章节ID
    ///   - isUpdateFont: 是否跟新字体
    /// - Returns: 章节模型
    class func bookChapterModel(bookID:String, chapterID:String, isUpdateFont:Bool = false) ->FBookChapterModel {
        
        var bookChapterModel:FBookChapterModel!
        if FBookChapterModel.IsExistBookChapterModel(bookID: bookID, chapterID: chapterID) { // 存在
            bookChapterModel = BookKeyedUnarchiver(folderName: bookID, fileName: chapterID) as? FBookChapterModel
            if isUpdateFont {bookChapterModel.updateFont(isSave: true)}
        }else{ // 不存在
            bookChapterModel = FBookChapterModel()
            bookChapterModel.bookID = bookID
            bookChapterModel.id = chapterID
        }
        return bookChapterModel
    }
    
    /// 是否存在章节内容模型
    class func IsExistBookChapterModel(bookID:String, chapterID:String) ->Bool {
        return BookKeyedIsExistArchiver(folderName: bookID, fileName: chapterID)
    }
    
    
    
    // MARK: -- 操作
    /// 通过 Page 获得字符串
    func string(page:NSInteger) ->String {
        return content.substring(rangeArray[page])
    }
    
    /// 通过 Page 获得 Location
    func location(page:NSInteger) ->NSInteger {
        return rangeArray[page].location
    }
    
    /// 通过 Page 获得 CenterLocation
    func centerLocation(page:NSInteger) ->NSInteger {
        let range = rangeArray[page]
        return range.location + (range.location + range.length) / 2
    }
    
    /// 通过 Location 获得 Page
    func page(location:NSInteger) ->NSInteger {
        let count = rangeArray.count
        for i in 0..<count {
            let range = rangeArray[i]
            if location < (range.location + range.length) {
                return i
            }
        }
        return 0
    }
    
    /// 保存
    func save() {
        BookKeyedArchiver(folderName: bookID, fileName: id, object: self)
    }
    
}
