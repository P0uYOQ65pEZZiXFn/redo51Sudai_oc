//
//  Http.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 2017/5/25.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "Http.h"
#import "Reachability.h"
#import "AFHTTPSessionManager.h"
#import "AccountSingleton.h"

@implementation BaseModle

- (instancetype)init:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.res_code = [[dic objectForKey:@"res_code"] integerValue];
        self.res_msg  = [dic objectForKey:@"res_msg"];
        self.res_data = [dic objectForKey:@"res_data"];
    }
    return self;
}

@end

@implementation Http

+ (void)get:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success failure:(void(^)(NSString *failure))failure; {
    if (isHud)
        [HUD showHUD:@"加载中..."];
    if (![self isNetworkConnect]) {
        [HUD showError:@"网络未连接"];
        return;
    }
    // 请求管理者
    AFHTTPSessionManager *manager = [self getManager];
    path = [self setFinalUrl:path];
    NSDictionary *dic = [self setFinalParams:params];
    [manager GET:path parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModle *baseModle = [self successForData:responseObject path:path params:dic isPost:NO];
        if (baseModle.res_code == 9999)
            //成功
            success(baseModle.res_data);
        else
            failure(baseModle.res_msg);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络失败
        NSString *message = [self failureForError:error];
        failure(message);
        NSLog(@"请求错误%@",path);
    }];
}

+ (void)get:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success {
    if (isHud)
        [HUD showHUD:@"加载中..."];
    if (![self isNetworkConnect]) {
        [HUD showError:@"网络未连接"];
        return;
    }
    // 请求管理者
    AFHTTPSessionManager *manager = [self getManager];
    path = [self setFinalUrl:path];
    NSDictionary *dic = [self setFinalParams:params];
    [manager GET:path parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModle *baseModle = [self successForData:responseObject path:path params:dic isPost:NO];
        if (baseModle.res_code == 9999)
            //成功
            success(baseModle.res_data);
        else
            [HUD showError:baseModle.res_msg];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络失败
        NSString *message = [self failureForError:error];
        [HUD showError:message];
        NSLog(@"请求错误%@",path);
    }];
}

+ (void)post:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success failure:(void(^)(NSString *failure))failure {
    if (isHud)
        [HUD showHUD:@"加载中..."];
    if (![self isNetworkConnect]) {
        [HUD showError:@"网络未连接"];
        return;
    }
    // 请求管理者
    AFHTTPSessionManager *manager = [self getManager];
    path = [self setFinalUrl:path];
    NSDictionary *dic = [self setFinalParams:params];
    [manager POST:path parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModle *baseModle = [self successForData:responseObject path:path params:dic isPost:YES];
        if (baseModle.res_code == 9999)
            //成功
            success(baseModle.res_data);
        else
            failure(baseModle.res_msg);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络失败
        NSString *message = [self failureForError:error];
        failure(message);
        NSLog(@"请求错误%@",path);
    }];
}

+ (void)post:(NSString *)path params:(NSDictionary *)params isHud:(BOOL)isHud success:(void(^)(NSDictionary *data))success {
    if (isHud)
        [HUD showHUD:@"加载中..."];
    if (![self isNetworkConnect]) {
        [HUD showError:@"网络未连接"];
        return;
    }
    // 请求管理者
    AFHTTPSessionManager *manager = [self getManager];
    path = [self setFinalUrl:path];
    NSDictionary *dic = [self setFinalParams:params];
    [manager POST:path parameters:dic progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        BaseModle *baseModle = [self successForData:responseObject path:path params:dic isPost:YES];
        if (baseModle.res_code == 9999)
            //成功
            success(baseModle.res_data);
        else
            [HUD showError:baseModle.res_msg];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //网络失败
        NSString *message = [self failureForError:error];
        [HUD showError:message];
        NSLog(@"请求错误%@",path);
    }];
}

+ (AFHTTPSessionManager *)getManager {
    // 显示手机上加载的标示
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // 请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置超时时间
    [manager.requestSerializer setTimeoutInterval:30];
    return manager;
}

+ (NSString *)setFinalUrl:(NSString *)path {
    if ([path hasPrefix:@"http"])
        path = path;
    else
        path = [NSString stringWithFormat:@"%@%@", [Config_Dom shareInstance].serverUrl, path];
    return path;
}

+ (NSDictionary *)setFinalParams:(NSDictionary *)params {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
    if ([dic objectForKey:@"appkey"] == nil)
        [dic setObject:appKey forKey:@"appkey"];
    NSString *timeStamp = [Domain currentTimeStamp];
    if ([dic objectForKey:@"signa"] == nil)
        [dic setObject:[Domain sginaWithTimeStamp:timeStamp] forKey:@"signa"];
    if ([dic objectForKey:@"ts"] == nil)
        [dic setObject:timeStamp forKey:@"ts"];
    if (Account_Singleton.isLogon) {
        [dic setObject:Account_Singleton.oauthToken forKey:@"oauth_token"];
        [dic setObject:Account_Singleton.userId forKey:@"user_id"];
    }
    return dic;
}

+ (BaseModle *)successForData:(id)responseObject path:(NSString *)path params:(NSDictionary *)params isPost:(BOOL)isPost {
    [HUD hiddenHUD];
    NSLog(@"\n%@->path->%@\nparams->%@\ndata%@",isPost == YES ? @"Post":@"Get", path, params, [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    return [[BaseModle alloc]init:dic];
}

/**
 请求失败返回处理
 
 @param error 错误信息
 @return 错误提示
 */
+ (NSString *)failureForError:(NSError *)error {
    [HUD hiddenHUD];
    NSString *errorString = @"";
    if (error.code == -1011)
        errorString = @"请求服务器出现错误";
    else if (error.code == -1001)
        errorString = @"网络超时，稍后再试";
    else
        errorString = @"您的网络发生异常";
    return errorString;
}

// 网络是否连接
+ (BOOL)isNetworkConnect {
    return ([self isEnable3G] || [self isEnableWIFI]);
}

// wifi
+ (BOOL)isEnableWIFI {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

// 3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
