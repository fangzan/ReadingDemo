//
//  FSettingFuncView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

/// 小说FuncView支持类型
enum FFuncViewType:NSInteger {
    case effect
    case font
    case fontSize
}

import UIKit

class FSettingFuncView: FBaseView {

    /// 标题
    private(set) var title:String!
    
    /// 标签数组
    private(set) var labels:[String] = []
    
    /// 选中索引
    private(set) var selectIndex:NSInteger = 0
    
    /// 类型
    private(set) var funcType:FFuncViewType!
    
    /// 选中按钮
    private(set) var selectButton:UIButton?
    
    /// titleLabel
    private(set) var titleLabel:UILabel!
    
    /// 字号按钮
    private(set) var leftButton:UIButton!
    private(set) var rightButton:UIButton!
    
    /// 字体大小增减间隙
    private(set) var fontSpace:NSInteger = 1
    
    /// 初始化方法
    convenience init(frame:CGRect,readMenu:FReadMenu,funcType:FFuncViewType,title:String) {
        
        self.init(frame:frame,readMenu:readMenu,funcType:funcType,title:title,labels:[],selectIndex:0)
    }
    
    /// 初始化方法
    init(frame:CGRect,readMenu:FReadMenu,funcType:FFuncViewType,title:String,labels:[String],selectIndex:NSInteger) {
        
        self.funcType = funcType
        
        self.title = title
        
        self.labels = labels
        
        self.selectIndex = selectIndex
        
        super.init(frame: frame, readMenu: readMenu)
    }
    
    override func addSubviews() {
        
        // 标题
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        titleLabel.font = FFont_12
        titleLabel.text = title
        addSubview(titleLabel)
        titleLabel.frame = CGRect(x: FSpace_2, y: 0, width: 55, height: height)
        
        // 布局
        let tempX:CGFloat = titleLabel.frame.maxX + FSizeW(50)
        let contentW:CGFloat = ScreenWidth - tempX
        
        if funcType == .font || funcType == .effect {
            
            let count = labels.count
            
            let buttonW:CGFloat = contentW / CGFloat(count)
            
            for i in 0..<count {
                
                let label = labels[i]
                
                let button = UIButton(type: .custom)
                
                button.tag = i
                
                button.titleLabel?.font = FFont_12
                
                button.contentHorizontalAlignment = .left
                
                button.setTitle(label, for: .normal)
                
                button.setTitleColor(UIColor.white, for: .normal)
                
                button.setTitleColor(FColor_2, for: .selected)
                
                button.frame = CGRect(x: tempX + CGFloat(i) * buttonW, y: 0, width: buttonW, height: height)
                
                button.addTarget(self, action: #selector(clickButton(button:)), for: .touchUpInside)
                
                addSubview(button)
                
                if i == selectIndex {
                    
                    selectButton(button: button)
                }
            }
            
        }else{ // 字体大小
            
            let buttonW:CGFloat = (contentW - FSpace_1 + FSpace_3) / 2
            let buttonSpaceW:CGFloat = FSpace_3
            
            // left
            leftButton = UIButton(type: .custom)
            leftButton.tag = 0
            leftButton.contentHorizontalAlignment = .right
            leftButton.setImage(UIImage(named:"RM_15"), for: .normal)
            leftButton.frame = CGRect(x: tempX, y: 0, width: buttonW, height: height)
            leftButton.addTarget(self, action: #selector(clickFontSize(button:)), for: .touchUpInside)
            addSubview(leftButton)
            
            // right
            rightButton = UIButton(type: .custom)
            rightButton.tag = 1
            rightButton.contentHorizontalAlignment = .left
            rightButton.setImage(UIImage(named:"RM_16"), for: .normal)
            rightButton.frame = CGRect(x: leftButton.frame.maxX - buttonSpaceW, y: 0, width: buttonW, height: height)
            rightButton.addTarget(self, action: #selector(clickFontSize(button:)), for: .touchUpInside)
            addSubview(rightButton)
        }
    }
    
    /// .fontSize
    @objc func clickFontSize(button:UIButton) {
        
        if button.tag == 0 { // left
            
            // 没有小于最小字体
            if (FBookConfigure.shared().fontSize - fontSpace) >= FBookMinFontSize {
                
                FBookConfigure.shared().fontSize -= fontSpace
                
                readMenu.delegate?.readMenuClickSetuptFontSize?(readMenu: readMenu, fontSize: CGFloat(FBookConfigure.shared().fontSize))
            }
            
        }else{ // right
            
            // 没有大于最大字体
            if (FBookConfigure.shared().fontSize + fontSpace) <= FBookMaxFontSize {
                
                FBookConfigure.shared().fontSize += fontSpace
                
                readMenu.delegate?.readMenuClickSetuptFontSize?(readMenu: readMenu, fontSize: CGFloat(FBookConfigure.shared().fontSize))
            }
        }
    }
    
    /// .font .effect
    @objc func clickButton(button:UIButton) {
        
        if button.isSelected {return}
        
        // 选中按钮
        selectButton(button: button)
        
        // 判断
        if funcType == .font {
            
            readMenu.delegate?.readMenuClickSetuptFont?(readMenu: readMenu, index: button.tag)
            
        }else{
            
            readMenu.delegate?.readMenuClickSetuptEffect?(readMenu: readMenu, index: button.tag)
        }
    }
    
    /// 选中按钮
    private func selectButton(button:UIButton) {
        
        if button.isSelected {return}
        
        selectButton?.isSelected = false
        
        button.isSelected = true
        
        selectButton = button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
