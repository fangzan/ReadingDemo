//
//  FBookParser.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/16.
//  Copyright © 2019 An. All rights reserved.
//
/*
 书籍解析工具
 */

import UIKit

class FBookParser: NSObject {
    
    // MARK: -- 解析网络小说文件
    
    /// 异步线程 解析网络URL
    ///
    /// - Parameters:
    ///   - url: 网络小说文本URL
    ///   - complete: 成功返回true  失败返回false
    ///   - returns: ReadModel
    @objc class func ParserNetURL(url:URL,complete:((_ bookModel:FBookModel) ->Void)?) {
        DispatchQueue.global().async {
            let bookModel = FBookParser.ParserNetURL(url: url)
            DispatchQueue.main.async(execute: {()->() in
                if complete != nil {complete!(bookModel)}
            })
        }
    }
    
    /// 主线程 解析本地URL
    ///
    /// - Parameter url: URL
    /// - Returns: ReadModel
    @objc class func ParserNetURL(url:URL) ->FBookModel {
        
        let bookID = GetFileName(url)// 获取书籍ID
        if !FBookModel.IsExistBookModel(bookID: bookID) { // 不存在
            // 阅读模型
            let bookModel = FBookModel.bookModel(bookID: bookID)
            // 解析数据
            let content = FBookParser.EncodeURL(url)
            // 获得章节列表
            bookModel.bookBaseChapterModels = ParserContent(bookID: bookID, content: content)
            // 设置阅读记录 第一个章节 为 首个章节ID
            bookModel.modifyBookRecordModel(chapterID: bookModel.bookBaseChapterModels.first!.id)
            // 保存
            bookModel.save()
            // 返回
            return bookModel
        }else{ // 存在
            // 返回
            return FBookModel.bookModel(bookID: bookID)
        }
    }
    
    // MARK: -- 解析本地小说文件
    
    /// 异步线程 解析本地URL
    ///
    /// - Parameters:
    ///   - url: 本地小说文本URL
    ///   - complete: 成功返回true  失败返回false
    ///   - returns: ReadModel
    @objc class func ParserLocalURL(url:URL,complete:((_ bookModel:FBookModel) ->Void)?) {
        DispatchQueue.global().async {
            let readModel = FBookParser.ParserLocalURL(url: url)
            DispatchQueue.main.async(execute: {()->() in
                if complete != nil {complete!(readModel)}
            })
        }
    }
    
    /// 主线程 解析本地URL
    ///
    /// - Parameter url: URL
    /// - Returns: ReadModel
    @objc class func ParserLocalURL(url:URL) ->FBookModel {
        
        let bookID = GetFileName(url)
        
        if !FBookModel.IsExistBookModel(bookID: bookID) { // 不存在
            // 阅读模型
            let bookModel = FBookModel.bookModel(bookID: bookID)
            // 数据Url
            bookModel.bookUrl = url
            // 解析数据
            let startTime = CFAbsoluteTimeGetCurrent()
            let content = FBookParser.EncodeURL(bookModel.bookUrl)
            let endTime = CFAbsoluteTimeGetCurrent()
            debugPrint("\((#file as NSString).lastPathComponent):\(#line) \(#function)->代码执行时长:\((endTime - startTime)*1000)毫秒")
            // 书籍内容
            bookModel.bookContent = content
            // 获得章节列表
            bookModel.bookBaseChapterModels = ParserContent(bookID: bookID, content: content)
            // 解析文章内容(异步)
            ParserChapter(content: content, bookBaseChapterModels: bookModel.bookBaseChapterModels, chapterID: bookModel.bookBaseChapterModels.first!.id)
            // 设置阅读记录 第一个章节 为 首个章节ID
            bookModel.modifyBookRecordModel(chapterID: bookModel.bookBaseChapterModels.first!.id)
            // 保存
            bookModel.save()
            // 返回
            return bookModel
        }else{ // 存在
            // 返回
            return FBookModel.bookModel(bookID: bookID)
        }
    }
    
    // MARK: -- 解析ChapterLists
    
    /// 解析ChapterLists
    ///
    /// - Parameters:
    ///   - bookID: 小说ID
    ///   - content: 内容
    /// - Returns: 章节列表模型数组
    private class func ParserContent(bookID:String, content:String) ->[FBookBaseChapterModel] {
        
        // 章节列表数组
        var bookBaseChapterModels:[FBookBaseChapterModel] = []
        
        let startTime = CFAbsoluteTimeGetCurrent()
        // 搜索
        var results:[NSTextCheckingResult] = GetContentCheckingResult(content: content)
        if results.count <= 0 { return bookBaseChapterModels }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        debugPrint("代码执行时长：%f 毫秒", (endTime - startTime)*1000)
        
        // 解析搜索结果
        if !results.isEmpty {
            // 记录最后一个Range
            var lastRange = NSMakeRange(0, 0)
            // 数量
            let count = results.count
            // 记录 上一章 模型
            var lastBookBaseChapterModel:FBookBaseChapterModel?
            let startTime = CFAbsoluteTimeGetCurrent()
            // 便利
            for i in 0...count {
                // 章节数量分析:
                // count + 1  = 搜索到的章节数量 + 最后一个章节,
                // 1 + count + 1  = 第一章前面的前言内容 + 搜索到的章节数量 + 最后一个章节
                print("总章节数:\(count + 1)  当前解析到:\(i + 1)  章节标题:\(String(describing: lastBookBaseChapterModel?.name))")
                // range
                var range = NSMakeRange(0, 0)
                var location = 0
                if i < count {
                    range = results[i].range
                    location = range.location
                }
                // 创建章节内容模型
                let bookBaseChapterModel = FBookBaseChapterModel()
                // 书ID
                bookBaseChapterModel.bookID = bookID
                // 章节ID
                bookBaseChapterModel.id = "\(i + 1)"
                // 优先级
                bookBaseChapterModel.priority = NSNumber(value: i)
                
                if i == 0 { // 开始
                    // 上一章的范围
                    bookBaseChapterModel.lastContentRange = NSMakeRange(0, 0);
                    // 当前章的范围
                    bookBaseChapterModel.contentRange = NSMakeRange(0, location);
                    // 章节名
                    bookBaseChapterModel.name = "开始"
                    // 记录
                    lastRange = range
                }else if i == count { // 结尾
                    // 当前章的范围
                    bookBaseChapterModel.contentRange = NSMakeRange(lastRange.location, content.length - lastRange.location)
                    // 上一章的下一章范围
                    lastBookBaseChapterModel?.nextContentRange = bookBaseChapterModel.contentRange
                    // 上一章的范围
                    bookBaseChapterModel.lastContentRange = lastBookBaseChapterModel?.contentRange
                    // 下一章的范围
                    bookBaseChapterModel.nextContentRange = NSMakeRange(0, 0)
                    // 章节名
                    bookBaseChapterModel.name = content.substring(lastRange)
                }else { // 中间章节
                    // 当前章的范围
                    bookBaseChapterModel.contentRange = NSMakeRange(lastRange.location, location - lastRange.location)
                    // 上一章的下一章范围
                    lastBookBaseChapterModel?.nextContentRange = bookBaseChapterModel.contentRange
                    // 上一章的范围
                    bookBaseChapterModel.lastContentRange = lastBookBaseChapterModel?.contentRange
                    // 章节名
                    bookBaseChapterModel.name = content.substring(lastRange)
                }
                // 添加章节列表模型
                bookBaseChapterModels.append(bookBaseChapterModel)
                // 设置上下章ID
                bookBaseChapterModel.lastChapterId = lastBookBaseChapterModel?.id
                lastBookBaseChapterModel?.nextChapterId = bookBaseChapterModel.id
                // 记录
                lastRange = range
                lastBookBaseChapterModel = bookBaseChapterModel
            }
            let endTime = CFAbsoluteTimeGetCurrent()
            debugPrint("\((#file as NSString).lastPathComponent):\(#line) \(#function)->代码执行时长:\((endTime - startTime)*1000)毫秒")
        }else{
            // 创建章节内容模型
            let bookBaseChapterModel = FBookBaseChapterModel()
            // 书ID
            bookBaseChapterModel.bookID = bookID
            // 章节ID
            bookBaseChapterModel.id = "1"
            // 章节名
            bookBaseChapterModel.name = "开始"
            // 优先级
            bookBaseChapterModel.priority = NSNumber(value: 0)
            // 添加章节列表模型
            bookBaseChapterModels.append(bookBaseChapterModel)
        }
        return bookBaseChapterModels
    }
    
    
    /// 解析章节内容
    ///
    /// - Parameters:
    ///   - content: 整书籍内容
    ///   - bookBaseChapterModels: 章节基础信息
    ///   - chapterID: 当前章节Id
    @objc class func ParserChapter(content:String, bookBaseChapterModels:[FBookBaseChapterModel], chapterID:String) {
        
        let startTime = CFAbsoluteTimeGetCurrent()
        // 所有章节数
        let count = bookBaseChapterModels.count
        // 便利
        for i in 0..<count {
            // 获取章节基础数据模型
            let bookBaseChapterModel = bookBaseChapterModels[i]
            // 归档当前阅读章节的前后五章
            if i >= chapterID.integerValue() - 5 &&
                i <= chapterID.integerValue() + 5 &&
                !FBookChapterModel.IsExistBookChapterModel(bookID: bookBaseChapterModel.bookID, chapterID: bookBaseChapterModel.id) {
                // 章节数量分析:
                // count = 搜索到的章节数量 + 前言
                print("总章节数:\(count)  当前归档到:\(i + 1)")
                // 解析chapterID的前后五章
                // 创建章节内容模型
                let bookChapterModel = FBookChapterModel.bookChapterModel(bookID: bookBaseChapterModel.bookID, chapterID: bookBaseChapterModel.id)
                // 章节名
                bookChapterModel.name = bookBaseChapterModel.name
                // 优先级
                bookChapterModel.priority = bookBaseChapterModel.priority
                // 内容
                bookChapterModel.content = ContentTypeSetting(content: content.substring(bookBaseChapterModel.contentRange!))
                // 分页
                bookChapterModel.updateFont()
                // 保存
                bookChapterModel.save()
            }
        }
        let endTime = CFAbsoluteTimeGetCurrent()
        debugPrint("整理章节代码执行时长：%f 毫秒", (endTime - startTime)*1000)
    }
    
    /// 正则搜索文章章节点
    ///
    /// - Parameter content: 文章内容
    /// - Returns: 章节点
    private class func GetContentCheckingResult(content:String) -> [NSTextCheckingResult] {
        // 正则
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        // 搜索
        var results:[NSTextCheckingResult] = []
        do {
            // 创建正则表达式
            let regularExpression:NSRegularExpression = try NSRegularExpression(pattern: parten, options: .caseInsensitive)
            // 正则匹配搜索
            results = regularExpression.matches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.length))
        } catch {
            debugPrint("\((#file as NSString).lastPathComponent):\(#line) \(#function) 正则匹配章节失败")
        }
        return results
    }
    
    // MARK: -- 对内容进行整理排版 比如去掉多余的空格或者段头留2格等等
    
    /// 内容排版整理
    @objc class func ContentTypeSetting(content:String) ->String {
        
        // 替换单换行
        var content = content.replacingOccurrences(of: "\r", with: "")
        // 替换换行 以及 多个换行 为 换行加空格
        content = content.replacing(pattern: "\\s*\\n+\\s*", template: "\n　　")
        // 返回
        return content
    }
    
    // MARK: -- 内容分页

    /// 内容分页
    ///
    /// - Parameters:
    ///   - string: 内容
    ///   - rect: 范围
    ///   - attrs: 文字属性
    /// - Returns: 每一页的起始位置数组
    @objc class func ParserPageRange(string:String, rect:CGRect, attrs:[NSAttributedString.Key:Any]?) ->[NSRange] {
        
        // 记录
        var rangeArray:[NSRange] = []
        
        // 拼接字符串
        let attrString = NSMutableAttributedString(string: string, attributes: attrs)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        return rangeArray
    }
    
    // MARK: -- 解码URL
    
    /// 解码URL
    @objc class func EncodeURL(_ url:URL) ->String {
        
        var content = ""
        
        // 检查URL是否有值
        if url.absoluteString.isEmpty {
            
            return content
        }
        
        // NSUTF8StringEncoding 解析
        content = EncodeURL(url, encoding: String.Encoding.utf8.rawValue)
        
        // 进制编码解析
        if content.isEmpty {
            
            content = EncodeURL(url, encoding: 0x80000632)
        }
        
        if content.isEmpty {
            
            content = EncodeURL(url, encoding: 0x80000631)
        }
        
        if content.isEmpty {
            
            content = ""
        }
        
        return content
    }
    
    /// 解析URL
    private class func EncodeURL(_ url:URL,encoding:UInt) ->String {
        
        do{
            return try NSString(contentsOf: url, encoding: encoding) as String
            
        }catch{}
        
        return ""
    }
    
    // MARK: -- 获得 FrameRef CTFrame
    
    /// 获得 CTFrame
    @objc class func GetReadFrameRef(content:String, attrs:[NSAttributedString.Key:Any]?, rect:CGRect) ->CTFrame {
        
        let attributedString = NSMutableAttributedString(string: content,attributes: attrs)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        return frameRef
    }
}
