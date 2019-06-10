//
//  FReadController.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/21.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

@objc class FReadController: FViewController,FReadMenuDelegate,FCoverControllerDelegate,UIPageViewControllerDelegate,UIPageViewControllerDataSource {

    /// 阅读模型(必传)
    @objc var bookModel:FBookModel!
    /// 开启长按菜单
    @objc var openLongMenu:Bool = true
    /// 阅读菜单UI
    private(set) var readMenu:FReadMenu!
    /// 阅读操作对象
    private(set) var readOperation:FReadOperation!
    /// 翻页控制器 (仿真)
    private(set) var pageViewController:UIPageViewController?
    /// 翻页控制器 (无效果,覆盖,上下)
    private(set) var coverController:FCoverController?
    /// 当前显示的阅读控制器
    private(set) var currentReadViewController:FReadViewController?
    /// 用于区分正反面的值(固定)
    private var TempNumber:NSInteger = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置白色状态栏
        isStatusBarLightContent = true
        // 初始化控制器操作对象
        readOperation = FReadOperation(vc: self)
        // 初始化阅读UI控制对象
        readMenu = FReadMenu.readMenu(vc: self, delegate: self)
        // 初始化控制器
        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
        // 注册 FReadView 手势通知
        FReadView.RegisterNotification(observer: self, selector: #selector(readViewNotification(notification:)))
    }
    
    // MARK: FReadView 手势通知
    
    /// 收到通知
    @objc func readViewNotification(notification:Notification) {
        
        // 获得状态
        let info = notification.userInfo
        // 隐藏菜单
        readMenu.menuSH(isShow: false)
        // 解析状态
        if info != nil && info!.keys.contains(FKey_ReadView_Ges_isOpen) {
            
            let isOpen = info![FKey_ReadView_Ges_isOpen] as! NSNumber
            coverController?.gestureRecognizerEnabled = isOpen.boolValue
            pageViewController?.gestureRecognizerEnabled = isOpen.boolValue
            readMenu.singleTap.isEnabled = isOpen.boolValue
        }
    }
    
    // MARK: -- 创建 PageController
    
    /// 创建效果控制器 传入初始化显示控制器
    func creatPageController(_ displayController:UIViewController?) {
        
        // 清理
        if pageViewController != nil {
            pageViewController?.view.removeFromSuperview()
            pageViewController?.removeFromParent()
            pageViewController = nil
        }
        
        if coverController != nil {
            coverController?.view.removeFromSuperview()
            coverController?.removeFromParent()
            coverController = nil
        }
        
        // 创建
        if FBookConfigure.shared().effectType == FEffectType.simulation.rawValue { // 仿真
            let options = [UIPageViewController.OptionsKey.spineLocation:NSNumber(value: UIPageViewController.SpineLocation.min.rawValue as Int)]
            pageViewController = UIPageViewController(transitionStyle:UIPageViewController.TransitionStyle.pageCurl,navigationOrientation:UIPageViewController.NavigationOrientation.horizontal,options: options)
            pageViewController!.delegate = self
            pageViewController!.dataSource = self
            // 为了翻页背面的颜色使用
            pageViewController!.isDoubleSided = true
            view.insertSubview(pageViewController!.view, at: 0)
            addChild(pageViewController!)
            pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewController.NavigationDirection.forward, animated: false, completion: nil)
        }else{ // 无效果 覆盖 上下
            
            coverController = FCoverController()
            coverController!.delegate = self
            view.insertSubview(coverController!.view, at: 0)
            addChild(coverController!)
            coverController!.setController(displayController)
            if FBookConfigure.shared().effectType == FEffectType.none.rawValue {
                coverController!.openAnimate = false
            }else if FBookConfigure.shared().effectType == FEffectType.upAndDown.rawValue {
                coverController!.openAnimate = false
                coverController!.gestureRecognizerEnabled = false
            }
        }
        // 记录
        currentReadViewController = displayController as? FReadViewController
    }
    
    /// 翻页操作使用 isAbove: true 上一页; false 下一页;
    func setViewController(displayController:UIViewController?, isAbove: Bool, animated: Bool) {
        
        if displayController != nil {
            if pageViewController != nil {
                let direction = isAbove ? UIPageViewController.NavigationDirection.reverse : UIPageViewController.NavigationDirection.forward
                pageViewController?.setViewControllers([displayController!], direction: direction, animated: animated, completion: nil)
                return
            }
            
            if coverController != nil {
                coverController?.setController(displayController!, animated: animated, isAbove: isAbove)
                return
            }
            // 都没有则初始化
            creatPageController(displayController!)
        }
    }
    
    deinit {
        // 移除通知
        FReadView.RemoveNotification(observer: self)
        // 清理
        bookModel = nil
        currentReadViewController = nil
    }
}

// MARK:- FReadMenuDelegate
extension FReadController {
    
    /// 背景颜色
    func readMenuClickSetuptColor(readMenu: FReadMenu, index: NSInteger, color: UIColor) {
        
        FBookConfigure.shared().colorIndex = index
        currentReadViewController?.configureBGColor()
    }
    
    /// 翻书动画
    func readMenuClickSetuptEffect(readMenu: FReadMenu, index: NSInteger) {
        
        FBookConfigure.shared().effectType = index
        creatPageController(readOperation.GetCurrentReadViewController())
    }
    
    /// 字体
    func readMenuClickSetuptFont(readMenu: FReadMenu, index: NSInteger) {
        
        FBookConfigure.shared().fontType = index
        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
    }
    
    /// 字体大小
    func readMenuClickSetuptFontSize(readMenu: FReadMenu, fontSize: CGFloat) {
        
        // FReadConfigure.shared().fontSize = fontSize 内部已赋值
        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: true, isSave: true))
    }
    
    /// 点击书签列表
    func readMenuClickMarkList(readMenu: FReadMenu, bookMarkModel: FBookMarkModel) {
        
        /*
         网络小说操作提示:
         
         1. 判断书签指定章节 是否存在本地缓存文件
         
         2. 存在则继续展示 不存在则请求回来再展示
         */
        
        bookModel.modifyBookRecordModel(bookMarkModel: bookMarkModel, isUpdateFont: true, isSave: false)
        creatPageController(readOperation.GetCurrentReadViewController(isUpdateFont: false, isSave: true))
    }
    
    /// 下载
    func readMenuClickDownload(readMenu: FReadMenu) {
        
        print("点击了下载")
        
        
        
    }
    
    /// 拖拽进度条
    func readMenuSliderEndScroll(readMenu: FReadMenu, slider: ASValueTrackingSlider) {
        
        if bookModel != nil && bookModel.bookRecordModel.isRecord { // 有阅读记录
            let toPage = NSInteger(slider.value)
            if (bookModel.bookRecordModel.page.intValue + 1) != toPage { // 不是同一页
                let _ = readOperation.GoToChapter(chapterID: bookModel.bookRecordModel.bookChapterModel!.id, toPage: toPage - 1)
            }
        }
    }
    
    /// 上一章
    func readMenuClickPreviousChapter(readMenu: FReadMenu) {
        
        if bookModel != nil && bookModel.bookRecordModel.isRecord { // 有阅读记录
            let _ = readOperation.GoToChapter(chapterID: "\(bookModel.bookRecordModel.bookChapterModel!.id.integerValue() - 1)")
        }
    }
    
    /// 下一章
    func readMenuClickNextChapter(readMenu: FReadMenu) {
        
        if bookModel != nil && bookModel.bookRecordModel.isRecord { // 有阅读记录
            let _ = readOperation.GoToChapter(chapterID: "\(bookModel.bookRecordModel.bookChapterModel!.id.integerValue() + 1)")
        }
    }
    
    /// 点击章节列表
    func readMenuClickChapterList(readMenu: FReadMenu, bookBaseChapterModel: FBookBaseChapterModel) {
        
        let _ = readOperation.GoToChapter(chapterID: bookBaseChapterModel.id)
    }
    
    /// 切换日夜间模式
    func readMenuClickLightButton(readMenu: FReadMenu, isDay: Bool) {
        
        // 日夜间需要切换做调整可以打开重置使用
        // creatPageController(readOperation.GetCurrentReadViewController())
    }
    
    /// 状态栏 将要 - 隐藏以及显示状态改变
    func readMenuWillShowOrHidden(readMenu: FReadMenu, isShow: Bool) {
        
        pageViewController?.tapGestureRecognizerEnabled = !isShow
        coverController?.tapGestureRecognizerEnabled = !isShow
        if isShow {
            // 选中章节列表
            readMenu.leftView.topView.selectIndex = 0
            // 检查当前是否存在书签
            readMenu.topView.mark.isSelected = bookModel.checkMark()
        }
    }
    
    /// 点击书签按钮
    func readMenuClickMarkButton(readMenu: FReadMenu, button: UIButton) {
        
        if button.isSelected {
            let _ = bookModel.removeMark()
            button.isSelected = bookModel.checkMark()
        }else{
            bookModel.addMark()
            button.isSelected = true
        }
    }
}

// MARK:- FCoverControllerDelegate
extension FReadController {
    
    /// 切换结果
    func coverController(_ coverController: FCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        // 记录
        currentReadViewController = currentController as? FReadViewController
        // 更新阅读记录
        readOperation.readRecordUpdate(readViewController: currentReadViewController)
        // 更新进度条
        readMenu.bottomView.sliderUpdate()
    }
    
    /// 将要显示的控制器
    func coverController(_ coverController: FCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        readMenu.menuSH(isShow: false)
    }
    
    /// 获取上一个控制器
    func coverController(_ coverController: FCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return readOperation.GetAboveReadViewController()
    }
    
    /// 获取下一个控制器
    func coverController(_ coverController: FCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        return readOperation.GetBelowReadViewController()
    }
}

// MARK:- UIPageViewControllerDelegate,UIPageViewControllerDataSource
extension FReadController {
    
    /// UIPageViewControllerDelegate
    /// 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            // 记录
            currentReadViewController = previousViewControllers.first as? FReadViewController
            // 更新阅读记录
            readOperation.readRecordUpdate(readViewController: currentReadViewController)
        }else{
            // 记录
            currentReadViewController = pageViewController.viewControllers?.first as? FReadViewController
            // 更新阅读记录
            readOperation.readRecordUpdate(readViewController: currentReadViewController)
            // 更新进度条
            readMenu.bottomView.sliderUpdate()
        }
    }
    
    /// 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        readMenu.menuSH(isShow: false)
        // 更新阅读记录
        readOperation.readRecordUpdate(readViewController: pageViewController.viewControllers?.first as? FReadViewController, isSave: false)
    }
    
    
    /// UIPageViewControllerDataSource
    /// 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        TempNumber -= 1
        if abs(TempNumber) % 2 == 0 { // 背面
            let vc = FReadBGViewController()
            vc.targetView = readOperation.GetAboveReadViewController()?.view
            return vc
        }else{ // 内容
            return readOperation.GetAboveReadViewController()
        }
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        TempNumber += 1
        if abs(TempNumber) % 2 == 0 { // 背面
            let vc = FReadBGViewController()
            vc.targetView = readOperation.GetCurrentReadViewController()?.view
            return vc
        }else{ // 内容
            return readOperation.GetBelowReadViewController()
        }
    }
}
