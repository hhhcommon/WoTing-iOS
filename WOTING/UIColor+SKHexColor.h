//
//  UIColor+SKHexColor.h
//  Vickey_NCE
//
//  Created by jq on 16/5/3.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface UIColor (SKHexColor)

#pragma mark - 十六进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *) stringToConvert;

#pragma mark - 无颜色
+ (UIColor *)skClearColor;

#pragma mark - 背景颜色-浅灰色 f3f3f3
/** 颜色代码 - f3f3f3 **/
+ (UIColor *)skBackgroundLowGrayColor;

#pragma mark - 背景颜色-青灰色 88a6c5
/** 颜色代码 - 88a6c5 **/
+ (UIColor *)skLineBorderTextColor;

#pragma mark - 背景颜色-文字背景 5a9dde
/** 颜色代码 - 5a9dde **/
+ (UIColor *)skTitleBorderTextColor;

#pragma mark - 背景颜色-浅青蓝色 4fbee9
/** 颜色代码 - 4fbee9 **/
+ (UIColor *)skBackgroundLowBlueColor;

#pragma mark - 背景颜色-文字背景 e4e4e4
/** 颜色代码 - e4e4e4 **/
+ (UIColor *)skBackgroundTextColor;

#pragma mark - 文字颜色-文字 848487
/** 颜色代码 - 848487 **/
+ (UIColor *)skTextCenterBlackColor;

#pragma mark - 背景颜色-白色
/** 颜色代码 - 白色 **/
+ (UIColor *)skWhiteColor;

#pragma mark - 灰色背景 b8b8b9
/** 颜色代码 - b8b8b9 **/
+ (UIColor *)skButtonBackgroudGrayColor;

#pragma mark - 蓝色背景 50aae2
/** 颜色代码 - 50aae2 **/
+ (UIColor *)skButtonBackgroudBlueColor;

#pragma mark - 灰色背景 f7f7f7
/** 颜色代码 - f7f7f7 **/
+ (UIColor *)skButtonTitleWhiteColor;

#pragma mark - 字体颜色-浅灰色 939396
/** 颜色代码 - 939396 **/
+ (UIColor *)skTextLowGrayColor;

#pragma mark - 字体颜色-浅白色
/** 颜色代码 - b9c4d1 **/
+ (UIColor *)skTitleLowWhiteColor;

#pragma mark - 字体颜色-深黑色 1d1d26
/** 颜色代码 - 1d1d26 **/
+ (UIColor *)skTitleHighBlackColor;

#pragma mark - 登录退出按钮背景颜色-浅灰色 56565a
/** 颜色代码 - 56565a **/
+ (UIColor *)skTitleContentGrayColor;

#pragma mark - 字体颜色-中黑色 45454a
/** 颜色代码 - 45454a **/
+ (UIColor *)skTitleCenterBlackColor;

#pragma mark - 字体颜色-浅黑色
/** 颜色代码 - 909090 **/
+ (UIColor *)skTitleLowBlackColor;

#pragma mark - 分割线颜色-深灰色 40a0dc
/** 颜色代码 - 40a0dc **/
+ (UIColor *)skTitleLowBlueColor;

#pragma mark - 分割线颜色-深灰色 dddddd
/** 颜色代码 - dddddd **/
+ (UIColor *)skSeptorGrayColor;

#pragma mark - 分割线颜色-深灰色 7c7c7f
/** 颜色代码 - 7c7c7f **/
+ (UIColor *)skTitleButtonGrayColor;

#pragma mark - 登录按钮标签颜色-浅白色 b2bfcf
/** 颜色代码 - b2bfcf **/
+ (UIColor *)skTitleLoginWhiteColor;

#pragma mark - 登录线颜色-浅白色 4c545c
/** 颜色代码 - 4c545c **/
+ (UIColor *)skLineLoginWhiteColor;

#pragma mark - 登录退出按钮背景颜色-浅白色 6e7175
/** 颜色代码 - 6e7175 **/
+ (UIColor *)skBackgroundLoginGrayColor;

#pragma mark - 登录退出按钮颜色-浅白色 e0e1e1
/** 颜色代码 - e0e1e1 **/
+ (UIColor *)skTitleLoginOutButtonWhiteColor;

/** 颜色代码 - ececec **/
+ (UIColor *)skLineImageColor;

/** 颜色代码 - 5f5f63 **/
+ (UIColor *)skTitleLoginWelcomeColor;

/** 颜色代码 - d35748 **/
+ (UIColor *)skTitleLoginWrongColor;

#pragma mark - 背景颜色-蓝色 2678c8
/** 颜色代码 - 2678c8 **/
+ (UIColor *)skBackgroundBlueColor;

/** 颜色代码 - cccccc **/
+ (UIColor *)skLineImageHighColor;


@end
