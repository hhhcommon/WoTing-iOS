//
//  UIColor+SKHexColor.m
//  Vickey_NCE
//
//  Created by jq on 16/5/3.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "UIColor+SKHexColor.h"

@implementation UIColor (SKHexColor)

+ (UIColor *)colorWithHexString:(NSString *) stringToConvert {
    
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor whiteColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor whiteColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


#pragma mark - 背景颜色
+ (UIColor *)skBackgroundLowGrayColor {
    
    return [self colorWithHexString:@"#f3f3f3"];
}


#pragma mark - 透明无颜色
+ (UIColor *)skClearColor {
    
    return [UIColor clearColor];
}

#pragma mark - 白色
+ (UIColor *)skWhiteColor {
    
    return [UIColor whiteColor];
}

#pragma mark - 背景颜色-蓝色 2678c8
+ (UIColor *)skBackgroundBlueColor {
    
    return [UIColor colorWithHexString:@"#2678c8"];
}

#pragma mark - 背景颜色-浅青蓝色 4fbee9
+ (UIColor *)skBackgroundLowBlueColor {
    
    return [UIColor colorWithHexString:@"#4fbee9"];
}

#pragma mark - 背景颜色-文字背景 88a6c5
+ (UIColor *)skLineBorderTextColor {
    
    return [UIColor colorWithHexString:@"#88a6c5"];
}

#pragma mark - 背景颜色-文字背景 5a9dde
+ (UIColor *)skTitleBorderTextColor {
    
    return [UIColor colorWithHexString:@"#5a9dde"];
}

#pragma mark - 背景颜色-文字背景 e4e4e4
+ (UIColor *)skBackgroundTextColor {
    
    return [UIColor colorWithHexString:@"#e4e4e4"];
}

#pragma mark - 文字颜色-文字 848487
+ (UIColor *)skTextCenterBlackColor {
    
    return [UIColor colorWithHexString:@"#848487"];
}

#pragma mark - 灰色背景 b8b8b9
+ (UIColor *)skButtonBackgroudGrayColor {
    
    return [UIColor colorWithHexString:@"#b8b8b9"];
}

#pragma mark - 蓝色背景 50aae2
+ (UIColor *)skButtonBackgroudBlueColor {
    
    return [UIColor colorWithHexString:@"#50aae2"];
}

#pragma mark - 灰色背景 f7f7f7
+ (UIColor *)skButtonTitleWhiteColor {
    
    return [UIColor colorWithHexString:@"#f7f7f7"];
}

#pragma mark - 字体颜色-浅灰色 939396
+ (UIColor *)skTextLowGrayColor {
    
    return [self colorWithHexString:@"#939396"];
}

#pragma mark - 字体颜色-浅白色
+ (UIColor *)skTitleLowWhiteColor {
    
    return [self colorWithHexString:@"#b9c4d1"];
}

#pragma mark - 字体颜色-深黑色
+ (UIColor *)skTitleHighBlackColor {
    
    return [self colorWithHexString:@"#1d1d26"];
}

+ (UIColor *)skLineImageColor {
    
    return [self colorWithHexString:@"#ececec"];
}

+ (UIColor *)skLineImageHighColor {
    
    return [self colorWithHexString:@"#cccccc"];
}

+ (UIColor *)skTitleCenterBlackColor {
    
    return [self colorWithHexString:@"#45454a"];
}

+ (UIColor *)skTitleLowBlackColor {
    
    return [self colorWithHexString:@"#909090"];
}

+ (UIColor *)skTitleLowBlueColor {
    
    return [self colorWithHexString:@"#40a0dc"];
}

#pragma mark - 分割线颜色-深灰色 dddddd
+ (UIColor *)skSeptorGrayColor {
    
    return [self colorWithHexString:@"#dddddd"];
}

#pragma mark - 分割线颜色-深灰色 7c7c7f
+ (UIColor *)skTitleButtonGrayColor {
    
    return [self colorWithHexString:@"#7c7c7f"];
}

#pragma mark - 登录按钮标签颜色-浅白色 b2bfcf
/** 颜色代码 - b2bfcf **/
+ (UIColor *)skTitleLoginWhiteColor {
    
    return [self colorWithHexString:@"#b2bfcf"];
}

#pragma mark - 登录线颜色-浅白色 4c545c
/** 颜色代码 - 4c545c **/
+ (UIColor *)skLineLoginWhiteColor {
    
    return [self colorWithHexString:@"#4c545c"];
}

#pragma mark - 登录退出按钮背景颜色-浅灰色 56565a
/** 颜色代码 - 56565a **/
+ (UIColor *)skTitleContentGrayColor {
    
    return [self colorWithHexString:@"#56565a"];
}

#pragma mark - 登录退出按钮背景颜色-浅灰色 6e7175
/** 颜色代码 - 6e7175 **/
+ (UIColor *)skBackgroundLoginGrayColor {
    
    return [self colorWithHexString:@"#6e7175"];
}

#pragma mark - 登录退出按钮颜色-浅白色 e0e1e1
/** 颜色代码 - e0e1e1 **/
+ (UIColor *)skTitleLoginOutButtonWhiteColor {
    
    return [self colorWithHexString:@"#e0e1e1"];
}

/** 颜色代码 - 5f5f63 **/
+ (UIColor *)skTitleLoginWelcomeColor {
    
    return [self colorWithHexString:@"#5f5f63"];
}

/** 颜色代码 - d35748 **/
+ (UIColor *)skTitleLoginWrongColor {
    
    return [self colorWithHexString:@"#d35748"];
}


@end
