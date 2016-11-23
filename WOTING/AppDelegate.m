//
//  AppDelegate.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "AppDelegate.h"

#import "WTXiangJiangViewController.h"
#import "WTXiangTingViewController.h"
#import "WTDownLoadViewController.h"
#import "WTMainViewController.h"

#import "TabBarController.h"


@interface AppDelegate ()
@property (nonatomic, strong) UINavigationController *XJNavC;
@property (nonatomic, strong) UINavigationController *XTNavC;
@property (nonatomic, strong) UINavigationController *DLNavC;
@property (nonatomic, strong) UINavigationController *MainNavC;

@property (nonatomic, strong) WTXiangJiangViewController *XJViewC;
@property (nonatomic, strong) WTXiangTingViewController *XTViewC;
@property (nonatomic, strong) WTDownLoadViewController *DLViewC;
@property (nonatomic, strong) WTMainViewController *MainViewC;
@property (nonatomic, strong) TabBarController *TabViewC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _window.backgroundColor = [UIColor whiteColor];
    
    //修改状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    self.window.rootViewController = [self crateTabBarControllerView];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark -- 创建分栏控制器
- (UIViewController *)crateTabBarControllerView{

    //创建享听对象
    _XJViewC = [[WTXiangJiangViewController alloc] init];
    _XJNavC = [[UINavigationController alloc] initWithRootViewController:_XJViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *XJItem = [[UITabBarItem alloc] initWithTitle:@"享听" image:[UIImage imageNamed:@"WTXiangTing.png"] selectedImage:[UIImage imageNamed:@"WTXiangTing_der.png"]];
    _XJNavC.tabBarItem = XJItem;

    //创建享讲对象
    _XTViewC = [[WTXiangTingViewController alloc] init];
    _XTNavC = [[UINavigationController alloc] initWithRootViewController:_XTViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *XTItem = [[UITabBarItem alloc] initWithTitle:@"享讲" image:[UIImage imageNamed:@"WTXiangJiang.png"] selectedImage:[UIImage imageNamed:@"WTXiangJiang_der.png"]];
    _XTNavC.tabBarItem = XTItem;
    
    //创建下载对象
    _DLViewC = [[WTDownLoadViewController alloc] init];
    _DLNavC = [[UINavigationController alloc] initWithRootViewController:_DLViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *DLItem = [[UITabBarItem alloc] initWithTitle:@"下载" image:[UIImage imageNamed:@"WTDownLoad.png"] selectedImage:[UIImage imageNamed:@"WTDownLoad_der.png"]];
    _DLNavC.tabBarItem = DLItem;
    
    //创建我的对象
    _MainViewC = [[WTMainViewController alloc] init];
    _MainNavC = [[UINavigationController alloc] initWithRootViewController:_MainViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *MainItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"WTMain.png"] selectedImage:[UIImage imageNamed:@"WTMain_der.png"]];
    _MainNavC.tabBarItem = MainItem;
    
    //创建根视图控制器对象
    _TabViewC = [[TabBarController alloc] init];
    //添加标签控制器中的子视图控制器
    _TabViewC.viewControllers = @[_XJNavC, _XTNavC, _DLNavC, _MainNavC];

    return _TabViewC;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
