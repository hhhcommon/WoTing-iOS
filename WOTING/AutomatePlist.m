//
//  AutomatePlist.m
//  自动登录
//
//  Created by 小震GG on 16/7/8.
//  Copyright © 2016年 小震GG. All rights reserved.
//

#import "AutomatePlist.h"

@implementation AutomatePlist
+(NSString *)readPlistForKey:(NSString *)plkey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:plkey]) {
        return [user valueForKey:plkey];
    }
    return @"0";
    
}

+(NSDictionary *)readPlistForDict:(NSString *)plkey
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if ([user valueForKey:plkey]) {
        return [user valueForKey:plkey];
    }
    return nil;
    
}

+(void)writePlistForkey:(NSString *)plKey value:(NSString *)plValue
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:plValue forKey:plKey];
    
}

+(void)writePlistForkey:(NSString *)plKey valueDict:(NSDictionary *)plValue
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setValue:plValue forKey:plKey];
    
}


@end
