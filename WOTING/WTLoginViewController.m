//
//  WTLoginViewController.m
//  WOTING
//
//  Created by jq on 2016/11/24.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTLoginViewController.h"

#import "WTRegisterViewController.h"

@interface WTLoginViewController ()

@end

@implementation WTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _LoginBtn.layer.cornerRadius = _LoginBtn.frame.size.height/6;
    _LoginBtn.layer.masksToBounds = YES;
    
    
    _LoginView.layer.cornerRadius = _LoginView.frame.size.height/6;
    _LoginView.layer.masksToBounds = YES;
    
    
    _WeiBoBtn.layer.cornerRadius = _WeiBoBtn.frame.size.height/6;
    _WeiBoBtn.layer.masksToBounds = YES;
    
    
    _QQBtn.layer.cornerRadius = _QQBtn.frame.size.height/6;
    _QQBtn.layer.masksToBounds = YES;
    
    _WeChetBtn.layer.cornerRadius = _WeChetBtn.frame.size.height/6;
    _WeChetBtn.layer.masksToBounds = YES;
    
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//返回按钮
- (IBAction)blackBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//跳转注册
- (IBAction)RegistBtnClick:(id)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    WTRegisterViewController *wtRVC = [[WTRegisterViewController alloc] init];
    
    [self.navigationController pushViewController:wtRVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

//此处应该有网络请求
- (IBAction)LoginBtnClick:(id)sender {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", _NameTextfield.text, @"UserName", _PWDTextfield.text, @"Password", nil];
    
    NSString *login_Str = WoTing_Login;
    

    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *UserId = resultDict[@"UserInfo"];
            NSDictionary *heheDict = [[NSDictionary alloc] initWithDictionary:UserId];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginChangeNotification" object:nil userInfo:heheDict];
            
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"%@", resultDict);
        }else if ([ReturnType isEqualToString:@"1002"]){
            
            [E_HUDView showMsg:@"用户不存在" inView:nil];
        }else if ([ReturnType isEqualToString:@"1003"]){
            
            [E_HUDView showMsg:@"密码输入错误" inView:nil];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
}

//三方登录
- (IBAction)WeiChatBtnClick:(id)sender {
    
}

- (IBAction)QQBtnClick:(id)sender {
    
}

- (IBAction)WeiBoBtnClick:(id)sender {
    
}
@end
