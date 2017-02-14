//
//  WTJMDViewController.m
//  WOTING
//
//  Created by jq on 2017/2/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTJMDViewController.h"
#import "WTJieMuXQViewController.h"

#import "SKMainScrollView.h"

@interface WTJMDViewController ()<UIScrollViewDelegate>{
    
    SKMainScrollView    *contentScrollView;
    UIView              *titleView;//标识栏
    UIImageView         *barLineImageView;//标识条
}

@end

@implementation WTJMDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTiteBarView];
    [self initScrollerView];
}


- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, POINT_Y(90) + 64, K_Screen_Width, K_Screen_Height - POINT_Y(90) - 64)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 7, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 7; i ++) {
        
        if (i == 0) {
            
            WTJieMuXQViewController *wtTuiJianVC = [[WTJieMuXQViewController alloc] init];
            wtTuiJianVC.bcId = _contentID;
            [self addChildViewController:wtTuiJianVC];
            [contentScrollView addSubview:wtTuiJianVC.view];
            [wtTuiJianVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 1) {
            
            WTJieMuXQViewController *wtDianTaiVC = [[WTJieMuXQViewController alloc] init];
            wtDianTaiVC.bcId = _contentID;
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 2) {
            
            WTJieMuXQViewController *wtDianTaiVC = [[WTJieMuXQViewController alloc] init];
            wtDianTaiVC.bcId = _contentID;
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 3) {
            
            WTJieMuXQViewController *wtDianTaiVC = [[WTJieMuXQViewController alloc] init];
            wtDianTaiVC.bcId = _contentID;
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 4) {
            
            WTJieMuXQViewController *wtDianTaiVC = [[WTJieMuXQViewController alloc] init];
            wtDianTaiVC.bcId = _contentID;
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 5) {
            
            WTJieMuXQViewController *wtDianTaiVC = [[WTJieMuXQViewController alloc] init];
            wtDianTaiVC.bcId = _contentID;
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else{
            
            WTJieMuXQViewController *wtFenLeiVC = [[WTJieMuXQViewController alloc] init];
            wtFenLeiVC.bcId = _contentID;
            [self addChildViewController:wtFenLeiVC];
            [contentScrollView addSubview:wtFenLeiVC.view];
            [wtFenLeiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
            
        }
    }
    
    
}

- (void)initTiteBarView{
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, POINT_Y(90))];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1221;
    [leftBtn setTitle:@"周一" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
    }];
    leftBtn.selected = YES;
    
    UIButton *leftBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn1.tag = 1222;
    [leftBtn1 setTitle:@"周二" forState:UIControlStateNormal];
    [leftBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:leftBtn1];
    [leftBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    UIButton *leftBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn2.tag = 1223;
    [leftBtn2 setTitle:@"周三" forState:UIControlStateNormal];
    [leftBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn2 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:leftBtn2];
    [leftBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(leftBtn1.mas_right);
        make.top.equalTo(titleView);
    }];
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.tag = 1224;
    [centerBtn setTitle:@"周四" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(leftBtn2.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1225;
    [rightBtn setTitle:@"周五" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(centerBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.tag = 1226;
    [rightBtn1 setTitle:@"周六" forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:rightBtn1];
    [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(rightBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    UIButton *rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.tag = 1227;
    [rightBtn2 setTitle:@"周日" forState:UIControlStateNormal];
    [rightBtn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn2 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn2.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:rightBtn2];
    [rightBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(rightBtn1.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    barLineImageView = [[UIImageView alloc] init];
    barLineImageView.backgroundColor = [UIColor JQTColor];
    barLineImageView.layer.cornerRadius = 2.0;
    [titleView addSubview:barLineImageView];
    [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn2 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn2 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        /** 首先切换标识条 */
        [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
            make.height.mas_equalTo(POINT_Y(6));
            make.left.mas_equalTo((scrollView.contentOffset.x/7));
            make.bottom.equalTo(titleView.mas_bottom);
        }];
        
        UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
        UIButton *leftBtn1 = (UIButton *)[titleView viewWithTag:1222];
        UIButton *leftBtn2 = (UIButton *)[titleView viewWithTag:1223];
        UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1224];
        UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1225];
        UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1226];
        UIButton *rightBtn2 = (UIButton *)[titleView viewWithTag:1227];
        
        if (scrollView.contentOffset.x == K_Screen_Width) {
            
            leftBtn.selected = NO;
            leftBtn1.selected = YES;
            leftBtn2.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            rightBtn2.selected = NO;
            
        }else if (scrollView.contentOffset.x == 0){
            
            leftBtn.selected = YES;
            leftBtn1.selected = NO;
            leftBtn2.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            rightBtn2.selected = NO;
        }else if (scrollView.contentOffset.x == K_Screen_Width*2){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            leftBtn2.selected = YES;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            rightBtn2.selected = NO;
        }else if (scrollView.contentOffset.x == K_Screen_Width*3){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            leftBtn2.selected = NO;
            centerBtn.selected = YES;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            rightBtn2.selected = NO;
        }else if (scrollView.contentOffset.x == K_Screen_Width*4){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            leftBtn2.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = YES;
            rightBtn1.selected = NO;
            rightBtn2.selected = NO;
        }else if (scrollView.contentOffset.x == K_Screen_Width*5){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            leftBtn2.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = YES;
            rightBtn2.selected = NO;
        }else if (scrollView.contentOffset.x == K_Screen_Width*6){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            leftBtn2.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            rightBtn2.selected = YES;
        }
    }
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    /** 首先切换标识条 */
    [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/7);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(aBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    aBtn.selected = YES;
    
    UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
    UIButton *leftBtn1 = (UIButton *)[titleView viewWithTag:1222];
    UIButton *leftBtn2 = (UIButton *)[titleView viewWithTag:1223];
    UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1224];
    UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1225];
    UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1226];
    UIButton *rightBtn2 = (UIButton *)[titleView viewWithTag:1227];
    
    if (aBtn.tag == 1221) {

        leftBtn1.selected = NO;
        leftBtn2.selected = NO;
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        rightBtn1.selected = NO;
        rightBtn2.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
        
    }else if (aBtn.tag == 1222) {
        
        leftBtn.selected = NO;
        leftBtn2.selected = NO;
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        rightBtn1.selected = NO;
        rightBtn2.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
        
    }else if (aBtn.tag == 1223) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        rightBtn1.selected = NO;
        rightBtn2.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
    }else if (aBtn.tag == 1224) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        leftBtn2.selected = NO;
        rightBtn.selected = NO;
        rightBtn1.selected = NO;
        rightBtn2.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
    }else if (aBtn.tag == 1225) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        leftBtn2.selected = NO;
        centerBtn.selected = NO;
        rightBtn1.selected = NO;
        rightBtn2.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 4, 0);
    }else if (aBtn.tag == 1226) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        leftBtn2.selected = NO;
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        rightBtn2.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 5, 0);
    }else if (aBtn.tag == 1227) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        leftBtn2.selected = NO;
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        rightBtn1.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 6, 0);
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
