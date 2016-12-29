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
}
- (IBAction)sureBtnClick:(id)sender {
}
@end
