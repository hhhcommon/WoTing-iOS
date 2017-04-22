//
//  WTQunPsdController.m
//  WOTING
//
//  Created by jq on 2017/4/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunPsdController.h"

@interface WTQunPsdController ()

@end

@implementation WTQunPsdController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _SureBtn.enabled = NO;
    
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.masksToBounds = YES;
    
    _SureBtn.layer.cornerRadius = 5;
    _SureBtn.layer.masksToBounds = YES;
    
   // _YuanPadLab.text = [NSString stringWithFormat:@"当前群密码为: %@",];
    
    [_SurepsdTextFile addTarget:self action:@selector(SurePsdChange:) forControlEvents:UIControlEventEditingChanged];
    [_psdTextFile addTarget:self action:@selector(PsdChange:) forControlEvents:UIControlEventEditingChanged];
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

//监听密码输入
- (void)SurePsdChange:(UITextField *)tf{
    
    if (_psdTextFile.text.length >= 6) {
        
        if (tf.text.length >= 6) {
            
            _SureBtn.backgroundColor = [UIColor JQTColor];
            _SureBtn.enabled = YES;
        }else{
            
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
    }else{
        
        _SureBtn.backgroundColor = [UIColor lightGrayColor];
        _SureBtn.enabled = NO;
    }
}

- (void)PsdChange:(UITextField *)tf{
    
    if (_SurepsdTextFile.text.length >= 6) {
        
        if (tf.text.length >= 6) {
            
            _SureBtn.backgroundColor = [UIColor JQTColor];
            _SureBtn.enabled = YES;
        }else{
            
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
    }else{
        
        _SureBtn.backgroundColor = [UIColor lightGrayColor];
        _SureBtn.enabled = NO;
    }
    
}

//确定按钮
- (IBAction)SureBtnClick:(id)sender {
    
    if ([_psdTextFile.text isEqualToString:_SurepsdTextFile.text]) {
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",_SurepsdTextFile.text,@"NewPassword",nil];
        
        NSString *login_Str = WoTing_UpdatePwd;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [WKProgressHUD popMessage:@"密码修改成功" inView:nil duration:0.5 animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"200"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
    }else{
        
        [WKProgressHUD popMessage:@"两次密码输入不匹配" inView:nil duration:0.5 animated:YES];
    }
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
