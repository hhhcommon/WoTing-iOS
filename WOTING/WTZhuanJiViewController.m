//
//  WTZhuanJiViewController.m
//  WOTING
//
//  Created by jq on 2016/12/19.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZhuanJiViewController.h"

#import "WTZJTuijianController.h"
#import "WTZJJMController.h"

#import "SKMainScrollView.h"

@interface WTZhuanJiViewController ()<UIScrollViewDelegate> {
    
    NSMutableArray      *dataZJArr;
    NSMutableDictionary *dataZJDict;
    
    UIImageView         *barLineImageView;//标识条
    SKMainScrollView    *contentScrollView;
}

@end

@implementation WTZhuanJiViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataZJArr = [NSMutableArray arrayWithCapacity:0];
    dataZJDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [self loadDataZJ];
    [self creattitleView];
    
}

//请求数据
- (void)loadDataZJ {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", @"SEQU",@"MediaType",_contentID,@"ContentId",@"1",@"Page",nil];
    
    NSString *login_Str = WoTing_GetContentInfo;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataZJDict removeAllObjects];
            [dataZJDict setDictionary:resultDict[@"ResultInfo"]];
            
            [dataZJArr removeAllObjects];
            [dataZJArr addObjectsFromArray: dataZJDict[@"SubList"]];
            
            [self FillInterface];
            [self initScrollerView];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
}

//填充界面
- (void)FillInterface {
    
    _NameLab.text = [NSString NULLToString:dataZJDict[@"ContentName"]];
    
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataZJDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@""]];
}

//创建导航条
- (void)creattitleView {
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1221;
    [leftBtn setTitle:@"详情" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor skTitleLowBlackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_titleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_titleView.mas_width).with.multipliedBy(1.0/2);
        make.height.mas_equalTo(40);
        make.left.equalTo(_titleView);
        make.top.equalTo(_titleView);
    }];
    leftBtn.selected = YES;
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1222;
    [rightBtn setTitle:@"节目" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor skTitleLowBlackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [_titleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_titleView.mas_width).with.multipliedBy(1.0/2);
        make.height.mas_equalTo(40);
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(_titleView);
    }];
    
    barLineImageView = [[UIImageView alloc] init];
    barLineImageView.backgroundColor = [UIColor JQTColor];
    barLineImageView.layer.cornerRadius = 2.0;
    [_titleView addSubview:barLineImageView];
    [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_titleView.mas_width).with.multipliedBy(1.0/2);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(_titleView.mas_bottom);
    }];
    
    [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];

    [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initScrollerView{
    
    NSInteger HH = _titleView.frame.origin.y + 42;
    
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, HH, K_Screen_Width, K_Screen_Height - HH)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 2, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 2; i ++) {
        
        if (i == 0) {
            
            WTZJTuijianController *wtTuiJianVC = [[WTZJTuijianController alloc] init];
            wtTuiJianVC.dataXQDict = dataZJDict;
            [self addChildViewController:wtTuiJianVC];
            [contentScrollView addSubview:wtTuiJianVC.view];
            [wtTuiJianVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else{
            
            WTZJJMController *wtFenLeiVC = [[WTZJJMController alloc] init];
            wtFenLeiVC.dataZJArr = dataZJArr;
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
#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        /** 首先切换标识条 */
        [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(_titleView.mas_width).with.multipliedBy(1.0/2);
            make.height.mas_equalTo(POINT_Y(6));
            make.left.mas_equalTo((scrollView.contentOffset.x/2));
            make.bottom.equalTo(_titleView.mas_bottom);
        }];
        
        UIButton *leftBtn = (UIButton *)[_titleView viewWithTag:1221];
        UIButton *rightBtn = (UIButton *)[_titleView viewWithTag:1222];
        
        if (scrollView.contentOffset.x == K_Screen_Width) {
            
            leftBtn.selected = NO;
            rightBtn.selected = YES;
            
        }else if (scrollView.contentOffset.x == 0){
            
            leftBtn.selected = YES;
            rightBtn.selected = NO;
        }
    }
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    /** 首先切换标识条 */
    [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(_titleView.mas_width).with.multipliedBy(1.0/3);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(aBtn);
        make.bottom.equalTo(_titleView.mas_bottom);
    }];
    
    aBtn.selected = YES;
    
    UIButton *leftBtn = (UIButton *)[_titleView viewWithTag:1221];
    UIButton *rightBtn = (UIButton *)[_titleView viewWithTag:1222];
    if (aBtn.tag == 1221) {
        
        rightBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
        
    }else if (aBtn.tag == 1222) {
        
        leftBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
        
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

- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)likeBtnClick:(id)sender {
}

- (IBAction)commitBtnClick:(id)sender {
}

- (IBAction)shareBtnClick:(id)sender {
}
- (IBAction)XQBtnClick:(id)sender {
}

- (IBAction)JMBtnClick:(id)sender {
}
@end
