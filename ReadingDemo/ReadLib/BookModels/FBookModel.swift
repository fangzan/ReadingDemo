//
//  FBookModel.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/16.
//  Copyright © 2019 An. All rights reserved.
//
/*
 书籍的模型
 */
import UIKit

class FBookModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    /// 小说Url
    var bookUrl:URL!
    /// 小说内容
    var bookContent:String!
    /// 是否为本地小说
    var isLocalBook:NSNumber = NSNumber(value: 1)
    /// 阅读记录
    var bookRecordModel:FBookRecordModel!
    /// 当前书签(用于记录使用)
    private(set) var bookMarkModel:FBookMarkModel?
    /// 书签列表
    private(set) var bookMarkModels:[FBookMarkModel] = [FBookMarkModel]()
    /// 章节列表数组（章节列表不包含章节内容, 它唯一的用处就是在阅读页面给用户查看章节列表）
    var bookBaseChapterModels:[FBookBaseChapterModel] = [FBookBaseChapterModel]()
    
    // MARK: -- init
    private override init() {
        super.init()
    }
    // MARK: -- NSCoding
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        bookUrl = aDecoder.decodeObject(forKey: "bookUrl") as? URL
        bookContent = aDecoder.decodeObject(forKey: "bookContent") as? String
        isLocalBook = aDecoder.decodeObject(forKey: "isLocalBook") as! NSNumber
        bookMarkModels = aDecoder.decodeObject(forKey: "bookMarkModels") as! [FBookMarkModel]
        bookBaseChapterModels = aDecoder.decodeObject(forKey: "bookBaseChapterModels") as! [FBookBaseChapterModel]
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(bookID, forKey: "bookID")
        aCoder.encode(bookUrl, forKey: "bookUrl")
        aCoder.encode(bookContent, forKey: "bookContent")
        aCoder.encode(isLocalBook, forKey: "isLocalBook")
        aCoder.encode(bookMarkModels, forKey: "bookMarkModels")
        aCoder.encode(bookBaseChapterModels, forKey: "bookBaseChapterModels")
        
    }
    
    /// 获得阅读模型
    class func bookModel(bookID:String) -> FBookModel {
        
        var bookModel:FBookModel!
        
        if FBookModel.IsExistBookModel(bookID: bookID) {
            bookModel = BookKeyedUnarchiver(folderName: bookID, fileName: bookID) as? FBookModel
        } else {
            bookModel = FBookModel()
            bookModel.bookID = bookID
        }
        // 阅读记录 刷新字体是以防在别的小说修改了字体
        bookModel!.bookRecordModel = FBookRecordModel.bookRecordModel(bookID: bookID, isUpdateFont: true, isSave: true)
        
        return bookModel!
    }
    
    /// 是否存在阅读模型
    class func IsExistBookModel(bookID:String) ->Bool {
        return BookKeyedIsExistArchiver(folderName: bookID, fileName: bookID)
    }
    
    // MARK: -- 操作
    /// 修改阅读记录为 指定章节ID 指定页码
    func modifyBookRecordModel(chapterID:String, page:NSInteger = 0, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        bookRecordModel.modify(chapterID: chapterID, toPage: page, isUpdateFont: isUpdateFont, isSave: isSave)
    }
    
    /// 修改阅读记录到书签模型
    func modifyBookRecordModel(bookMarkModel:FBookMarkModel, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        bookRecordModel.modify(bookMarkModel: bookMarkModel, isUpdateFont: isUpdateFont, isSave: isSave)
    }
    
    /// 保存
    func save() {
        // 阅读模型
        BookKeyedArchiver(folderName: bookID, fileName: bookID, object: self)
        // 阅读记录
        bookRecordModel.save()
    }
    
    ///  书签操作
    /// 添加书签 默认使用当前阅读记录作为书签
    func addMark(bookRecordModel:FBookRecordModel? = nil) {
        
        let bookRecordModel = (bookRecordModel != nil ? bookRecordModel : self.bookRecordModel)!
        
        let bookMarkModel = FBookMarkModel()
        
        bookMarkModel.bookID = bookRecordModel.bookChapterModel!.bookID
        
        bookMarkModel.id = bookRecordModel.bookChapterModel!.id
        
        bookMarkModel.name = bookRecordModel.bookChapterModel!.name
        
        bookMarkModel.location = NSNumber(value: bookRecordModel.bookChapterModel!.location(page: bookRecordModel.page.intValue))
        
        bookMarkModel.content = bookRecordModel.bookChapterModel!.string(page: bookRecordModel.page.intValue)
        
        bookMarkModel.time = Date()
        
        bookMarkModels.append(bookMarkModel)
        
        save()
    }
    
    /// 删除书签 默认使用当前存在的书签
    func removeMark(bookMarkModel:FBookMarkModel? = nil, index:NSInteger? = nil) ->Bool {
        
        if index != nil {
            bookMarkModels.remove(at: index!)
            save()
            return true
            
        }else{
            
            let bookMarkModel = (bookMarkModel != nil ? bookMarkModel : self.bookMarkModel)
            if bookMarkModel != nil && bookMarkModels.contains(bookMarkModel!) {
                bookMarkModels.remove(at: bookMarkModels.index(of: bookMarkModel!)!)
                save()
                return true
            }
        }
        return false
    }
    
    /// 检查当前页面是否存在书签 默认使用当前阅读记录作为检查对象
    func checkMark(bookRecordModel:FBookRecordModel? = nil) ->Bool {
        let bookRecordModel = (bookRecordModel != nil ? bookRecordModel : self.bookRecordModel)!
        let chapterID = bookRecordModel.bookChapterModel!.id
        var results:[FBookMarkModel] = []
        for model in bookMarkModels {
            if model.id == chapterID {
                results.append(model)
            }
        }
        
        if !results.isEmpty {
            // 当前显示页面的Range
            let range = bookRecordModel.bookChapterModel!.rangeArray[bookRecordModel.page.intValue]
            // 便利
            for bookMarkModel in results {
                
                let location = bookMarkModel.location.intValue
                
                if location >= range.location && location < (range.location + range.length) {
                    self.bookMarkModel = bookMarkModel
                    return true
                }
            }
        }
        // 清空
        bookMarkModel = nil
        
        return false
    }
    
}
