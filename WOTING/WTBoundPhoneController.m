//
//  WTBoundPhoneController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoundPhoneController.h"

@interface WTBoundPhoneController ()

@property (nonatomic,assign)NSInteger number;
//label上显示的数字
@property (nonatomic,strong)NSTimer *timer;
//定时器属性

@end

@implementation WTBoundPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _phoneView.layer.cornerRadius = 5;
    _phoneView.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = [UIColor lightGrayColor];
    
    _YZMView.layer.cornerRadius = 5;
    _YZMView.layer.masksToBounds = YES;
    
    _YZMBtn.layer.cornerRadius = 5;
    _YZMBtn.layer.masksToBounds = YES;
    
    [_numberTF addTarget:self action:@selector(changeNumber:) forControlEvents:UIControlEventEditingChanged];
}

- (void)changeNumber:(UITextField *)tf {
    
    if (tf.text.length == 6) {
        
        _sureBtn.selected = YES;
        _sureBtn.backgroundColor = [UIColor JQTColor];
    }else {
        
        _sureBtn.selected = NO;
        _sureBtn.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createTime {
    
    NSDictionary *userInfo = @{@"key":@"value"};
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(runTime:) userInfo:userInfo repeats:YES];
}

- (void)runTime:(NSTimer *)time {
    
    _number--;
    
    [_YZMBtn setTitle:[NSString stringWithFormat:@"%lu",_number] forState:UIControlStateNormal];
    
    if (_number == -1) {
        
        [_YZMBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        
        _YZMBtn.selected = NO;
        
        [_timer setFireDate:[NSDate distantFuture]];
        
        
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)blackBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)YZMBtnClick:(id)sender {
    
    if (_phoneTextF.text.length == 11) {
        
        if (_YZMBtn.selected == NO) {
            
            NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
            NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
            NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
            NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
            NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
            
            NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"2", @"OperType", _phoneTextF.text, @"PhoneNum", nil];
            
            NSString *login_Str = WoTing_yanZM;
            
            
            [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
                
                
                NSDictionary *resultDict = (NSDictionary *)response;
                
                NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
                if ([ReturnType isEqualToString:@"1001"]) {
                    
                    [WKProgressHUD popMessage:@"验证码发生成功" inView:nil duration:0.5 animated:YES];
                    
                    _YZMBtn.selected = YES;
                    _number = 60;
                    [_YZMBtn setTitle:@"60" forState:UIControlStateNormal];
                    
                    [self createTime];  //设置时间器

                    
                }else if ([ReturnType isEqualToString:@"T"]){
                    
                    [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
                    
                }
                
            } fail:^(NSError *error) {
                
                
                NSLog(@"%@", error);
                
            }];

        }else{
            
            [WKProgressHUD popMessage:@"两次获取时间间隔最少60秒" inView:nil duration:0.5 animated:YES];
            
        }
    }else {
        
        [WKProgressHUD popMessage:@"请输入正确手机号" inView:nil duration:0.5 animated:YES];
        
    }
    
}
- (IBAction)sureBtnClick:(id)sender {
    
    if (_sureBtn.selected == YES) {
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", _phoneTextF.text, @"PhoneNum",_numberTF.text,@"CheckCode", nil];
        
        NSString *login_Str = WoTing_YanZhengbangDing;
        
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [WKProgressHUD popMessage:@"绑定成功" inView:nil duration:0.5 animated:YES];
                
            }else if ([ReturnType isEqualToString:@"1002"]){
                
                [WKProgressHUD popMessage:@"验证码不正确" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1003"]){
                
                [WKProgressHUD popMessage:@"手机号不匹配" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1004"]){
                
                [WKProgressHUD popMessage:@"验证码已过期" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
            NSLog(@"%@", error);
            
        }];
    }
}
@end
