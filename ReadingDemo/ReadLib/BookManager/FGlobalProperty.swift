//
//  FGlobalProperty.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/17.
//  Copyright © 2019 An. All rights reserved.
//
/*
 全局属性
 */
import UIKit

/// 翻页类型
enum FEffectType:NSInteger {
    case none               // 无效果
    case translation        // 平移
    case simulation         // 仿真
    case upAndDown          // 上下
}

/// 字体类型
enum FFontType:NSInteger {
    case system             // 系统
    case blackbody          // 黑体
    case regularScript      // 楷体
    case songTypeface       // 宋体
} 

// MARK: -- 屏幕属性
/// 屏幕宽度
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

/// iPhone X
let isX:Bool = (ScreenHeight == CGFloat(812) && ScreenWidth == CGFloat(375))

/// 导航栏高度
let NavgationBarHeight:CGFloat = isX ? 88 : 64

/// TabBar高度
let TabBarHeight:CGFloat = 49

/// iPhone X 顶部刘海高度
let TopLiuHaight:CGFloat = 30

/// StatusBar高度
let StatusBarHeight:CGFloat = isX ? 44 : 20


// MARK: -- 颜色支持

/// 灰色
let FColor_1:UIColor = RGB(51, g: 51, b: 51)

/// 粉红色
let FColor_2:UIColor = RGB(253, g: 85, b: 103)

/// 阅读上下状态栏颜色
let FColor_3:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读上下状态栏字体颜色
let FColor_4:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读颜色
let FColor_5:UIColor = RGB(145, g: 145, b: 145)

/// LeftView文字颜色
let FColor_6:UIColor = RGB(200, g: 200, b: 200)


/// 阅读背景颜色支持
let FBookBGColor_1:UIColor = RGB(238, g: 224, b: 202)
let FBookBGColor_2:UIColor = RGB(205, g: 239, b: 205)
let FBookBGColor_3:UIColor = RGB(206, g: 233, b: 241)
let FBookBGColor_4:UIColor = RGB(251, g: 237, b: 199)  // 牛皮黄
let FBookBGColor_5:UIColor = RGB(51, g: 51, b: 51)

/// 菜单背景颜色
let FMenuUIColor:UIColor = UIColor.black.withAlphaComponent(0.85)

// MARK: -- 字体支持
let FFont_10:UIFont = UIFont.systemFont(ofSize: 10)
let FFont_12:UIFont = UIFont.systemFont(ofSize: 12)
let FFont_14:UIFont = UIFont.systemFont(ofSize: 14)
let FFont_16:UIFont = UIFont.systemFont(ofSize: 16)
let FFont_18:UIFont = UIFont.systemFont(ofSize: 18)


// MARK: -- 间距支持
let FSpace_1:CGFloat = 15
let FSpace_2:CGFloat = 25
let FSpace_3:CGFloat = 1
let FSpace_4:CGFloat = 10
let FSpace_5:CGFloat = 20
let FSpace_6:CGFloat = 5

// MARK: 拖拽触发光标范围
let FCursorOffset:CGFloat = -20


// MARK: -- Key
/// 是夜间还是日间模式   true:夜间 false:日间
let FKey_IsNighOrtDay:String = "isNightOrDay"

/// ReadView 手势开启状态
let FKey_ReadView_Ges_isOpen:String = "isOpen"

// MARK: 通知名称
/// ReadView 手势通知
let FNotificationName_ReadView_Ges = "BookView_Ges"
