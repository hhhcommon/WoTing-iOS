//
//  WTDownLoadViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDownLoadViewController.h"

#import "WTYiXiaZaiController.h"        //下载专辑
#import "WTXiaZaiZhongController.h"     //下载中
#import "WTXiaZaiShengYinController.h"     //下载声音

#import "WTNewsViewController.h"
#import "WTSearchViewController.h"

#import "SKMainScrollView.h"

@interface WTDownLoadViewController ()<UIScrollViewDelegate> {
    
    SKMainScrollView    *contentScrollView;
    NSMutableArray      *dataDownArr;
    UIView              *titleView;       //菜单栏
    UIImageView         *barLineImageView;//标识条
}

@end

@implementation WTDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;

    [self initTiteBarView];
    [self initScrollerView];
    
    UITapGestureRecognizer *tapBack = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backBtnClick:)];
    [_backView addGestureRecognizer:tapBack];
    
}

- (void)initTiteBarView{
    
    __weak WTDownLoadViewController *weakSelf = self;
    titleView = [[UIView alloc] init];
    [self.view addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(64);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.mas_equalTo(K_Screen_Width*3/5);
        make.height.mas_equalTo(44);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1221;
    [leftBtn setTitle:@"专辑" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor skTitleLowBlackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(42);
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
    }];
    leftBtn.selected = YES;
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.tag = 1222;
    [centerBtn setTitle:@"声音" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor skTitleLowBlackColor] forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleView addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(42);
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1223;
    [rightBtn setTitle:@"下载中" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor skTitleLowBlackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(42);
        make.left.equalTo(centerBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    
    barLineImageView = [[UIImageView alloc] init];
    barLineImageView.backgroundColor = [UIColor JQTColor];

    [titleView addSubview:barLineImageView];
    [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(2);
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];

    
    [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];

}


- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, 64+44, K_Screen_Width, K_Screen_Height -44 - 64)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 3, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 2; i ++) {
        
        if (i == 0) {
            
            WTYiXiaZaiController *wtTuiJianVC = [[WTYiXiaZaiController alloc] init];

            [self addChildViewController:wtTuiJianVC];
            [contentScrollView addSubview:wtTuiJianVC.view];
            [wtTuiJianVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 1) {
            
            WTXiaZaiShengYinController *wtDianTai = [[WTXiaZaiShengYinController alloc] init];
            [self addChildViewController:wtDianTai];
            [contentScrollView addSubview:wtDianTai.view];
            [wtDianTai.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 2) {
            
            WTXiaZaiZhongController *wtDianTaiVC = [[WTXiaZaiZhongController alloc] init];
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }
    }
    
    
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
        UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1222];
        UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1223];
        
        if (scrollView.contentOffset.x == K_Screen_Width) {
            
            leftBtn.selected = NO;
            centerBtn.selected = YES;
            rightBtn.selected = NO;
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
                make.height.mas_equalTo(2);
                
                make.left.mas_equalTo((titleView.frame.size.width)/3);
                
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            
        }else if (scrollView.contentOffset.x == 0){
            
            leftBtn.selected = YES;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
                make.height.mas_equalTo(2);
                
                make.left.mas_equalTo(0);
                
                make.bottom.equalTo(titleView.mas_bottom);
            }];
        }else if (scrollView.contentOffset.x == K_Screen_Width*2){
            
            leftBtn.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = YES;
            
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
                make.height.mas_equalTo(2);
                
                make.left.mas_equalTo((titleView.frame.size.width)*2/3);
                
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            
        }
  
    }
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    /** 首先切换标识条 */
    [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(2);
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//返回
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
