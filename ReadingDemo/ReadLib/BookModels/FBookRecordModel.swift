//
//  FBookRecordModel.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/17.
//  Copyright © 2019 An. All rights reserved.
//
/*
 书籍阅读记录模型
 */
/// 最后一页标示
let FBookLastPageValue:NSInteger = -1
/// 阅读记录key
let FBookRecord:String = "BookRecord"

import UIKit

class FBookRecordModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    /// 是否存在记录
    var isRecord:Bool {get{return bookChapterModel != nil}}
    /// 当前章节阅读到的页码(如果有云端记录或者多端使用阅读记录需求 可以记录location 通过location转成页码进行使用)
    var page:NSNumber = NSNumber(value: 0)
    /// 当前阅读到的章节模型
    var bookChapterModel:FBookChapterModel?
    
    
    // MARK: -- init
    override init() {
        super.init()
    }
    // MARK: -- NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init()
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        bookChapterModel = aDecoder.decodeObject(forKey: "bookChapterModel") as? FBookChapterModel
        page = aDecoder.decodeObject(forKey: "page") as! NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(bookChapterModel, forKey: "bookChapterModel")
        aCoder.encode(page, forKey: "page")
    }
    
    // MARK: -- 拷贝
    func copySelf() ->FBookRecordModel {
        let bookRecordModel = FBookRecordModel()
        bookRecordModel.bookID = bookID
        bookRecordModel.bookChapterModel = bookChapterModel
        bookRecordModel.page = page
        return bookRecordModel
    }
    
    
    /// 通过书ID 获得阅读记录模型 没有则进行创建传出
    class func bookRecordModel(bookID:String, isUpdateFont:Bool = false, isSave:Bool = false) ->FBookRecordModel {
        
        var bookRecordModel:FBookRecordModel!
        if FBookRecordModel.IsExistBookRecordModel(bookID: bookID) { // 存在
            bookRecordModel = BookKeyedUnarchiver(folderName: bookID, fileName: (bookID + FBookRecord)) as? FBookRecordModel
            if isUpdateFont {bookRecordModel.updateFont(isSave: isSave)}
        }else{ // 不存在
            bookRecordModel = FBookRecordModel()
            bookRecordModel.bookID = bookID
        }
        return bookRecordModel!
    }
    
    /// 是否存在阅读记录模型
    class func IsExistBookRecordModel(bookID:String) ->Bool {
        return BookKeyedIsExistArchiver(folderName: bookID, fileName: (bookID + FBookRecord))
    }
    
    // MARK: -- 操作
    
    /// 保存
    func save() {
        BookKeyedArchiver(folderName: bookID, fileName: (bookID + FBookRecord), object: self)
    }
    
    /// 修改阅读记录为指定章节ID 指定页码 (toPage: -1 为最后一页 也可以使用 FBookLastPageValue)
    func modify(chapterID:String, toPage:NSInteger = 0, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        /*
         网络小说操作提示:
         
         在修改阅读记录之前记得保证本地有该章节内容的缓存文件
         */
        
        if FBookChapterModel.IsExistBookChapterModel(bookID: bookID, chapterID: chapterID) {
            
            bookChapterModel = FBookChapterModel.bookChapterModel(bookID: bookID, chapterID: chapterID, isUpdateFont: isUpdateFont)
            
            page = (toPage == FBookLastPageValue) ? NSNumber(value: bookChapterModel!.pageCount.intValue - 1) : NSNumber(value: toPage)
            
            if isSave {save()}
        }
    }
    
    /// 修改阅读记录为指定书签记录
    func modify(bookMarkModel:FBookMarkModel, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        /*
         网络小说操作提示:
         
         在使用书签模型修改阅读记录之前记得保证本地有该章节内容的缓存文件
         */
        if FBookChapterModel.IsExistBookChapterModel(bookID: bookMarkModel.bookID, chapterID: bookMarkModel.id) {
            
            bookChapterModel = FBookChapterModel.bookChapterModel(bookID: bookID, chapterID: bookMarkModel.id, isUpdateFont: isUpdateFont)
            
            page = NSNumber(value: bookChapterModel!.page(location: bookMarkModel.location.intValue))
            
            if isSave {save()}
        }
    }
    
    /// 刷新字体
    func updateFont(isSave:Bool = false) {
        
        if bookChapterModel != nil {
            
            let location = bookChapterModel!.location(page: page.intValue)
            
            bookChapterModel!.updateFont()
            
            page = NSNumber(value: bookChapterModel!.page(location: location))
            
            bookChapterModel!.save()
            
            if isSave {save()}
        }
    }
    
}
