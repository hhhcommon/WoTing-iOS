//
//  Factory.h
//  LimiteFree
//
//  Created by jq on 16/1/19.
//  Copyright © 2016年 jq. All rights reserved.
//

//通过类名 创建控制器
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Factory : NSObject

//通过类名创建控制器
+ (UIViewController *)createControllerWithName:(NSString *)name;

//通过类名创建控制器 并设置背景颜色
+ (UIViewController *)createControllerWithName:(NSString *)name andBackgroundColor:(UIColor *)backgroundColor;

//通过类名创建导航控制器
+ (UINavigationController *)createNavigationWithRootViewController:(NSString *)name andTitle:(NSString *)title andNormalImage:(NSString *)normalImage andSeletedImage:(NSString *)selectedImage;

@end
