//
//  FBatteryView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

/// 电池宽推荐使用宽高
var FBatterySize:CGSize = CGSize(width: 25, height: 10)
/// 电池量宽度 跟图片的比例
private var FBatteryLevelViewW:CGFloat = 20
private var FBatteryLevelViewScale = FBatteryLevelViewW / FBatterySize.width

import UIKit

class FBatteryView: UIImageView {

    /// 颜色
    override var tintColor: UIColor! {
        didSet{
            batteryLevelView.backgroundColor = tintColor
        }
    }
    
    /// BatteryLevel
    var batteryLevel:Float = 0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    /// BatteryLevelView
    private var batteryLevelView:UIView!
    
    /// 初始化
    convenience init() {
        
        self.init(frame: CGRect(x: 0, y: 0, width: FBatterySize.width, height: FBatterySize.height))
    }
    
    /// 初始化
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: FBatterySize.width, height: FBatterySize.height))
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 进度
        batteryLevelView = UIView()
        batteryLevelView.layer.masksToBounds = true
        addSubview(batteryLevelView)
        
        // 设置样式
        image = UIImage(named: "G_Battery_Black")?.withRenderingMode(.alwaysTemplate)
        tintColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spaceW:CGFloat = 1 * (frame.width / FBatterySize.width) * FBatteryLevelViewScale
        let spaceH:CGFloat = 1 * (frame.height / FBatterySize.height) * FBatteryLevelViewScale
        
        let batteryLevelViewY:CGFloat = 2.1*spaceH
        let batteryLevelViewX:CGFloat = 1.4*spaceW
        let batteryLevelViewH:CGFloat = frame.height - 3.4*spaceH
        let batteryLevelViewW:CGFloat = frame.width * FBatteryLevelViewScale
        let batteryLevelViewWScale:CGFloat = batteryLevelViewW / 100
        
        // 判断电量
        var tempBatteryLevel = batteryLevel
        
        if batteryLevel < 0 {
            
            tempBatteryLevel = 0
            
        }else if batteryLevel > 1 {
            
            tempBatteryLevel = 1
            
        }else{}
        
        batteryLevelView.frame = CGRect(x: batteryLevelViewX , y: batteryLevelViewY, width: CGFloat(tempBatteryLevel * 100) * batteryLevelViewWScale, height: batteryLevelViewH)
        batteryLevelView.layer.cornerRadius = batteryLevelViewH * 0.125
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
