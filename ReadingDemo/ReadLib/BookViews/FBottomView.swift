//
//  FBottomView.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FBottomView: FBaseView,ASValueTrackingSliderDelegate {

    /// 上一章
    private(set) var previousChapter:UIButton!
    
    /// 下一章
    private(set) var nextChapter:UIButton!
    
    /// 进度
    private(set) var slider:ASValueTrackingSlider!
    
    /// 功能按钮数组
    private(set) var funcIcons:[String] = ["read_bar_0","read_bar_1","read_bar_2","read_bar_3"]
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 创建按钮
        for i in 0 ..< funcIcons.count {
            
            let button = UIButton(type:.custom)
            button.setImage(UIImage(named: funcIcons[i]), for: UIControl.State())
            button.tag = i
            button.addTarget(self, action: #selector(clickButton(_:)), for: UIControl.Event.touchUpInside)
            addSubview(button)
        }
        
        // 上一章
        previousChapter = UIButton(type:.custom)
        previousChapter.titleLabel?.font = FFont_12
        previousChapter.contentHorizontalAlignment = .right
        previousChapter.setTitle("上一章", for: .normal)
        previousChapter.setTitleColor(UIColor.white, for: .normal)
        previousChapter.addTarget(self, action: #selector(clickPreviousChapter), for: .touchUpInside)
        addSubview(previousChapter)
        
        // 下一章
        nextChapter = UIButton(type:.custom)
        nextChapter.titleLabel?.font = FFont_12
        nextChapter.contentHorizontalAlignment = .left
        nextChapter.setTitle("下一章", for: .normal)
        nextChapter.setTitleColor(UIColor.white, for: .normal)
        nextChapter.addTarget(self, action: #selector(clickNextChapter), for: .touchUpInside)
        addSubview(nextChapter)
        
        // 进度条
        slider = ASValueTrackingSlider()
        slider.delegate = self
        slider.setThumbImage(UIImage(named:"RM_3"), for: .normal)
        slider.minimumValue = 1
        slider.maximumValue = 1
        slider.setMaxFractionDigitsDisplayed(0)
        slider.popUpViewColor = FColor_2
        slider.font = UIFont(name: "Futura-CondensedExtraBold", size: 22)
        slider.textColor = UIColor.white
        slider.popUpViewArrowLength = FSpace_4
        addSubview(slider)
    }
    
    /// 刷新 slider
    func sliderUpdate() {
        
        if readMenu.vc.bookModel != nil && readMenu.vc.bookModel.bookRecordModel.isRecord {
            
            slider.maximumValue = Float(readMenu.vc.bookModel.bookRecordModel.bookChapterModel!.pageCount.intValue)
            
            slider.value = Float(readMenu.vc.bookModel.bookRecordModel.page.intValue + 1)
        }
    }
    
    /// 点击按钮
    @objc func clickButton(_ button:UIButton) {
        
        let index = button.tag
        
        if index == 0 { // 目录
            
            clickCatalog()
            
        }else if index == 1 { // 亮度
            
            clickLight()
            
        }else if index == 2 { // 设置
            
            clickSetup()
            
        }else{ // 下载
            
            clickDowload()
        }
    }
    
    /// 上一章
    @objc func clickPreviousChapter() {
        
        readMenu.delegate?.readMenuClickPreviousChapter?(readMenu: readMenu)
    }
    
    /// 下一章
    @objc func clickNextChapter() {
        
        readMenu.delegate?.readMenuClickNextChapter?(readMenu: readMenu)
    }
    
    /// 目录
    func clickCatalog() {
        
        readMenu.menuSH(isShow: false)
        
        readMenu.leftView(isShow: true, complete: nil)
    }
    
    /// 亮度
    func clickLight() {
        
        readMenu.bottomView(isShow: false) { [weak self] ()->Void in
            
            self?.readMenu.lightView(isShow: true, complete: nil)
        }
        
        readMenu.publicButtonBottomY(view: readMenu.lightView)
    }
    
    /// 设置
    func clickSetup() {
        
        readMenu.publicButton(isShow: false, complete: nil)
        
        readMenu.bottomView(isShow: false) { [weak self] ()->Void in
            
            self?.readMenu.novelsSettingView(isShow: true , complete: nil)
        }
    }
    
    /// 下载
    func clickDowload() {
        
        readMenu.delegate?.readMenuClickDownload?(readMenu: readMenu)
    }
    
    // MARK: -- ASValueTrackingSliderDelegate
    
    func sliderWillHidePopUpView(_ slider: ASValueTrackingSlider!) {
        
        readMenu.delegate?.readMenuSliderEndScroll?(readMenu: readMenu, slider: slider)
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 上一章
        previousChapter.frame = CGRect(x: 0, y: FSpace_4, width: 55, height: 32)
        
        // 下一章
        nextChapter.frame = CGRect(x: width - previousChapter.width, y: FSpace_4, width: previousChapter.width, height: previousChapter.height)
        
        // 进度条
        let sliderX = previousChapter.frame.maxX + FSpace_4
        let sliderW:CGFloat = width - 2 * sliderX
        slider.frame = CGRect(x: sliderX, y: FSpace_4, width: sliderW, height: previousChapter.height)
        
        // 按钮布局
        let count = funcIcons.count
        let buttonY:CGFloat = previousChapter.frame.maxY
        let buttonH:CGFloat = height - buttonY
        let buttonW:CGFloat =  width / CGFloat(count)
        for i in 0..<count {
            let button = subviews[i]
            button.frame = CGRect(x: CGFloat(i) * buttonW, y: buttonY, width: buttonW, height: buttonH)
        }
    }

}
