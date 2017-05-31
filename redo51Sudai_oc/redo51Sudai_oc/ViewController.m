//
//  ViewController.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "ViewController.h"
#import "Config.h"
#import "Http.h"
#import "ADView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 根据网络请求，设置启动广告
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    NSString *widthHeightString = [NSString stringWithFormat:@"%.0f-%.0f",ZWIN_WIDTH * scale_screen, ZWIN_HEIGHT * scale_screen];
    NSDictionary *dic = @{@"resolution" : widthHeightString};
    [Http get:ADUrl params:dic isHud:YES success:^(NSDictionary *data) {
        NSArray *arr = data[@"urlList"];
        if (arr.count != 0) {
            NSString *urlString = arr[0];
            [ADView createAdView:urlString isUrl:YES];
        }
        
    } failure:^(NSString *failure) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
