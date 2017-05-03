//
//  HUD.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "HUD.h"

#define ViewTag 1024
#define LabelTag 2048

@implementation HUD

//成功
+ (void)showSuccess:(NSString *)string {
    [self clearRepeat:string imageString:@"success" isIndicator:NO VC:nil];
}

//成功有vc
+ (void)showSuccess:(NSString *)string VC:(UIViewController *)vc {
    [self clearRepeat:string imageString:@"success" isIndicator:NO VC:vc];
}

//失败
+ (void)showError:(NSString *)string {
    [self clearRepeat:string imageString:@"error" isIndicator:NO VC:nil];
}

//失败有vc
+ (void)showError:(NSString *)string VC:(UIViewController *)vc {
    [self clearRepeat:string imageString:@"error" isIndicator:NO VC:vc];
}

//文字
+ (void)showMessage:(NSString *)string {
    [self clearRepeat:string imageString:@"" isIndicator:NO VC:nil];
}

//文字有vc
+ (void)showMessage:(NSString *)string VC:(UIViewController *)vc {
    [self clearRepeat:string imageString:@"" isIndicator:NO VC:vc];
}

//有转圈的文字
+ (void)showHUD:(NSString *)string {
    [self clearRepeat:string imageString:@"" isIndicator:YES VC:nil];
}

//转圈有vc
+ (void)showHUD:(NSString *)string VC:(UIViewController *)vc {
    [self clearRepeat:string imageString:@"" isIndicator:YES VC:vc];
}

//转圈的有隐藏方法
+ (void)hiddenHUD {
    UIView *view = [self whatView:nil];
    [self dismiss:view time:0];
}

//隐藏有vc
+ (void)hiddenHUD:(UIViewController *)vc {
    UIView *view = [self whatView:vc];
    [self dismiss:view time:0];
}

// MARK: 设置位置
+ (void)clearRepeat:(NSString *)string imageString:(NSString *)imageString isIndicator:(BOOL)isIndicator VC:(UIViewController *)vc {
    UIView *view = [self whatView:vc];
    UILabel *oldLabel = [view viewWithTag:LabelTag];
    if (oldLabel) {
        if (![oldLabel.text isEqualToString:string]) {
            [view removeFromSuperview];
            view = [self create:string imageString:imageString isIndicator:isIndicator];
        }
    }
    else {
        [view removeFromSuperview];
        view = [self create:string imageString:imageString isIndicator:isIndicator];
    }
    [self adjustPosition:view VC:vc];
}

// MARK: 调整位置
+ (void)adjustPosition:(UIView *)view VC:(UIViewController *)vc {
    CGRect rect = view.frame;
    rect.origin.x = (ZWIN_WIDTH - rect.size.width) / 2;
    rect.origin.y = (ZWIN_HEIGHT - rect.size.height) / 2;
    view.frame = rect;
    if (vc == nil)
        [[[UIApplication sharedApplication].windows lastObject] addSubview:view];
    else
        [vc.view addSubview:view];
}

// MARK: 创建提示框
+ (UIView *)create:(NSString *)string imageString:(NSString *)imageString isIndicator:(BOOL)isIndicator {
    UIView *view = [self createGaryView];
    //文字大小
    UIFont *font = [UIFont boldSystemFontOfSize:16];
    CGSize size = [Domain word_Size:string andFont:font];
    CGFloat width = 0;
    if (size.width <= 60) width = 90;
    else width = size.width + 30;
    CGFloat height = 0;
    if (isIndicator)
        height = 90;
    else {
        if ([imageString isEqualToString:@""]) height = size.height + 25;
        else height = 90;
    }
    view.frame = CGRectMake(0, 0, width, height);
    // label
    UILabel *label = [self createLabel:string font:font];
    if (isIndicator) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = CGRectMake((view.frame.size.width - 37) / 2, 15, 37, 37);
        CGAffineTransform transform = CGAffineTransformMakeScale(0.7, 0.7);
        indicator.transform = transform;
        [indicator startAnimating];
        [view addSubview:indicator];
        label.frame = CGRectMake(0, view.frame.size.height - size.height - 15, view.frame.size.width, size.height);
    }
    else {
        if ([imageString isEqualToString:@""])
            label.frame = view.bounds;
        else {
            UIImageView *iv = [[UIImageView alloc]init];
            iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageString]];
            iv.frame = CGRectMake((view.frame.size.width - 28) / 2, 15, 28, 28);
            [view addSubview:iv];
            label.frame = CGRectMake(0, view.frame.size.height - size.height - 15, view.frame.size.width, size.height);
        }
    }
    [view addSubview:label];
    if (!isIndicator)
        [self dismiss:view time:2];
    return view;
}

// MARK: 创建灰色view
+ (UIView *)createGaryView {
    UIView *garyView = [[UIView alloc]init];
    garyView.tag = ViewTag;
    garyView.backgroundColor = ZRGB_COLOR_NOA(99, 99, 99);
    garyView.layer.cornerRadius = 7;
    garyView.clipsToBounds = YES;
    return garyView;
}

// MARK: 创建label
+ (UILabel *)createLabel:(NSString *)string font:(UIFont *)font {
    UILabel *label = [[UILabel alloc]init];
    label.font = font;
    label.text = [NSString stringWithFormat:@"%@",string];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.tag = LabelTag;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

// MARK: 动画消失
+ (void)dismiss:(UIView *)view time:(CGFloat)time {
    //设置延时效果
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        //两秒慢慢消失
        [UIView animateWithDuration:2.f animations:^{
            view.alpha = 0.f;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
    });//这句话的意思是1.5秒后，执行消失操作
}

// MARK: 判断view 加在哪里
+ (UIView *)whatView:(UIViewController *)vc {
    UIView *view = nil;
    if (vc == nil )
        view = [[[UIApplication sharedApplication].windows lastObject] viewWithTag:ViewTag];
    else
        view = [vc.view viewWithTag:ViewTag];
    return view;
}

@end
