//
//  ADView.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 2017/5/26.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "ADView.h"

@implementation ADView

/**
 !!!: √ 创建广告View
 */
+ (void)createAdView:(NSString *)imageName isUrl:(BOOL)isUrl {
    UIImageView *adImageView = [[UIImageView alloc]init];
    adImageView.tag = 1026;
    adImageView.frame = CGRectMake(0, 0, ZWIN_WIDTH, ZWIN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:adImageView];
    if (isUrl) {
        NSURL *url = [NSURL URLWithString:imageName];
        [adImageView sd_setImageWithURL:url];
    }
    else {
        adImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]];
    }
    // !!!: √ 进入按钮
    UIButton *enterButton = [[UIButton alloc]init];
    enterButton.frame = CGRectMake(ZWIN_WIDTH - 90, 30, 60, 60);
    enterButton.backgroundColor = [UIColor clearColor];
    [enterButton setTitle:@"3秒" forState:UIControlStateNormal];
    [enterButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enter_action) forControlEvents:UIControlEventTouchUpInside];
    [self timeout_action:enterButton];
    adImageView.userInteractionEnabled = YES;
    [adImageView addSubview:enterButton];
    
    // !!!: √ 按钮边框圆圈动画消失
    UIBezierPath *totalPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(enterButton.frame.size.width * 0.5, enterButton.frame.size.height * 0.5) radius:enterButton.frame.size.width * 0.5 - 5 startAngle:M_PI_2 * 3 endAngle:- M_PI_2 clockwise:NO];
    CAShapeLayer *totalLayer = [CAShapeLayer layer];
    totalLayer.lineWidth = 1.5;
    totalLayer.fillColor = [UIColor clearColor].CGColor;
    totalLayer.strokeColor = [UIColor blackColor].CGColor;
    totalLayer.path = totalPath.CGPath;
    [enterButton.layer addSublayer:totalLayer];
    
    // !!!: √ 动画时间到了不用进入   倒计时到了也进入
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 3.0;
    [totalLayer addAnimation:animation forKey:@"Test"];
}

// !!!: √ 广告完进入或者点击进入 实际上是将ImageView从父试图去掉
+ (void)enter_action {
    UIImageView *adImageView = [[UIApplication sharedApplication].keyWindow viewWithTag:1026];
    [UIView animateWithDuration:1 animations:^{
        adImageView.frame = CGRectMake(- adImageView.frame.size.width / 2, - adImageView.frame.size.height / 2, adImageView.frame.size.width * 2, adImageView.frame.size.height * 2);
        adImageView.alpha = 0;
        for (NSInteger i = 0; i < adImageView.subviews.count; i++) {
            [adImageView.subviews[i] removeFromSuperview];
        }
    }completion:^(BOOL finished) {
        [adImageView removeFromSuperview];
    }];
}

// !!!: √ 5秒倒计时
+ (void)timeout_action:(UIButton *)sender {
    __block int timeout = 3; // !!!: √ 倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) {
            // !!!: √ 倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // !!!: √ 设置界面的按钮显示 根据自己需求设置
                [self enter_action];
            });
        }
        else {
            int seconds = timeout % 4;
            NSString *strTime = [NSString stringWithFormat:@"%d秒", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // !!!: √ 设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                sender.titleLabel.text = strTime;
                [sender setTitle:[NSString stringWithFormat:@"%@",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


@end

