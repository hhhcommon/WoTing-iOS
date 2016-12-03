//
//  WTRegisterViewController.m
//  WOTING
//
//  Created by jq on 2016/11/26.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTRegisterViewController.h"

@interface WTRegisterViewController ()

@end

@implementation WTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _RegisterView.layer.cornerRadius = _RegisterView.frame.size.height/8;
    _RegisterView.layer.masksToBounds = YES;
    
    _QueDBtn.layer.cornerRadius = _QueDBtn.frame.size.height/6;
    _QueDBtn.layer.masksToBounds = YES;
    
    _YanZView.layer.cornerRadius = _YanZView.frame.size.height/6;
    _YanZView.layer.masksToBounds = YES;
    
    
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

- (IBAction)blackBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)QueDBtnClick:(id)sender {
}

- (IBAction)YanZBtnClick:(id)sender {
}
@end
