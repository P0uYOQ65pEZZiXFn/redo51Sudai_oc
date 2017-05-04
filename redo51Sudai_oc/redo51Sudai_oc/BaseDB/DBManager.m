//
//  DBManager.m
//  redo51Sudai_oc
//
//  Created by ZhongLiangLiang on 17/5/3.
//  Copyright © 2017年 zhongliangliang. All rights reserved.
//

#import "DBManager.h"

@implementation DBManager

//生成路径－－dbName 数据库名字
- (NSString *)getPath:(NSString *)dbName {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [NSString stringWithFormat:@"%@/%@.db",documentPath,dbName];
    return path;
}

//打开数据库(不存在就创建)
- (BOOL)openDb {
    return sqlite3_open([[self getPath:@"project"] UTF8String], &_database) == SQLITE_OK;
}

//建表
/* 建表格式: create table if not exists 表名 (列名 类型,....)
 * 注: 如需生成默认增加的id: id integer primary key autoincrement
 * NSString *sql = "create table if not exists list(id integer primary key autoincrement,name char,sex char)";
 */
- (BOOL)createTable:(NSString *)sql {
    if (![self openDb]) {
        [self closeDb];
        return NO;
    }
    char *error;
    int tableResult = sqlite3_exec(_database, sql.UTF8String , NULL, NULL, &error);
    if (tableResult != SQLITE_OK) {
        [self closeDb];
        return NO;
    }
    return YES;
}

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
- (BOOL)dealData:(NSString *)sql paramArray:(NSArray *)param {
    if ([self openDb]) {
        sqlite3_stmt *statement = nil;
        NSInteger success = sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL);
        if (success != SQLITE_OK) {
            return NO;
        }
        //绑定参数
        for (int i=0; i<[param count]; i++) {
            NSString *temp = [param objectAtIndex:i];
            if ([temp isKindOfClass:[NSString class]]) {
                sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
            }
        }
        success = sqlite3_step(statement);
        sqlite3_finalize(statement);
        if (success == SQLITE_ERROR) {
            return NO;
        }
    }
    else {
        return NO;
    }
    [self closeDb];
    return TRUE;
}


/*
 * 查找 sql语句格式: select 列名 from 表名 where 列名 ＝ 参数   
 * 注：前面的列名为查询结果里所需要看到的 列名,后面的 列名 ＝ 参数 用于判断删除哪条数据
 * const char *searchSQL = "select id,name,sex from haha where name = 'puyun2'";
 */
- (NSMutableArray *)selectData:(NSString *)sql paramArray:(NSArray *)param columns:(NSInteger)col {
    
    //打开数据库
    if (![self openDb]) {
        [self closeDb];
    }
    NSMutableArray *returndata = [[NSMutableArray alloc] init];//所有记录
    sqlite3_stmt *statement = nil;
    NSLog(@"查找:%i",sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL));
    if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        //绑定参数
        for (int i=0; i<[param count]; i++) {
            NSString *temp = [param objectAtIndex:i];
            if ([temp isKindOfClass:[NSString class]]) {
                sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
            }
        }
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row;//一条记录
            row = [[NSMutableArray alloc] init];
            for(int i=0; i<col; i++) {
                char* contentchar = (char*)sqlite3_column_text(statement, i);
                if (contentchar) {
                    [row addObject:[NSString stringWithFormat:@"%@",[NSString stringWithUTF8String:contentchar]]];
                }
            }
            [returndata addObject:row];
        }
    }
    sqlite3_finalize(statement);
    [self closeDb];
    return returndata;
}

#pragma  查询某个东西的合计
- (NSUInteger) selectCount:(NSString *)sql paramArray:(NSArray *)param {
    NSUInteger total = 0;
    if ([self openDb]) {
        sqlite3_stmt *statement = nil;
        if (sqlite3_prepare_v2(_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK)
            //绑定参数
            for (int i=0; i<[param count]; i++) {
                NSString *temp = [param objectAtIndex:i];
                if ([temp isKindOfClass:[NSString class]]) {
                    sqlite3_bind_text(statement, i+1, [temp UTF8String], -1, SQLITE_TRANSIENT);
                }
            }
        
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                total = sqlite3_column_int(statement, 0);
            }
        }
        sqlite3_finalize(statement);
        [self closeDb];
    }
    return total;
}

#pragma mark 关闭数据库
- (void)closeDb {
    sqlite3_close(_database);
}

@end
