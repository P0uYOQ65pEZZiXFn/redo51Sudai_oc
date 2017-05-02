//
//  UIColor+hexadecimal_16.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (hexadecimal_16)

/**
 16进制颜色 透明度为1
 
 @param string 16进制字符串
 @return 颜色
 */
+ (UIColor*)colorWith16String:(NSString *)string;

/**
 16进制颜色 透明度为自定义
 
 @param string 16进制字符串
 @param alpha 透明度
 @return 颜色
 */
+ (UIColor*)colorWith16String:(NSString *)string alpha:(float)alpha;

@end
