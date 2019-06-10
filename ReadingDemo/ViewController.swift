//
//  ViewController.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/16.
//  Copyright © 2019 An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 标题
        title = "ReadingDemo"
        
        
        // 跳转
        let button = UIButton(type: .custom)
        button.setTitle("点击阅读", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(read), for: .touchDown)
        view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        
        print("缓存章节的沙河路径: \(DocumentDirectory)")
        
        view.backgroundColor = UIColor.gray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // 跳转
    @objc func read() {
        
        MBProgressHUD.showMessage("本地文件第一次解析慢,以后就会秒进了")
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        FBookParser.ParserLocalURL(url: url!) {(bookModel) in
            
            print(bookModel.bookID,bookModel.bookBaseChapterModels.count)
            
            print(bookModel.bookBaseChapterModels.first!.name)
            
            MBProgressHUD.hide()
            
            let readController = FReadController()
            
            readController.bookModel = bookModel
            /// 是否开启长按内容显示菜单 默认: true
            // readController.openLongMenu = false
            self.navigationController?.pushViewController(readController, animated: true)
            
        }
    }

}

