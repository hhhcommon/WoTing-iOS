//
//  AutomatePlist.h
//  自动登录
//
//  Created by 小震GG on 16/7/8.
//  Copyright © 2016年 小震GG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutomatePlist : NSObject

+(NSString *)readPlistForKey:(NSString *)plkey;
+(void)writePlistForkey:(NSString *)plKey value:(NSString *)plValue;

@end
