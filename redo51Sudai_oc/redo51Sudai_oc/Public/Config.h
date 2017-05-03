//
//  Config.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

// xml----sax解析
@interface Config : NSObject

// !!!: √ 把单例方法定义为宏，使用起来更方便
#define Config_Singleton [Config shareInstance]

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *serverUrl;

+ (Config *)shareInstance;

@end

// ------sax 解析的服务器类型
@interface ServerMode : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *serverUrl;

@property (nonatomic, copy) NSString *imageUrl;

@end


// xml-------dom解析  TBXML

@interface Config_Dom : NSObject

// !!!: √ 把单例方法定义为宏，使用起来更方便
#define Config_Dom_Singleton [Config_Dom shareInstance]

@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSString *serverUrl;

+ (Config_Dom *)shareInstance;

@end
