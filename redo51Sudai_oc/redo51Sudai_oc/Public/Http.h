//
//  Http.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 2017/5/25.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModle : NSObject

@property (nonatomic, assign) NSInteger res_code;
@property (nonatomic, copy) NSString *res_msg;
@property (nonatomic, strong) NSDictionary *res_data;

- (instancetype)init:(NSDictionary *)dic;

@end

@interface Http : NSObject

+ (void)get:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success failure:(void(^)(NSString *failure))failure;

+ (void)get:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success;

+ (void)post:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success failure:(void(^)(NSString *failure))failure;

+ (void)post:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success;

@end
