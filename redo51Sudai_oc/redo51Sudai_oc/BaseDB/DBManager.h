//
//  DBManager.h
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sqlite3.h>

@interface DBManager : NSObject

@property (nonatomic) sqlite3 *database;

//建表
/* 建表格式: create table if not exists 表名 (列名 类型,....)
 * 注: 如需生成默认增加的id: id integer primary key autoincrement
 * NSString *sql = "create table if not exists list(id integer primary key autoincrement,name char,sex char)";
 */
- (BOOL)createTable:(NSString *)sql;


#pragma mark 增，删，改数据库
/* 增 sql语句格式: insert into 表名 (列名)values(值)
 *   NSString *insertSQL = "insert into haha (name,sex)values('iosRunner','male')";
 *
 *
 * 删 sql语句格式: delete from 表名 where 列名 ＝ 参数
 *   注：后面的 列名 ＝ 参数 用于判断删除哪条数据
 *   NSString *deleteSQL = "delete from haha where name = 'iosRunner'";
 *
 *
 * 改 sql语句格式: update 表名 set  列名 = 新参数 where 列名 ＝ 参数
 *    注：前面的 列名 ＝ 新参数 是修改的值, 后面的 列名 ＝ 参数 用于判断删除哪条数据
 *    NSString *changeSQL = "update haha set name = 'buhao' where name = 'iosRunner'";
 */
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param;

/*
 * 查找 sql语句格式: select 列名 from 表名 where 列名 ＝ 参数
 * 注：前面的列名为查询结果里所需要看到的 列名,后面的 列名 ＝ 参数 用于判断删除哪条数据
 * const char *searchSQL = "select id,name,sex from haha where name = 'puyun2'";
 */
- (NSMutableArray *)selectData:(NSString *)sql paramArray:(NSArray *)param columns:(NSInteger)col;

#pragma  查询某个东西的合计
- (NSUInteger) selectCount:(NSString *)sql paramArray:(NSArray *)param;

@end
