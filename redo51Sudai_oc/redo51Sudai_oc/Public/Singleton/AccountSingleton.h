//
//  AccountSingleton.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

//把单例方法定义为宏，使用起来更方便
#define Account_Singleton [AccountSingleton shareInstance]

@interface AccountSingleton : NSObject

@property (nonatomic, copy) NSString *userName; //用户名
@property (nonatomic, copy) NSString *userId;   //用户Id
@property(nonatomic,copy) NSString *oauthToken; //用户令牌

+ (AccountSingleton *)shareInstance;

// !!!: √ 保存
- (void)saveUserName:(NSString *)userName UserId:(NSString *)userId;

// !!!: √ 初始化属性
- (void)setupProperty;
// !!!: √ 是否登录
- (BOOL)isLogon;
// !!!: √ 注销
- (void)logout;

@end
