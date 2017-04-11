//
//  WTXiangJiangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiangJiangViewController.h"

#import "WTNewsViewController.h"
#import "WTSearchViewController.h"

#import "WTTuiJianViewController.h"     //推荐
#import "WTDianTaiViewController.h"     //电台
#import "WTFenLeiViewController.h"      //分类


#import "SKMainScrollView.h"

@interface WTXiangJiangViewController ()<UIScrollViewDelegate>
{
    
    NSMutableArray      *_DataArray;
    SKMainScrollView    *contentScrollView;
    UIImageView         *titleView;
    UIImageView         *barLineImageView;//标识条
    UILabel             *barLab;    //
    
}
@end

@implementation WTXiangJiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _DataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScrollerViewChange) name:@"TABLEVIEWCLICK" object:nil];
    
    [self initTiteBarView];
    [self initScrollerView];
    
    
    
}


- (void)initTiteBarView{
    
    titleView = [[UIImageView alloc] init];
    titleView.userInteractionEnabled = YES;
    titleView.image = [UIImage imageNamed:@"titleImgV.png"];
    [_NavView addSubview:titleView];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(23);
        make.centerX.equalTo(_NavView.mas_centerX);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(28);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1221;
    leftBtn.layer.cornerRadius = 28/4.0;
    leftBtn.layer.masksToBounds = YES;
    [leftBtn setTitle:@"推荐" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(28);
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
    }];
    leftBtn.selected = YES;
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.tag = 1222;
    centerBtn.layer.cornerRadius = 28/4.0;
    centerBtn.layer.masksToBounds = YES;
    [centerBtn setTitle:@"电台" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleView addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(28);
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    UIButton  *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1223;
    rightBtn.layer.cornerRadius = 28/4.0;
    rightBtn.layer.masksToBounds = YES;
    [rightBtn setTitle:@"分类" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [titleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(28);
        make.left.equalTo(centerBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    
    barLineImageView = [[UIImageView alloc] init];
    barLineImageView.userInteractionEnabled = YES;
    barLineImageView.backgroundColor = [UIColor whiteColor];
    barLineImageView.userInteractionEnabled = YES;
    barLineImageView.layer.cornerRadius = 28/2;
    barLineImageView.layer.masksToBounds = YES;
    [titleView addSubview:barLineImageView];
    [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(28);
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    barLab = [[UILabel alloc] init];
    barLab.userInteractionEnabled = YES;
    barLab.font = [UIFont boldSystemFontOfSize:15];
    barLab.textAlignment = NSTextAlignmentCenter;
    barLab.text = @"推荐";
    barLab.textColor = [UIColor JQTColor];
    
    [barLineImageView addSubview:barLab];
    [barLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(barLineImageView.mas_centerX);
        make.centerY.equalTo(barLineImageView.mas_centerY);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(200/3);
    }];
    
    
    [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}


- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 49 - 64)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 3, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 3; i ++) {
        
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-(void)labelTouchUpInside:(UITapGestureRecognizer *)recognizer{
//
//    NSLog(@"点击");
//
//
//
//}

#pragma mark - 视图左右切换
//* scrollView左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        //   NSInteger currentIndex = scrollView.contentOffset.x/titleView.frame.size.width;
        
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
                make.height.mas_equalTo(28);
                
                make.left.mas_equalTo((titleView.frame.size.width)/3);
                
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            barLab.text = @"电台";
            
        }else if (scrollView.contentOffset.x == 0){
            
            leftBtn.selected = YES;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
                make.height.mas_equalTo(28);
                
                make.left.mas_equalTo(0);
                
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            barLab.text = @"推荐";
        }else if (scrollView.contentOffset.x == K_Screen_Width*2){
            
            leftBtn.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = YES;
            
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
                make.height.mas_equalTo(28);
                
                make.left.mas_equalTo((titleView.frame.size.width)*2/3);
                
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            barLab.text = @"分类";
        }
        
    }
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    // [UIView animateWithDuration:0.5 animations:^{
    
    /** 首先切换标识条 */
    [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(28);
        make.centerX.equalTo(aBtn);
        make.bottom.equalTo(titleView.mas_bottom);
        
        //  }];
        
        
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

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat pageWidth = scrollView.frame.size.width;
//    NSInteger page = scrollView.contentOffset.x / pageWidth;
//
//[self.segmentedControl setSelectedSegmentIndex:page animated:YES];
//}

//点击事件, 切换到播放页
//- (void)ScrollerViewChange {
//
//    contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
//
//
//}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


- (IBAction)XiaoXibtnClick:(id)sender {
    
    WTNewsViewController *wtnewVC = [[WTNewsViewController alloc] init];
    wtnewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtnewVC animated:YES];
    
}

- (IBAction)SearchBtnClick:(id)sender {
    
    WTSearchViewController *wtSearVC = [[WTSearchViewController alloc] init];
    wtSearVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtSearVC animated:YES];
    
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
