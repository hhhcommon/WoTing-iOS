//
//  FMDBTool.m
//  WOTING
//
//  Created by jq on 2017/2/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "FMDBTool.h"

@implementation FMDBTool


+(FMDatabase *)createDatabaseAndTable:(NSString *)tableName{
    
    NSString *fileName = [kDocumentPath stringByAppendingPathComponent:@"WoTing.db"];
    NSLog(@"%@",fileName);
    FMDatabase *database;
    BOOL isOK = false ;
    //不为空就建表， 为空则打开数据库
        
    //根据路径创建数据库
    database = [FMDatabase databaseWithPath:fileName];
    
    if ([database open])
    {
        FMResultSet *rs = [database executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
        while ([rs next])
        {
            // just print out what we've got in a number of formats.
            NSInteger count = [rs intForColumn:@"count"];
            
            if (0 == count)
            {
                isOK = NO;
            }
            else
            {
                isOK = YES;
            }
        }
        if (isOK) {
            
            NSLog(@"打开数据库成功");
        }else{
            //4.创表
            NSString *Name = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (%@ id);",tableName, tableName];
            
            BOOL result = [database executeUpdate:Name];
            if (result)
            {
                NSLog(@"创建表成功");
            }
        }
    }
    
    return database;
}

// 判断是否存在表
//- (BOOL)isTableOK:(NSString *)tableName And:(FMDatabase *)DB
//{
//    FMResultSet *rs = [DB executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
//    while ([rs next])
//    {
//        // just print out what we've got in a number of formats.
//        NSInteger count = [rs intForColumn:@"count"];
//        
//        if (0 == count)
//        {
//            return NO;
//        }
//        else
//        {
//            return YES;
//        }
//    }
//    
//    return NO;
//}

@end
