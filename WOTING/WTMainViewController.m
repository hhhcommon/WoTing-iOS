//
//  WTMainViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTMainViewController.h"

@interface WTMainViewController (){
    
    /** 设置ICON */
    NSArray         *iconsArray;
    /** 设置Title */
    NSArray         *titlesArray;
}

@end

@implementation WTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
    iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"set_clean", nil], [NSArray arrayWithObjects:@"set_about", nil],[NSArray arrayWithObjects:@"set_about",@"", nil],[NSArray arrayWithObjects:@"set_about", nil], nil];
    
    titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"播放历史", nil], [NSArray arrayWithObjects:@"2/3/4G网络播放和下载提示",  nil],[NSArray arrayWithObjects:@"智能硬件",@"应用分享",  nil], [NSArray arrayWithObjects:@"其它设置",  nil] ,nil];
    
    self.view.backgroundColor = [UIColor skLineImageColor];
    [self initContents];
}

- (void)initContents{
    
    
    
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
