//
//  FCommonTool.h
//  Demo
//
//  Created by AoChen on 2019/1/23.
//  Copyright © 2019 An. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCommonTool : NSObject

//MARK: - --- 中文数字转阿拉伯数字（方法一）
+ (NSInteger )chineseNumbersReturnArabicNumerals:(NSString *)chnStr;

///MARK: - --- 文字处理
/*
 + (NSString *)wordsDeal:(NSString *)str;
 */

///MAKR: - --- 文字提取匹配
+ (NSString *)textMatching:(NSString *)str;

//MARK: - --- 中文数字转阿拉伯数字（方法二）
+(NSInteger)elseFun:(NSString *)chnStr;

/**
阿拉伯数字转中文数字

 @param arabicNum 阿拉伯数字
 @return 中文数字字符串
 */
+ (NSString *)chineseFromeArabicNum:(NSInteger)arabicNum;

/**
 获取数字的科学计数法

 @param d 转换的数字
 @param n 保留的有效数字
 @return 科学计数法字符
 */
+ (NSString *)scientificCounting:(double)d rms:(NSInteger)n;

@end
