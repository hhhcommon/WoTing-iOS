//
//  WTJieMuViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTJieMuViewController.h"

#import "WTTuiJianViewController.h"
#import "WTDianTaiViewController.h"
#import "WTFenLeiViewController.h"

#import "SKMainScrollView.h"

@interface WTJieMuViewController ()<UIScrollViewDelegate>{
    
    NSMutableArray      *_DataArray;
    SKMainScrollView    *contentScrollView;
    UIView              *titleView;//标识栏
    UIImageView         *barLineImageView;//标识条
}


@end

@implementation WTJieMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initTiteBarView];
    [self initScrollerView];
}

- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, POINT_Y(90), K_Screen_Width, K_Screen_Height - POINT_Y(90) - 49 - 64)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 3, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 4; i ++) {
        
        if (i == 0) {
            
            WTTuiJianViewController *wtTuiJianVC = [[WTTuiJianViewController alloc] init];
            //  skDongTaiVC.tagArr = sktagArr;
            [self addChildViewController:wtTuiJianVC];
            [contentScrollView addSubview:wtTuiJianVC.view];
            [wtTuiJianVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 1) {
            
            WTDianTaiViewController *wtDianTaiVC = [[WTDianTaiViewController alloc] init];
            // skXiaoZuVC.groupArr = skgroupArr;
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else{
            
            WTFenLeiViewController *wtFenLeiVC = [[WTFenLeiViewController alloc] init];
            //  skXiaoZuVC.userArr = skuserArr;
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
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(90))];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1221;
    [leftBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
    }];
    leftBtn.selected = YES;
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.tag = 1222;
    [centerBtn setTitle:@"电台" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1223;
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [titleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(centerBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    barLineImageView = [[UIImageView alloc] init];
    barLineImageView.backgroundColor = [UIColor JQTColor];
    barLineImageView.layer.cornerRadius = 2.0;
    [titleView addSubview:barLineImageView];
    [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        /** 首先切换标识条 */
        [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
            make.height.mas_equalTo(POINT_Y(6));
            make.left.mas_equalTo((scrollView.contentOffset.x/3));
            make.bottom.equalTo(titleView.mas_bottom);
        }];
    }
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    /** 首先切换标识条 */
    [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(aBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    aBtn.selected = YES;
    
    UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
    UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1222];
    UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1223];
    if (aBtn.tag == 1221) {
        
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
        
    }else if (aBtn.tag == 1222) {
        
        leftBtn.selected = NO;
        rightBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
        
    }else if (aBtn.tag == 1223) {
        
        centerBtn.selected = NO;
        leftBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
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
