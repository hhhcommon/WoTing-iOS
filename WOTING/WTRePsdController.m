//
//  WTRePsdController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTRePsdController.h"

@interface WTRePsdController ()

@end

@implementation WTRePsdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
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

- (IBAction)blackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)sureBtnClick:(id)sender {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", _oldPwdTF.text, @"OldPassword",_XinPwdTF.text,@"NewPassword",uid,@"UserId", nil];
    
    NSString *login_Str = WoTing_ChangePwd;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"修改密码成功" inView:nil duration:0.5 animated:YES];
            
        }else if ([ReturnType isEqualToString:@"1002"]){
            
            [WKProgressHUD popMessage:@"无法获取用户" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1003"]){
            
            [WKProgressHUD popMessage:@"参数故障" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1004"]){
            
            [WKProgressHUD popMessage:@"新旧密码不能相同" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1005"]){
            
            [WKProgressHUD popMessage:@"旧密码不匹配" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1006"]){
            
            [WKProgressHUD popMessage:@"新密码储存失败" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
}
@end
