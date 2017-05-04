//
//  Config.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "Config.h"

@interface Config ()<NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableArray *serversArr;

@property (nonatomic, copy) NSString *currentString;

@property (nonatomic, copy) NSString *selectString;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) ServerMode *serverMode;

@end

@implementation Config

static Config *share = nil;

+ (Config *)shareInstance {
    //如果对象为空
    if(!share) {
        //创建对象
        share = [[Config alloc] init];
    }
    //返回当前对象
    return share;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serversArr = [NSMutableArray array];
        NSMutableArray *arr = [self readXml];
        for (NSInteger i = 0; i < arr.count; i++) {
            ServerMode *server = arr[i];
            if ([self.selectString isEqualToString:server.name]) {
                self.imageUrl = server.imageUrl;
                self.serverUrl = server.serverUrl;
            }
        }
    }
    return self;
}

- (NSMutableArray *)readXml {
    NSMutableArray *arr = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"xml"];
    if (path != nil) {
        arr = [self parserPath:path];
    }
    return arr;
}

- (NSMutableArray *)parserPath:(NSString *)path {
    NSData *data = [[NSData alloc]initWithContentsOfFile:path];
    NSXMLParser *xmlParser = [[NSXMLParser alloc]initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    return self.serversArr;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    if ([elementName isEqualToString:@"App"]) {
        self.selectString = attributeDict[@"runtime"];
    }
    if ([elementName isEqualToString:@"runtime"]) {
        self.name = attributeDict[@"name"];
        ServerMode *serverMode = [[ServerMode alloc]init];
        self.serverMode = serverMode;
        self.serverMode.name = self.name;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentString = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"runtime"]) {
        [self.serversArr addObject:self.serverMode];
    }
    if ([elementName isEqualToString:@"serverUrl"]) {
        self.serverMode.serverUrl = self.currentString;
    }
    else if ([elementName isEqualToString:@"imageUrl"]) {
        self.serverMode.imageUrl = self.currentString;
    }
}

@end


@implementation ServerMode

@end

#import "TBXML.h"

@implementation Config_Dom

static Config_Dom *share_d = nil;

+ (Config_Dom *)shareInstance {
    //如果对象为空
    if(!share_d) {
        //创建对象
        share_d = [[Config_Dom alloc] init];
    }
    //返回当前对象
    return share_d;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self readXml];
    }
    return self;
}

- (void)readXml {
    
    //1.得到xml文件的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Config" ofType:@"xml"];
    if (path != nil) {
        //2.NSData
        NSData *data = [NSData dataWithContentsOfFile:path];
        //3.TBXML
        TBXML *tbXML = [TBXML newTBXMLWithXMLData:data error:nil];
        //4.根元素
        TBXMLElement *rootElement = tbXML.rootXMLElement;
        //5.得到根元素的值
        NSString *debug = [TBXML valueOfAttributeNamed:@"runtime" forElement:rootElement];
        //5.得到某个元素的子元素
        TBXMLElement *serverElement = [TBXML childElementNamed:@"runtime" parentElement:rootElement];
        //使用循环进行遍历
        while (serverElement) {
            //name
            NSString *name =  [TBXML valueOfAttributeNamed:@"name" forElement:serverElement];
            if ([name isEqualToString:debug]) {
                //serverUrl
                TBXMLElement* serverUrlElement= [TBXML childElementNamed:@"serverUrl" parentElement:serverElement];
                NSString *serverUrl = [TBXML textForElement:serverUrlElement];
                //imageUrl
                TBXMLElement *imageUrlElement = [TBXML childElementNamed:@"imageUrl" parentElement:serverElement];
                NSString *imageUrl = [TBXML textForElement:imageUrlElement];
                self.imageUrl = imageUrl;
                self.serverUrl = serverUrl;
            }
            //得到下一个子元素(runtime)
            //得到同级或相临的子元素
            serverElement = [TBXML nextSiblingNamed:@"runtime" searchFromElement:serverElement];
        }
    }
}

@end

