//
//  FLightView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FLightView: FBaseView {

    /// 标题
    private(set) var titleLabel:UILabel!
    
    /// 进度条
    private(set) var slider:UISlider!
    
    /// 类型
    private(set) var typeLabel:UILabel!
    
    override func addSubviews() {
        
        super.addSubviews()
        
        titleLabel = UILabel()
        titleLabel.text = "亮度"
        titleLabel.textAlignment = .right
        titleLabel.textColor = UIColor.white
        titleLabel.font = FFont_12
        addSubview(titleLabel)
        
        typeLabel = UILabel()
        typeLabel.text = "系统"
        typeLabel.layer.cornerRadius = 3
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.black
        typeLabel.backgroundColor = UIColor.white
        typeLabel.font = FFont_10
        addSubview(typeLabel)
        
        // 进度条
        slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.tintColor = FColor_2
        slider.setThumbImage(UIImage(named: "RM_3")!, for: .normal)
        slider.addTarget(self, action: #selector(FLightView.sliderChanged(_:)), for: UIControl.Event.valueChanged)
        slider.value = Float(UIScreen.main.brightness)
        addSubview(slider)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 标题
        titleLabel.frame = CGRect(x: 0, y: 0, width: 45, height: height)
        
        // 类型
        let typeLabelW:CGFloat = 32
        let typeLabelH:CGFloat = 16
        typeLabel.frame = CGRect(x: width - typeLabelW - FSpace_1, y: (height - typeLabelH) / 2, width: typeLabelW, height: typeLabelH)
        
        // 进度条
        let sliderX = titleLabel.frame.maxX + FSpace_1
        let sliderW = typeLabel.frame.minX - FSpace_1 - sliderX
        slider.frame = CGRect(x: sliderX, y: 0, width: sliderW, height: height)
    }
    
    /// 滑动方法
    @objc private func sliderChanged(_ slider:UISlider) {
        
        UIScreen.main.brightness = CGFloat(slider.value)
    }
}
