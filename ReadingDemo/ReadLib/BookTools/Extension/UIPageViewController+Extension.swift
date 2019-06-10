//
//  UIPageViewController+Extension.swift
//  ReadingDemo
//
//  Created by AoChen on 2019/1/22.
//  Copyright © 2019 An. All rights reserved.
//

/// key
private var IsGestureRecognizerEnabled = "IsGestureRecognizerEnabled"
private var TapIsGestureRecognizerEnabled = "TapIsGestureRecognizerEnabled"

import Foundation

extension UIPageViewController {
    
    /// 手势开关
    var gestureRecognizerEnabled:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? Bool) ?? true
        }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue }
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Tap手势开关
    var tapGestureRecognizerEnabled:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? Bool) ?? true
        }
        
        set{
            
            for ges in gestureRecognizers {
                
                if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                    
                    ges.isEnabled = newValue
                }
            }
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
