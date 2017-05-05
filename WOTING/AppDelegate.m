//
//  AppDelegate.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//
//23456789的撒旦撒倒萨大

#import "AppDelegate.h"

#import <CoreLocation/CoreLocation.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MapKit/MapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "WTBoFangViewController.h"
#import "WTXiangJiangViewController.h"
#import "WTXiangTingViewController.h"
#import "WTMainViewController.h"

#import "MainViewController.h"

#import "WTGuidanceViewController.h"

@interface AppDelegate ()<AMapLocationManagerDelegate, GuidanceViewDelegate>
@property (nonatomic, strong) UINavigationController *BFNavC;
@property (nonatomic, strong) UINavigationController *XTNavC;
@property (nonatomic, strong) UINavigationController *XJNavC;
@property (nonatomic, strong) UINavigationController *MainNavC;

@property (nonatomic, strong) WTBoFangViewController *BFViewC;
@property (nonatomic, strong) WTXiangTingViewController *XTViewC;
@property (nonatomic, strong) WTXiangJiangViewController *XJViewC;
@property (nonatomic, strong) WTMainViewController *MainViewC;
@property (nonatomic, strong) MainViewController *TabViewC;

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //高德地图appkey
    [AMapServices sharedServices].apiKey =@"8e0d786ce71ce2ec317d41b32ba5d712";
    
    //设置友盟appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"585a24992ae85b6dba0017c0"];
    
    //设置微信的appKey和appSecret wxf121849552e18759
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxf121849552e18759" appSecret:@"962517d5f0543ced89e2cd40591757ea" redirectURL:@"http://mobile.umeng.com/social"];
    
    
    //设置分享到QQ互联的appKey和appSecret
    // U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105827057"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1499359778"  appSecret:@"452ace3e601bcc9390fd2680717d3a6b" redirectURL:@"http://www.woting.com"];
    
    //设置音乐后台播放的会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
//    NSString *userPhoneNameStr = [[UIDevice currentDevice] name];//手机名称
    NSString *phoneUDIDStr =  [[[UIDevice currentDevice] identifierForVendor] UUIDString];  //设备唯一标示码
    phoneUDIDStr = [phoneUDIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *PhoneMobileClass = [WKProgressHUD deviceVersion]; //手机型号
    
    
    CGRect rx = [UIScreen mainScreen ].bounds;
    NSString *ScreenSize = [NSString stringWithFormat:@"%f*%f",rx.size.width,rx.size.height];
    [AutomatePlist writePlistForkey:@"ScreenSize" value:ScreenSize];

    [AutomatePlist writePlistForkey:@"IMEI" value:phoneUDIDStr];
    [AutomatePlist writePlistForkey:@"MobileClass" value:PhoneMobileClass];
    
    //定位
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
    [self.locationManager setLocationTimeout:6];
    
    [self.locationManager setReGeocodeTimeout:3];
    //带逆地理的单次定位
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                return;
            }
        }
        
        //逆地理信息
        if (regeocode)
        {
            NSString *cityStr = [regeocode.adcode substringToIndex:2];
            
            NSString *City = [NSString stringWithFormat:@"%@0000",cityStr];
            [AutomatePlist writePlistForkey:@"City" value:City];
            [AutomatePlist writePlistForkey:@"cityPro" value:regeocode.province];
        }
    }];

    //iOS 9（包含iOS 9）之后新特性：将允许出现这种场景，同一app中多个locationmanager：一些只能在前台定位，另一些可在后台定位，并可随时禁止其后台定位。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        self.locationManager.allowsBackgroundLocationUpdates = YES;
    }else {
        //iOS 9（不包含iOS 9） 之前设置允许后台定位参数，保持不会被系统挂起
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    }
    //开始持续定位
//    [self.locationManager startUpdatingLocation];
    [self.locationManager setLocatingWithReGeocode:YES];
    
    
    //判断用户是否处于登录状态
    [self YESorNOAppLogin];
    
    //设置window
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _window.backgroundColor = [UIColor whiteColor];
    
    //修改状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
//    self.window.rootViewController = [self crateTabBarControllerView];
    //设置根控制器
    //通过读取用户偏好设置 判断app是否是第一次安装设置
//    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
//    
//    BOOL isUsed = [userDef integerForKey:@"ISUSED"];
//    
//    
//    if (isUsed == YES) {
        //根控制器设置为分栏控制器
        
        self.window.rootViewController = [self crateTabBarControllerView];
        
//        [self.window makeKeyAndVisible];
//        
//        //通过用户偏好设置中的标记 来判断是否需要登录
//       // [self showLogin];
//        
//        
//        
//    }else{
//        //根控制器设置为引导页
//        
//        self.window.rootViewController = [self createGuidanceViewController];
//    }

    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark -- 定位服务成功并回调代理
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    
    [AutomatePlist writePlistForkey:@"GPS-longitude" value:[NSString  stringWithFormat:@"%f",location.coordinate.longitude]];
    [AutomatePlist writePlistForkey:@"GPS-latitude" value:[NSString  stringWithFormat:@"%f",location.coordinate.latitude]];

}


#pragma mark -- 创建分栏控制器
- (UIViewController *)crateTabBarControllerView{
    
    //创建播放对象
    _BFViewC = [[WTBoFangViewController alloc] init];
    _BFNavC = [[UINavigationController alloc] initWithRootViewController:_BFViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *BFItem = [[UITabBarItem alloc] initWithTitle:@"下载" image:[UIImage imageNamed:@"WTDownLoad.png"] selectedImage:[UIImage imageNamed:@"WTDownLoad_der.png"]];
    _BFNavC.tabBarItem = BFItem;

    //创建享听对象
    _XJViewC = [[WTXiangJiangViewController alloc] init];
    _XJNavC = [[UINavigationController alloc] initWithRootViewController:_XJViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *XJItem = [[UITabBarItem alloc] initWithTitle:@"享听" image:[UIImage imageNamed:@"WTting.png"] selectedImage:[UIImage imageNamed:@"WTting_der.png"]];
    _XJNavC.tabBarItem = XJItem;

    //创建享讲对象
    _XTViewC = [[WTXiangTingViewController alloc] init];
    _XTNavC = [[UINavigationController alloc] initWithRootViewController:_XTViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *XTItem = [[UITabBarItem alloc] initWithTitle:@"享讲" image:[UIImage imageNamed:@"WTjiang.png"] selectedImage:[UIImage imageNamed:@"WTjiang_der.png"]];
    _XTNavC.tabBarItem = XTItem;
    
    //创建我的对象
    _MainViewC = [[WTMainViewController alloc] init];
    _MainNavC = [[UINavigationController alloc] initWithRootViewController:_MainViewC];
    //创建对应视图控制器的标签按钮
    UITabBarItem *MainItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"WTwode.png"] selectedImage:[UIImage imageNamed:@"WTwode_der.png"]];
    _MainNavC.tabBarItem = MainItem;

    //创建根视图控制器对象
    _TabViewC = [[MainViewController alloc] init];
    //添加标签控制器中的子视图控制器
    _TabViewC.viewControllers = @[_BFNavC,_XJNavC, _XTNavC, _MainNavC];
    
    
    return _TabViewC;
}

// 分享回调
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark -- 引导页

- (UIViewController *)createGuidanceViewController{
    
    WTGuidanceViewController *guidanceView = [[WTGuidanceViewController alloc] init];
    
    //点击开始体验 应该切换根控制器为分栏
    
    //加一个delegate回调 回到appDelegate中 切换根控制器
    guidanceView.delegate = self;
    
    return guidanceView;
    
}

#pragma mark -- 引导页的delegate

- (void)changeRootViewController{
    
    //引导页显示结束 将根控制器改为分栏控制器
    self.window.rootViewController = [self crateTabBarControllerView];
    
  //  [self showLogin];
    //如果先显示引导页再显示分栏 依然需要检查是否需要登录
}

- (void)YESorNOAppLogin{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters ;
    
    if ([uid isEqualToString:@"0"]||[uid isEqualToString:@""]) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",nil];
    }else {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",nil];
    }
    
        NSString *login_Str = WoTing_EntryApp;

        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                NSDictionary *UserId = resultDict[@"UserInfo"];
                NSDictionary *heheDict = [[NSDictionary alloc] initWithDictionary:UserId];
                
                [AutomatePlist writePlistForkey:@"LoginDict" valueDict:heheDict];
                [AutomatePlist writePlistForkey:@"Uid" value:heheDict[@"UserId"]];
                [AutomatePlist writePlistForkey:@"UName" value:heheDict[@"UserName"]];
                [AutomatePlist writePlistForkey:@"Region" value:heheDict[@"Region"]];
                
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"2003"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                
            }
            
        } fail:^(NSError *error) {
            
            
            [WKProgressHUD popMessage:@"服务器连接失败" inView:nil duration:0.5 animated:YES];
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
        }];
        
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //开启后台任务
    [application beginBackgroundTaskWithExpirationHandler:nil];

}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    [self.locationManager stopUpdatingLocation]; //停止定位
    
    //记录暂停
    [AutomatePlist writePlistForkey:@"transformbegin" value:@"0"];
    
    [AutomatePlist writePlistForkey:@"ImgV" value:@"img_radio_default"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:KEYHYCBOOL_______HYCKEY];

    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEYHYC_______HYCKEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


@end
