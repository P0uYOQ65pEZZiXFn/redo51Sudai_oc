//
//  Domain.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "Domain.h"
#import "CommonCrypto/CommonDigest.h"

@implementation Domain

/**
 获取保存在本地的token，如果本地token为空  跳到登录界面
 
 @return token token为空跳转到获取token的界面
 */
+ (id)getToken {
    NSUserDefaults *userDefaluts = [NSUserDefaults standardUserDefaults];
    NSString *token = [userDefaluts objectForKey:@"token"];
    if (token == nil || [token isEqualToString:@""]) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        [UIApplication sharedApplication].keyWindow.rootViewController = [sb instantiateViewControllerWithIdentifier:@"LoginID"];
        return nil;
    }
    else
        return token;
}

//获取当前时间戳
+ (NSString *)currentTimeStamp {
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];
    // 时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}

+ (NSString *)sginaWithTimeStamp:(NSString*)timeStamp {
    NSString * tmpStr = [NSString stringWithFormat:@"%@%@", appSecret,timeStamp];
    tmpStr = [self md5WithString:tmpStr];
    tmpStr = [tmpStr stringByAppendingString:appKey];
    
    tmpStr = [self md5WithString:tmpStr];
    tmpStr = [tmpStr uppercaseString];//将所有小写字母转成大写
    
    return tmpStr;
}

//MD5加密
+ (NSString *)md5WithString:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}


/**
 把格式化的JSON格式的字符串转换成字典
 
 @param jsonString JSON格式的字符串
 @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil)
        return nil;
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"JSON格式的字符串转换成字典 - json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 字符串utf-8 编码
 
 @param olstring 原来字符串
 @return utf-8 编码字符串
 */
+ (NSString *)UTFWithString:(NSString *)olstring {
    NSString *string = [NSString stringWithFormat:@"%@",olstring];
    NSString * encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return encodedString;
}

/**
 lable显示不同的颜色
 
 @param beforeColor 前面字符串的颜色
 @param label UILabel
 @param allString label的字符串
 @param spacingString 前后分开的字符串
 */
+ (void)labelChangeColor:(UIColor *)beforeColor Andlabel:(UILabel *)label andAllString:(NSString *)allString andSpacString:(NSString *)spacingString {
    NSMutableAttributedString *mutableString = [[NSMutableAttributedString alloc] initWithString:allString];
    NSRange range = NSMakeRange(0, [[mutableString string] rangeOfString:spacingString].location + spacingString.length);
    [mutableString addAttribute:NSForegroundColorAttributeName value:beforeColor range:range];
    [label setAttributedText:mutableString];
}

/**
 根据文字内容计算所占位置大小
 
 @param string 字符串
 @param font 文字大小
 @return 所占位置大小
 */
+ (CGSize)word_Size:(NSString *)string andFont:(UIFont *)font {
    //先设置属性
    NSMutableParagraphStyle *paragStyle = [[NSMutableParagraphStyle alloc]init];
    paragStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragStyle.copy};
    //新方法
    CGSize size = [string boundingRectWithSize:CGSizeMake(ZWIN_WIDTH - 20, 200.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    return size;
}

/**
 alertView 提示框
 
 @param vc 提示框添加咋哪里显示
 @param title title字符串
 @param message 提示message字符串
 @param isCancel YES 确认和取消   NO 只有确认
 */
- (void)showAlertSystem:(UIViewController *)vc andTitle:(NSString *)title andMessage:(NSString *)message andIsCancel:(BOOL)isCancel {
    dispatch_queue_t myQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(myQueue, ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.delegate clickAlertViewButoonIndex:0];
        }];
        if (isCancel) {
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.delegate clickAlertViewButoonIndex:1];
            }];
            [alertController addAction:cancel];
        }
        [alertController addAction:sure];
        dispatch_async(dispatch_get_main_queue(), ^{
            [vc presentViewController:alertController animated:YES completion:nil];
        });
    });
}

@end


@implementation ConvertUtil


// 转换String
+ (NSString *)toString:(id)obj {
    if (obj != nil) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj stringValue];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",obj];
        }
    }
    return @"";
}

+ (NSInteger)toInt:(id)obj {
    if (obj != nil) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj integerValue];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            if ([obj stringValue].length == 0) {
                return 0;
            }
        }
        return (NSInteger)[obj stringValue];
    }
    return 0;
}

+ (CGFloat)toFloat:(id)obj {
    CGFloat tmp = 0.0;
    if (obj != nil) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            return [obj floatValue];
        }
        else if ([obj isKindOfClass:[NSString class]]) {
            NSString *string = [NSString stringWithFormat:@"%@",obj];
            return [string floatValue];
        }
    }
    return tmp;
}

@end
