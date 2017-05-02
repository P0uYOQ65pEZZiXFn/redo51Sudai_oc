//
//  UIImage+Color.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

/**
 用颜色创建一张图片
 
 @param color 颜色
 @return image
 */
+ (UIImage *)createImageWithColor:(UIColor *)color;

@end
