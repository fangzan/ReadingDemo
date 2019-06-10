//
//  FReadBGViewController.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/22.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class FReadBGViewController: UIViewController {

    /// 目标视图(无值则跟阅读背景颜色保持一致)
    weak var targetView:UIView?
    
    /// imageView
    private(set) var imageView:UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // imageView
        imageView = UIImageView()
        imageView.backgroundColor = FBookConfigure.shared().bookColor()
        imageView.frame = view.bounds
        imageView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
        view.addSubview(imageView)
        
        // 展示图片
        if targetView != nil { imageView.image = ScreenCapture(targetView) }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
