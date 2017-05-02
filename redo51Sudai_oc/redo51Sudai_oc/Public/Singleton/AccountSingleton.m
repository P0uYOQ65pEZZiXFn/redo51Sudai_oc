//
//  AccountSingleton.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/2.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "AccountSingleton.h"

@implementation AccountSingleton

//创建一个静态的指针
static AccountSingleton * share = nil;
+ (AccountSingleton *)shareInstance {
    //如果对象为空
    if(!share) {
        //创建对象
        share = [[AccountSingleton alloc] init];
    }
    //返回当前对象
    return  share;
}

// !!!: √ 初始化属性
- (void)setupProperty {
    self.userName = USER_DEFAULTS_GET(UserDefaults_userName);
    self.userId   = USER_DEFAULTS_GET(UserDefaults_userId);
}

// !!!: √ 保存
- (void)saveUserName:(NSString *)userName UserId:(NSString *)userId {
    USER_DEFAULTS_SET(UserDefaults_userName, userName);
    USER_DEFAULTS_SET(UserDefaults_userId, userId);
    self.userName = userName;
    self.userId   = userId;
}

// !!!: √ 是否登录
- (BOOL)isLogon {
    if ([self.userName isEqualToString:@""] || self.userName == nil ||self.userName.length == 0) {
        return NO;
    }
    else  return YES;
}

// !!!: √ 注销登录
- (void)logout {
    self.userName = nil;
    self.userId = nil;
    USER_DEFAULTS_REMOVE(UserDefaults_userName);
    USER_DEFAULTS_REMOVE(UserDefaults_userId);
}

@end
