//
//  WTBoundPhoneController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoundPhoneController.h"

@interface WTBoundPhoneController ()

@end

@implementation WTBoundPhoneController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _phoneView.layer.cornerRadius = 5;
    _phoneView.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
    
    _YZMView.layer.cornerRadius = 5;
    _YZMView.layer.masksToBounds = YES;
    
    _YZMBtn.layer.cornerRadius = 5;
    _YZMBtn.layer.masksToBounds = YES;
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
}
- (IBAction)YZMBtnClick:(id)sender {
}
- (IBAction)sureBtnClick:(id)sender {
}
@end
