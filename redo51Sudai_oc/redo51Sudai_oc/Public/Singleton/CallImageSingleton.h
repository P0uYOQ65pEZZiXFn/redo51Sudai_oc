//
//  CallImageSingleton.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

// !!!: √ 把单例方法定义为宏，使用起来更方便
#define CallImage_Singleton [CallImageSingleton shareInstance]

@protocol CallImageDelegate <NSObject>

// !!!: √ delegate 返回图片
- (void)callBackImage:(UIImage *)image;

@end

@interface CallImageSingleton : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) id<CallImageDelegate> delegate;

// !!!: √ 单例
+ (CallImageSingleton *)shareInstance;

// !!!: √ 调用照相机和相片
- (void)showCallImage:(UIViewController *)vc delegate:(id<CallImageDelegate>) aDelegate;

@end
