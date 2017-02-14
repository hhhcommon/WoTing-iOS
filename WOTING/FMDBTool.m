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
    
    FMDatabase *database;
    if (tableName != nil) {   //不为空就建表， 为空则打开数据库
        
        //根据路径创建数据库
        database = [FMDatabase databaseWithPath:fileName];
        
        if ([database open])
        {
            //4.创表
            NSString *Name = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id MusicDict);",tableName];
            
            BOOL result = [database executeUpdate:Name];
            if (result)
            {
                NSLog(@"创建表成功");
            }
        }
    }else {
        
        database = [FMDatabase databaseWithPath:fileName];
        [database open];
    }
    
    
    return database;
}

@end
