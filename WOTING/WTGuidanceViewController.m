//
//  WTGuidanceViewController.m
//  WOTING
//
//  Created by jq on 2017/3/28.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTGuidanceViewController.h"

#define COUNT 3

@interface WTGuidanceViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain)UIScrollView * scrollView;

@end

@implementation WTGuidanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createScrollView];
}

- (void)createScrollView{
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height)];
    
    for (int i = 0; i < COUNT; i++) {
        NSString * name = [NSString stringWithFormat:@"appIntroduce_%d.jpg",i+1];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(K_Screen_Width * i, 0, K_Screen_Width, K_Screen_Height)];
        imageView.image = [UIImage imageNamed:name];
        [_scrollView addSubview:imageView];
    }
    
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 200, 80)];
    
    btn.center = CGPointMake(K_Screen_Width*(COUNT-0.5) , K_Screen_Height - 200);
    
    btn.layer.borderWidth = 1;
    
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [btn setTitle:@"开始体验" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(startClick:)  forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:btn];
    
    
    _scrollView.bounces = NO;
    
    _scrollView.contentSize = CGSizeMake(K_Screen_Width * COUNT, 0);
    
    _scrollView.pagingEnabled = YES;
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.delegate = self;
    
    [self.view addSubview:_scrollView];
    
    
}
#pragma mark -- 开始体验
- (void)startClick:(id)sender{
    
    //开始体验 将用户偏好设置中的标记变为1
    
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    
    [userDef setInteger:1 forKey:@"ISUSED"];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeRootViewController)]) {
        [self.delegate changeRootViewController];
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

@end
