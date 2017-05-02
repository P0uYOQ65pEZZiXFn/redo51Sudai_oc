//
//  ClearNavigationViewController.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClearNavigationViewController : UIViewController

//返回按钮触发事件
@property (nonatomic, copy) void (^back_action)();

@end
