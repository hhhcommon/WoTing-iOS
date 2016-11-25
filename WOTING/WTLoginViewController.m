//
//  WTLoginViewController.m
//  WOTING
//
//  Created by jq on 2016/11/24.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTLoginViewController.h"

@interface WTLoginViewController ()

@end

@implementation WTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UILabel *a = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 200, 40)];
    a.text = @"这是登录页";
    a.font = [UIFont boldSystemFontOfSize:FONT_SIZE_OF_PX(50)];
    [self.view addSubview:a];
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

@end
