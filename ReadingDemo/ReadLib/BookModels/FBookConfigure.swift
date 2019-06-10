//
//  FBookConfigure.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/17.
//  Copyright © 2019 An. All rights reserved.
//

/// key
let FBookConfigureKey:String = "ReadConfigure"
/// 单利对象
private var instance:FBookConfigure? = FBookConfigure.bookInfo()

// MARK: -- 配置属性

/// 背景颜色数组
let FBookBGColors:[UIColor] = [UIColor.white,FBookBGColor_1,FBookBGColor_2,FBookBGColor_3,FBookBGColor_4,FBookBGColor_5]
/// 根据背景颜色 对应的文字颜色 数组(数量必须与 FBookBGColors 相同)
let FBookTextColors:[UIColor] = [FColor_5,FColor_5,FColor_5,FColor_5,FColor_5,FColor_5]
/// 阅读最小阅读字体大小
let FBookMinFontSize:NSInteger = 12
/// 阅读最大阅读字体大小
let FBookMaxFontSize:NSInteger = 25
/// 阅读当前默认字体大小
let FBookDefaultFontSize:NSInteger = 14
/// 阅读自动加载数量
let FBookAutoLoadNumber:NSInteger = 10


import UIKit

class FBookConfigure: NSObject {
    // MARK: -- 属性
    
    /// 当前阅读的背景颜色
    @objc var colorIndex:NSInteger = 0 {didSet{save()}}
    /// 字体类型
    @objc var fontType:NSInteger = FFontType.system.rawValue {didSet{save()}}
    /// 字体大小
    @objc var fontSize:NSInteger = FBookDefaultFontSize {didSet{save()}}
    /// 翻页效果
    @objc var effectType:NSInteger = FEffectType.simulation.rawValue {didSet{save()}}
    /// 阅读文字颜色(根据需求自己选)
    @objc var textColor:UIColor {
        
        // 固定颜色使用
        //        get{return DZMColor_5}
        
        // 根据背影颜色选择字体颜色(假如想要根据背景颜色切换字体颜色 需要在 configureBGColor() 方法里面调用 tableView.reloadData())
        get{return FBookTextColors[colorIndex]}
        
        
        // 日夜间区分颜色使用 (假如想要根据日夜间切换字体颜色 需要调用 tableView.reloadData() 或者取巧 使用上面的方式)
        //        get{
        //
        //            if DZMUserDefaults.boolForKey(DZMKey_IsNighOrtDay) { // 夜间
        //
        //                return DZMColor_5
        //
        //            }else{ // 日间
        //
        //                return DZMColor_5
        //            }
        //        }
    }
    
    // MARK: -- 操作
    
    /// 单例
    @objc class func shared() ->FBookConfigure {
        
        if instance == nil {
            
            instance = FBookConfigure.bookInfo()
        }
        
        return instance!
    }
    
    /// 保存
    @objc func save() {
        
        var dict = allPropertys()
        
        dict.removeValue(forKey: "textColor")
        
        FUserDefaults.setObject(dict, key: FBookConfigureKey)
    }
    
    /// 清理(暂无需求使用)
    private func clear() {
        
        instance = nil
        
        FUserDefaults.removeObjectForKey(FBookConfigureKey)
    }
    
    /// 获得文字属性字典 (isPaging: 为YES的时候只需要返回跟分页相关的属性即可 注意: 包含 UIColor , 小数点相关的...不可返回,因为无法进行比较)
    @objc func bookAttribute(isPaging:Bool = false) ->[NSAttributedString.Key:Any] {
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 行间距
        paragraphStyle.lineSpacing = FSpace_4
        
        // 段间距
        paragraphStyle.paragraphSpacing = FSpace_6
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = 1.0
        
        // 对其
        paragraphStyle.alignment = NSTextAlignment.justified
        
        // 返回
        if isPaging {
            
            // 只需要传回跟分页有关的属性即可
            return [NSAttributedString.Key.font:bookFont(), NSAttributedString.Key.paragraphStyle:paragraphStyle]
            
        }else{
            
            return [NSAttributedString.Key.foregroundColor:textColor, NSAttributedString.Key.font:bookFont(), NSAttributedString.Key.paragraphStyle:paragraphStyle]
        }
    }
    
    /// 获得颜色
    @objc func bookColor() ->UIColor {
        
        if colorIndex == FBookBGColors.index(of: FBookBGColor_4) { // 牛皮黄
            
            return UIColor(patternImage:UIImage(named: "read_bg_0")!)
            
        }else{
            
            return FBookBGColors[colorIndex]
        }
    }
    
    /// 获得文字Font
    @objc func bookFont() ->UIFont {
        
        if fontType == FFontType.blackbody.rawValue { // 黑体
            
            return UIFont(name: "EuphemiaUCAS-Italic", size: CGFloat(fontSize))!
            
        }else if fontType == FFontType.regularScript.rawValue { // 楷体
            
            return UIFont(name: "AmericanTypewriter-Light", size: CGFloat(fontSize))!
            
        }else if fontType == FFontType.songTypeface.rawValue { // 宋体
            
            return UIFont(name: "Papyrus", size: CGFloat(fontSize))!
            
        }else{ // 系统
            
            return UIFont.systemFont(ofSize: CGFloat(fontSize))
        }
    }
    
    // MARK: -- 构造初始化
    
    /// 创建获取内存中的用户信息
    @objc class func bookInfo() ->FBookConfigure {
        
        let info = FUserDefaults.objectForKey(FBookConfigureKey)
        
        return FBookConfigure(dict:info)
    }
    
    /// 初始化
    private init(dict:Any?) {
        
        super.init()
        
        setData(dict: dict)
    }
    
    /// 更新设置数据
    private func setData(dict:Any?) {
        
        if dict != nil {
            
            setValuesForKeys(dict as! [String : AnyObject])
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
