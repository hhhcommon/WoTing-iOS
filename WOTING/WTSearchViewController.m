//
//  WTSearchViewController.m
//  WOTING
//
//  Created by jq on 2016/12/15.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTSearchViewController.h"

@interface WTSearchViewController ()

@end

@implementation WTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)searchBtnClick:(id)sender {
}
@end
