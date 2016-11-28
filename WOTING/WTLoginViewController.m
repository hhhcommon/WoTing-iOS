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
    
    
    [ZCBNetworking getWithUrl:@"" refreshCache:YES success:^(id response) {
        
        
    } fail:^(NSError *error) {
        
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
