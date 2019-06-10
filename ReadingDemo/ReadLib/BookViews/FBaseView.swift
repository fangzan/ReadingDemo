//
//  FBaseView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FBaseView: UIControl {

    /// 菜单
    weak var readMenu:FReadMenu!
    
    /// 初始化方法
    convenience init(readMenu:FReadMenu) {
        
        self.init(frame:CGRect.zero,readMenu:readMenu)
    }
    
    /// 初始化方法
    init(frame:CGRect,readMenu:FReadMenu) {
        
        self.readMenu = readMenu
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 初始化方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 添加子控件
    func addSubviews() {
        
        backgroundColor = FMenuUIColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
