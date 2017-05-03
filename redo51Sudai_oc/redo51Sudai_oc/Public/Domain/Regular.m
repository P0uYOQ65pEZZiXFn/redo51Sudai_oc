//
//  Regular.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "Regular.h"

@implementation Regular

// MARK: 汉字的正则表达式
+ (BOOL)isWordReg:(NSString *)string {
    NSString *regex = @"^[\u4e00-\u9fa5]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL match = [pred evaluateWithObject:string];
    return match;
}

@end
