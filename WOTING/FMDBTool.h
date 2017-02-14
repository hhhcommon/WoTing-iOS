//
//  FMDBTool.h
//  WOTING
//
//  Created by jq on 2017/2/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface FMDBTool : NSObject

+(FMDatabase *)createDatabaseAndTable:(NSString *)tableName;     //创建并打开数据库

@end
