//
//  FLeftView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//
/*
 左侧章节列表视图
 */
import UIKit

class FLeftView: FBaseView,FSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource {
    
    /// topView
    private(set) var topView:FSegmentedControl!
    
    /// UITableView
    private(set) var tableView:UITableView!
    
    /// contentView
    private(set) var contentView:UIView!
    
    /// 类型 0: 章节 1: 书签
    private var type:NSInteger = 0
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // contentView
        contentView = UIView()
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addSubview(contentView)
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
        
        // topView
        topView = FSegmentedControl()
        topView.delegate = self
        topView.normalTitles = ["章节","书签"]
        topView.selectTitles = ["章节","书签"]
        topView.horizontalShowTB = false
        topView.backgroundColor = UIColor.clear
        topView.normalTitleColor = FColor_6
        topView.selectTitleColor = FColor_2
        topView.setup()
        contentView.addSubview(topView)
    }
    
    // MARK: -- 定位到阅读记录
    func scrollReadRecord() {
        
        if type == 0 { // 章节
            
            let bookChapterModel = readMenu.vc.bookModel.bookRecordModel.bookChapterModel
            
            let bookBaseChapterModels = readMenu.vc.bookModel.bookBaseChapterModels
            
            if bookChapterModel != nil && bookBaseChapterModels.count != 0 {
                
                DispatchQueue.global().async { [weak self] ()->Void in
                    
                    for i in 0..<bookBaseChapterModels.count {
                        
                        let model = bookBaseChapterModels[i]
                        
                        if model.id == bookChapterModel!.id {
                            
                            // 更新UI
                            DispatchQueue.main.async { [weak self] ()->Void in
                                
                                self?.tableView.scrollToRow(at: IndexPath(row: i, section: 0), at: UITableView.ScrollPosition.middle, animated: false)
                            }
                            
                            return
                        }
                    }
                }
            }
        }
    }
    
    
    // MARK: -- DZMSegmentedControlDelegate
    func segmentedControl(segmentedControl: FSegmentedControl, clickButton button: UIButton, index: NSInteger) {
        
        type = index
        
        tableView.reloadData()
        
        scrollReadRecord()
    }
    
    /// 布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // contentView
        let contentViewW:CGFloat = width * 0.6
        contentView.frame = CGRect(x: -contentViewW, y: 0, width: contentViewW, height: height)
        
        // topView
        let topViewY:CGFloat = isX ? TopLiuHaight : 0
        let topViewH:CGFloat = 33
        topView.frame = CGRect(x: 0, y: topViewY, width: contentViewW, height: topViewH)
        
        // tableView
        let tableViewY = topView.frame.maxY
        tableView.frame = CGRect(x: 0, y: tableViewY, width: contentView.width, height: height - tableViewY)
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == 0 { // 章节
            
            return (readMenu.vc.bookModel != nil ? readMenu.vc.bookModel.bookBaseChapterModels.count : 0)
            
        }else{ // 书签
            
            return (readMenu.vc.bookModel != nil ? readMenu.vc.bookModel.bookMarkModels.count : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "FLeftViewCell")
        
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "FLeftViewCell")
            
            cell?.selectionStyle = .none
            
            cell?.backgroundColor = UIColor.clear
        }
        
        if type == 0 { // 章节
            
            cell?.textLabel?.text = readMenu.vc.bookModel.bookBaseChapterModels[indexPath.row].name
            
            cell?.textLabel?.numberOfLines = 1
            
            cell?.textLabel?.font = FFont_18
            
        }else{ // 书签
            
            let readMarkModel = readMenu.vc.bookModel.bookMarkModels[indexPath.row]
            
            cell?.textLabel?.text = "\n\(readMarkModel.name!)\n\(GetTimerString(dateFormat: "YYYY-MM-dd HH:mm:ss", date: readMarkModel.time!))\n\(readMarkModel.content!))"
            
            cell?.textLabel?.numberOfLines = 0
            
            cell?.textLabel?.font = FFont_12
        }
        
        cell?.textLabel?.textColor = FColor_6
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == 0 { // 章节
            
            return 44
            
        }else{ // 书签
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == 0 { // 章节
            
            readMenu.delegate?.readMenuClickChapterList?(readMenu: readMenu, bookBaseChapterModel: readMenu.vc.bookModel.bookBaseChapterModels[indexPath.row])
            
        }else{ // 书签
            
            readMenu.delegate?.readMenuClickMarkList?(readMenu: readMenu, bookMarkModel: readMenu.vc.bookModel.bookMarkModels[indexPath.row])
        }
        
        // 隐藏
        readMenu.leftView(isShow: false, complete: nil)
    }
    
    // MARK: -- 删除操作
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if type == 0 { // 章节
            
            return false
            
        }else{ // 书签
            
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let _ = readMenu.vc.bookModel.removeMark(bookMarkModel: nil, index: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
}
