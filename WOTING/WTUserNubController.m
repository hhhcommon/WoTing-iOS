//
//  WTUserNubController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTUserNubController.h"

@interface WTUserNubController ()

@end

@implementation WTUserNubController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _textFView.layer.cornerRadius = 5;
    _textFView.layer.masksToBounds = YES;
    
    _sureBtn.layer.cornerRadius = 5;
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.backgroundColor = [UIColor lightGrayColor];
    
    [_numTextF addTarget:self action:@selector(Changed:) forControlEvents:UIControlEventEditingChanged];
}

- (void)Changed:(UITextField *)textf {
    
    if (textf.text.length >= 6 && textf.text.length < 20) {
        
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

- (IBAction)sureBtnClick:(id)sender {
    
    if (_sureBtn.selected == YES) {
        
        
    }
}
@end
