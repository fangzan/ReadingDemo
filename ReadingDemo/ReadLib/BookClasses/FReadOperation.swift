//
//  FReadOperation.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//
/*
 阅读操作对象
 */
import UIKit

class FReadOperation: NSObject {
    /// 阅读控制器
    weak var vc:FReadController!
    
    // MARK: -- init
    init(vc:FReadController) {
        
        super.init()
        self.vc = vc
    }
    
    // MARK: -- 获取阅读控制器 DZMReadViewController
    
    /// 获取阅读View控制器
    func GetReadViewController(bookRecordModel:FBookRecordModel?) ->FReadViewController? {
        
        if bookRecordModel != nil {
            let readViewController = FReadViewController()
            readViewController.bookRecordModel = bookRecordModel
            readViewController.readController = vc
            return readViewController
        }
        return nil
    }
    
    /// 获取当前阅读记录的阅读View控制器
    func GetCurrentReadViewController(isUpdateFont:Bool = false, isSave:Bool = false) ->FReadViewController? {
        if isUpdateFont {
            vc.bookModel.bookRecordModel.updateFont(isSave: true)
        }
        if isSave {
            readRecordUpdate(bookRecordModel: vc.bookModel.bookRecordModel)
        }
        return GetReadViewController(bookRecordModel: vc.bookModel.bookRecordModel.copySelf())
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->FReadViewController? {
        
        // 没有阅读模型
        if vc.bookModel == nil || !vc.bookModel.bookRecordModel.isRecord {return nil}
        // 阅读记录
        var bookRecordModel:FBookRecordModel?
        // 判断
        if vc.bookModel.isLocalBook.boolValue { // 本地小说
            // 获得阅读记录
            bookRecordModel = vc.bookModel.bookRecordModel.copySelf()
            // 章节ID
            let id = vc.bookModel.bookRecordModel.bookChapterModel!.id.integerValue()
            // 页码
            let page = vc.bookModel.bookRecordModel.page.intValue
            // 到头了
            if id == 1 && page == 0 {return nil}
            print("阅读到第\(id)章，第\(page)页")
            if page == 0 { // 这一章到头了
                // 缓存下一章
                DispatchQueue.global().async {
                    print("开启缓存下一章")
                    FBookParser.ParserChapter(content: self.vc.bookModel.bookContent, bookBaseChapterModels: self.vc.bookModel.bookBaseChapterModels, chapterID: "\(id - 1)")
                }
                bookRecordModel?.modify(chapterID: "\(id - 1)", toPage: FBookLastPageValue, isUpdateFont:true, isSave: false)
            }else{ // 没到头
                bookRecordModel?.page = NSNumber(value: (page - 1))
            }
            
        }else{ // 网络小说
            
            /*
             网络小说操作提示:
             
             1. 获得阅读记录
             
             2. 获得当前章节ID
             
             3. 获得当前阅读章节 读到的页码
             
             4. 判断是否为这一章最后一页
             
             5. 1). 判断不是第一页则 page - 1 继续翻页
             2). 如果是第一页则判断上一章的章节ID是否有值,没值就是当前没有跟多章节（连载中）或者 全书完, 有值则判断是否存在缓存文件.
             有缓存文件则拿出使用更新阅读记录, 没值则请求服务器获取，请求回来之后可动画展示出来
             
             提示：如果是请求回来之后并更新了阅读记录 可使用 GetCurrentReadViewController() 获得当前阅读记录的控制器 进行展示
             */
            
            bookRecordModel = nil
        }
        return GetReadViewController(bookRecordModel: bookRecordModel)
    }
    
    
    /// 获得下一页控制器
    func GetBelowReadViewController() ->FReadViewController? {
        
        // 没有阅读模型
        if vc.bookModel == nil || !vc.bookModel.bookRecordModel.isRecord {return nil}
        // 阅读记录
        var bookRecordModel:FBookRecordModel?
        // 判断
        if vc.bookModel.isLocalBook.boolValue { // 本地小说
            // 获得阅读记录
            bookRecordModel = vc.bookModel.bookRecordModel.copySelf()
            // 章节ID
            let id = vc.bookModel.bookRecordModel.bookChapterModel!.id.integerValue()
            // 页码
            let page = vc.bookModel.bookRecordModel.page.intValue
            // 最后一页
            let lastPage = vc.bookModel.bookRecordModel.bookChapterModel!.pageCount.intValue - 1
            // 到头了
            if id == vc.bookModel.bookBaseChapterModels.count && page == lastPage {return nil}
            debugPrint("阅读到第\(id)章，第\(page)页")
            if page == lastPage { // 这一章到头了
                // 缓存下一章
                DispatchQueue.global().async {
                    debugPrint("开启缓存下一章")
                    FBookParser.ParserChapter(content: self.vc.bookModel.bookContent, bookBaseChapterModels: self.vc.bookModel.bookBaseChapterModels, chapterID: "\(id + 1)")
                }
                bookRecordModel?.modify(chapterID: "\(id + 1)", isUpdateFont: true)
            }else{ // 没到头
                bookRecordModel?.page = NSNumber(value: (page + 1))
            }
            
        }else{ // 网络小说
            
            /*
             网络小说操作提示:
             
             1. 获得阅读记录
             
             2. 获得当前章节ID
             
             3. 获得当前阅读章节 读到的页码
             
             4. 判断是否为这一章最后一页
             
             5. 1). 判断不是最后一页则 page + 1 继续翻页
             2). 如果是最后一页则判断下一章的章节ID是否有值,没值就是当前没有跟多章节（连载中）或者 全书完, 有值则判断是否存在缓存文件.
             有缓存文件则拿出使用更新阅读记录, 没值则请求服务器获取，请求回来之后可动画展示出来
             
             提示：如果是请求回来之后并更新了阅读记录 可使用 GetCurrentReadViewController() 获得当前阅读记录的控制器 进行展示
             */
            
            bookRecordModel = nil
        }
        
        return GetReadViewController(bookRecordModel: bookRecordModel)
    }
    
    /// 跳转指定章节 指定页码 (toPage: -1 为最后一页 也可以使用 DZMReadLastPageValue)
    func GoToChapter(chapterID:String, toPage:NSInteger = 0) ->Bool {
        
        if vc.bookModel != nil { // 有阅读模型
            if vc.bookModel!.isLocalBook.boolValue {
                if FBookChapterModel.IsExistBookChapterModel(bookID: vc.bookModel.bookID, chapterID: chapterID) { //  存在
                    
                    vc.bookModel.modifyBookRecordModel(chapterID: chapterID, page: toPage, isSave: false)
                    
                    vc.creatPageController(GetCurrentReadViewController(isUpdateFont: true, isSave: true))
                    
                    return true
                    
                }else{ // 不存在
                    // 缓存下一章
                    MBProgressHUD.showMessage("努力加载中...")
                    DispatchQueue.global().async {
                        debugPrint("开启缓存下一章,当前章节\(chapterID)章")
                        FBookParser.ParserChapter(content: self.vc.bookModel.bookContent, bookBaseChapterModels: self.vc.bookModel.bookBaseChapterModels, chapterID: chapterID)
                        DispatchQueue.main.async(execute: {()->() in
                            MBProgressHUD.hide()
                            self.vc.bookModel.modifyBookRecordModel(chapterID: chapterID, page: toPage, isSave: false)
                            self.vc.creatPageController(self.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
                        })
                    }
                    
                }
            } else {
                /*
                 网络小说操作提示:
                 
                 1. 请求章节内容 并缓存
                 
                 2. 修改阅读记录 并展示
                 */
                
                return false
            }
        }
        return false
    }
    
    // MARK: -- 同步记录
    
    /// 更新记录
    func readRecordUpdate(readViewController:FReadViewController?, isSave:Bool = true) {
        
        readRecordUpdate(bookRecordModel: readViewController?.bookRecordModel, isSave: isSave)
    }
    
    /// 更新记录
    func readRecordUpdate(bookRecordModel:FBookRecordModel?, isSave:Bool = true) {
        
        if bookRecordModel != nil {
            
            vc.bookModel.bookRecordModel = bookRecordModel
            
            if isSave {
                
                // 保存
                vc.bookModel.bookRecordModel.save()
                
                // 更新UI
                DispatchQueue.main.async { [weak self] ()->Void in
                    
                    // 进度条数据初始化
                    self?.vc.readMenu.bottomView.sliderUpdate()
                }
            }
        }
    }
}
