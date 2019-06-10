//
//  FReadViewCell.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FReadViewCell: UITableViewCell {

    /// 阅读View 显示使用
    private(set) var readView:FReadView!
    
    /// 当前的显示的内容
    var content:String! {
        
        didSet{
            
            if !content.isEmpty { // 有值
                
                readView.content = content
            }
        }
    }
    
    class func cellWithTableView(_ tableView:UITableView) ->FReadViewCell {
        
        let ID = "DZMReadViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? FReadViewCell
        
        if (cell == nil) {
            
            cell = FReadViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: ID)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubViews()
    }
    
    func addSubViews() {
        
        // 阅读View
        readView = FReadView()
        
        readView.backgroundColor = UIColor.clear
        
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 布局
        readView.frame = GetBookViewFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }

}
