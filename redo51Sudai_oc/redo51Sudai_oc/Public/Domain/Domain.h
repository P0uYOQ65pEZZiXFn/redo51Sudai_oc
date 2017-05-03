//
//  Domain.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol AlertDelegate <NSObject>

//点击AlertView确认按钮
- (void)clickAlertViewButoonIndex:(NSInteger)index;

@end

@interface Domain : NSObject

@property (nonatomic, weak) id<AlertDelegate> delegate;


/**
 获取保存在本地的token，如果本地token为空  token为空跳转到获取token的界面（跳到登录界面）
 
 @return token
 */
+ (id)getToken;

/**
 把格式化的JSON格式的字符串转换成字典
 
 @param jsonString JSON格式的字符串
 @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 字符串utf-8 编码
 
 @param olstring 原来字符串
 @return utf-8 编码字符串
 */
+ (NSString *)UTFWithString:(NSString *)olstring;

/**
 lable显示不同的颜色
 
 @param beforeColor 前面字符串的颜色
 @param label UILabel
 @param allString label的字符串
 @param spacingString 前后分开的字符串
 */
+ (void)labelChangeColor:(UIColor *)beforeColor Andlabel:(UILabel *)label andAllString:(NSString *)allString andSpacString:(NSString *)spacingString;

/**
 根据文字内容计算所占位置大小
 
 @param string 字符串
 @param font 文字大小
 @return 所占位置大小
 */
+ (CGSize)word_Size:(NSString *)string andFont:(UIFont *)font;


/**
 alertView 提示框
 
 @param vc 提示框添加咋哪里显示
 @param title title字符串
 @param message 提示message字符串
 @param isCancel YES 确认和取消   NO 只有确认
 */
- (void)showAlertSystem:(UIViewController *)vc andTitle:(NSString *)title andMessage:(NSString *)message andIsCancel:(BOOL)isCancel;

@end
