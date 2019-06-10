//
//  FStatusView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FStatusView: FBaseView {

    /// 电池
    private(set) var batteryView:FBatteryView!
    
    /// 时间
    private(set) var timeLabel:UILabel!
    
    /// 标题
    private(set) var titleLabel:UILabel!
    
    /// 计时器
    private(set) var timer:Timer?
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 背景颜色
        backgroundColor = FColor_1.withAlphaComponent(0.4)
        
        // 电池
        batteryView = FBatteryView()
        batteryView.tintColor = FColor_3
        addSubview(batteryView)
        
        // 时间
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = FFont_12
        timeLabel.textColor = FColor_3
        addSubview(timeLabel)
        
        // 标题
        titleLabel = UILabel()
        titleLabel.font = FFont_12
        titleLabel.textColor = FColor_3
        addSubview(titleLabel)
        
        // 初始化调用
        didChangeTime()
        
        // 添加定时器
        addTimer()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 适配间距
        let space = isX ? FSpace_1 : 0
        
        // 电池
        batteryView.origin = CGPoint(x: width - FBatterySize.width - space, y: (height - FBatterySize.height)/2)
        
        // 时间
        let timeLabelW:CGFloat = FSizeW(50)
        timeLabel.frame = CGRect(x: batteryView.frame.minX - timeLabelW, y: 0, width: timeLabelW, height: height)
        
        // 标题
        titleLabel.frame = CGRect(x: space, y: 0, width: timeLabel.frame.minX - space, height: height)
    }
    
    // MARK: -- 时间相关
    
    /// 添加定时器
    func addTimer() {
        
        if timer == nil {
            
            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(didChangeTime), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
        }
    }
    
    /// 删除定时器
    func removeTimer() {
        
        if timer != nil {
            
            timer!.invalidate()
            
            timer = nil
        }
    }
    
    /// 时间变化
    @objc func didChangeTime() {
        
        timeLabel.text = GetCurrentTimerString(dateFormat: "HH:mm")
        
        batteryView.batteryLevel = UIDevice.current.batteryLevel
    }
    
    /// 销毁
    deinit {
        
        removeTimer()
    }

}
