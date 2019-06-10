//
//  FSettingView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FSettingView: FBaseView {

    /// 颜色
    private(set) var colorView:FSettingColorView!
    
    /// 翻页效果
    private(set) var effectView:FSettingFuncView!
    
    /// 字体
    private(set) var fontView:FSettingFuncView!
    
    /// 字体大小
    private(set) var fontSizeView:FSettingFuncView!
    
    /// 添加控件
    override func addSubviews() {
        
        super.addSubviews()
        
        // 颜色
        colorView = FSettingColorView(frame:CGRect(x: 0, y: 0, width: ScreenWidth, height: 74),readMenu:readMenu,colors:FBookBGColors,selectIndex:FBookConfigure.shared().colorIndex)
        addSubview(colorView)
        
        // funcViewH
        let funcViewH:CGFloat = (height - (isX ? FSpace_1 : 0) - colorView.height) / 3
        
        // 翻页效果 labels 排放顺序参照 DZMRMNovelEffectType
        effectView = FSettingFuncView(frame:CGRect(x: 0, y: colorView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .effect, title:"翻书动画", labels:["无效果","平移","仿真","上下"], selectIndex:FBookConfigure.shared().effectType)
        addSubview(effectView)
        
        // 字体 labels 排放顺序参照 DZMRMNovelFontType
        fontView = FSettingFuncView(frame:CGRect(x: 0, y: effectView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .font, title:"字体", labels:["系统","黑体","楷体","宋体"], selectIndex:FBookConfigure.shared().fontType)
        addSubview(fontView)
        
        // 字体大小
        fontSizeView = FSettingFuncView(frame:CGRect(x: 0, y: fontView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .fontSize, title:"字号")
        addSubview(fontSizeView)
    }
    
}

