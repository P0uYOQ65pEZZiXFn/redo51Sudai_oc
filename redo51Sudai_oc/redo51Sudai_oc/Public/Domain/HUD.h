//
//  HUD.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HUD : NSObject

//成功
+ (void)showSuccess:(NSString *)string;

//成功有vc
+ (void)showSuccess:(NSString *)string VC:(UIViewController *)vc;

//失败
+ (void)showError:(NSString *)string;

//失败有vc
+ (void)showError:(NSString *)string VC:(UIViewController *)vc;

//文字
+ (void)showMessage:(NSString *)string;

//文字有vc
+ (void)showMessage:(NSString *)string VC:(UIViewController *)vc;

//有转圈的文字
+ (void)showHUD:(NSString *)string;

//转圈有vc
+ (void)showHUD:(NSString *)string VC:(UIViewController *)vc;

//转圈的有隐藏方法
+ (void)hiddenHUD;

//隐藏有vc
+ (void)hiddenHUD:(UIViewController *)vc;

@end
