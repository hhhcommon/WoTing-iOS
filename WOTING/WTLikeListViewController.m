//
//  WTLikeListViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTLikeListViewController.h"

#import "AllViewController.h"
#import "ZhuanJiViewController.h"
#import "ShengYinViewController.h"
#import "DianTaiViewController.h"
#import "TTSViewController.h"

#import "SKMainScrollView.h"

@interface WTLikeListViewController ()<UIScrollViewDelegate>{
    
    NSMutableArray      *_DataArray;    //（播放历史）数据数组
    NSMutableArray      *_DataShengYinArr;  //（播放历史）声音数据
    NSMutableArray      *_DataDianTaiArr;   //（播放历史）电台数据
    NSMutableArray      *_DataTTSArr;   //（播放历史）TTS数据
    
    SKMainScrollView    *contentScrollView;
    UIView              *titleView;//标识栏
    UIImageView         *barLineImageView;//标识条
}

@end

@implementation WTLikeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _DataArray = [NSMutableArray arrayWithCapacity:0];
    _DataShengYinArr = [NSMutableArray arrayWithCapacity:0];
    _DataDianTaiArr = [NSMutableArray arrayWithCapacity:0];
    _DataTTSArr = [NSMutableArray arrayWithCapacity:0];
    
    _NameLab.text = _label;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scollerViewChange:) name:@"LIKELISTCHANGE" object:nil];
    
    if ([_label isEqualToString:@"播放历史"]) {
        
        FMDatabase *fm = [FMDBTool createDatabaseAndTable:nil];
        // 1.执行查询语句
        FMResultSet *resultSet = [fm executeQuery:@"SELECT * FROM BFLS"];
        // 2.遍历结果
            while ([resultSet next]) {
                
                NSData *ID = [resultSet dataForColumn:@"BFLS"];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
                [_DataArray addObject:jsonDict];

            }
        
        NSMutableArray *Rarray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *Aarray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *Sarray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *Tarray = [NSMutableArray arrayWithCapacity:0];
        NSMutableDictionary *dictR = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableDictionary *dictA = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableDictionary *dictS = [NSMutableDictionary dictionaryWithCapacity:0];
        NSMutableDictionary *dictT = [NSMutableDictionary dictionaryWithCapacity:0];
        [dictR setObject:@"RADIO" forKey:@"MediaType"];
        [dictA setObject:@"AUDIO" forKey:@"MediaType"];
        [dictS setObject:@"SEQU" forKey:@"MediaType"];
        [dictT setObject:@"TTS" forKey:@"MediaType"];
        for (NSDictionary *dict in _DataArray) {
            
            if ([dict[@"MediaType"] isEqualToString: @"RADIO"]) {
                
                [Rarray addObject:dict];
                [_DataDianTaiArr addObjectsFromArray:Rarray];
                [dictR setObject:Rarray forKey:@"List"];
                
                
            }else if ([dict[@"MediaType"] isEqualToString: @"AUDIO"]) {
                
                [Aarray addObject:dict];
                [_DataShengYinArr addObjectsFromArray:Aarray];
                [dictA setObject:Aarray forKey:@"List"];
                
            }else if ([dict[@"MediaType"] isEqualToString: @"SEQU"]){
                
                [Sarray addObject:dict];
                [dictS setObject:Sarray forKey:@"List"];
                
            }else if ([dict[@"MediaType"] isEqualToString: @"TTS"]){
                
                [Tarray addObject:dict];
                [_DataTTSArr addObjectsFromArray:Tarray];
                [dictT setObject:Tarray forKey:@"List"];
                
            }
            
        }
        [_DataArray removeAllObjects];
        if (Rarray.count != 0) {
            
            [_DataArray addObject:dictR];
        }
        if (Aarray.count != 0) {
            
            [_DataArray addObject:dictA];
        }
        if (Sarray.count != 0) {
            
            [_DataArray addObject:dictS];
        }
        if (Tarray.count != 0) {
            
            [_DataArray addObject:dictT];
        }
    }

    [self initTiteBarView];
    [self initScrollerView];
    
}

- (void)initScrollerView{
    
    if ([_label isEqualToString:@"我的喜欢"]) {
        
        //  __weak WTXiangJiangViewController *weakSelf = self;
        contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, 64 + POINT_Y(90), K_Screen_Width, K_Screen_Height - 64 - POINT_Y(90))];
        contentScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:contentScrollView];
        
        // 防止scroll上下拖动
        contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 5, 0);
        contentScrollView.pagingEnabled = YES;
        contentScrollView.bounces = NO;
        contentScrollView.contentOffset = CGPointMake(0, 0);
        contentScrollView.delegate = self;
        
        for (int i = 0; i < 5; i ++) {
            
            if (i == 0) {
                
                AllViewController *wtallVC = [[AllViewController alloc] init];
                [self addChildViewController:wtallVC];
                [contentScrollView addSubview:wtallVC.view];
                [wtallVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(@0);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else if (i == 1) {
                
                ZhuanJiViewController *wtzhuanjiVC = [[ZhuanJiViewController alloc] init];
               
                [self addChildViewController:wtzhuanjiVC];
                [contentScrollView addSubview:wtzhuanjiVC.view];
                [wtzhuanjiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else if (i == 2){
                
                ShengYinViewController *wtSYVC = [[ShengYinViewController alloc] init];
                //  skXiaoZuVC.userArr = skuserArr;
                [self addChildViewController:wtSYVC];
                [contentScrollView addSubview:wtSYVC.view];
                [wtSYVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else if (i == 3) {
                
                DianTaiViewController *wtDTVC = [[DianTaiViewController alloc] init];
                //  skXiaoZuVC.userArr = skuserArr;
                [self addChildViewController:wtDTVC];
                [contentScrollView addSubview:wtDTVC.view];
                [wtDTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else{
                
                TTSViewController *wtttsVC = [[TTSViewController alloc] init];
                //  skXiaoZuVC.userArr = skuserArr;
                [self addChildViewController:wtttsVC];
                [contentScrollView addSubview:wtttsVC.view];
                [wtttsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }
        }
    }else if ([_label isEqualToString:@"播放历史"]){
        
        //  __weak WTXiangJiangViewController *weakSelf = self;
        contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, 64 + POINT_Y(90), K_Screen_Width, K_Screen_Height - 64 - POINT_Y(90))];
        contentScrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:contentScrollView];
        
        // 防止scroll上下拖动
        contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 5, 0);
        contentScrollView.pagingEnabled = YES;
        contentScrollView.bounces = NO;
        contentScrollView.contentOffset = CGPointMake(0, 0);
        contentScrollView.delegate = self;
        
        for (int i = 0; i < 4; i ++) {
            
            if (i == 0) {
                
                AllViewController *wtallVC = [[AllViewController alloc] init];
                wtallVC.dataAllArray = _DataArray;
                [self addChildViewController:wtallVC];
                [contentScrollView addSubview:wtallVC.view];
                [wtallVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(@0);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else if (i == 1){
                
                ShengYinViewController *wtSYVC = [[ShengYinViewController alloc] init];
                wtSYVC.dataSYLSArr = _DataShengYinArr;
                [self addChildViewController:wtSYVC];
                [contentScrollView addSubview:wtSYVC.view];
                [wtSYVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else if (i == 2) {
                
                DianTaiViewController *wtDTVC = [[DianTaiViewController alloc] init];
                wtDTVC.dataDTLSArr = _DataDianTaiArr;
                [self addChildViewController:wtDTVC];
                [contentScrollView addSubview:wtDTVC.view];
                [wtDTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }else{
                
                TTSViewController *wtttsVC = [[TTSViewController alloc] init];
                wtttsVC.dataTTSLSArr = _DataTTSArr;
                [self addChildViewController:wtttsVC];
                [contentScrollView addSubview:wtttsVC.view];
                [wtttsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.width.equalTo(contentScrollView);
                    make.height.equalTo(contentScrollView);
                    make.left.mas_equalTo(K_Screen_Width * i);
                    make.centerY.equalTo(contentScrollView);
                }];
                
            }
        }
        
        
    }
    
}

- (void)initTiteBarView{
    
    if ([_label isEqualToString:@"我的喜欢"]) {
    
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, POINT_Y(90))];
        titleView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:titleView];
        
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.tag = 1221;
        [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(titleView);
            make.top.equalTo(titleView);
        }];
        leftBtn.selected = YES;
        
        UIButton *leftBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn1.tag = 1222;
        [leftBtn1 setTitle:@"专辑" forState:UIControlStateNormal];
        [leftBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        leftBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:leftBtn1];
        [leftBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(leftBtn.mas_right);
            make.top.equalTo(titleView);
        }];
        
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        centerBtn.tag = 1223;
        [centerBtn setTitle:@"声音" forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(leftBtn1.mas_right);
            make.top.equalTo(titleView);
        }];
        
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = 1224;
        [rightBtn setTitle:@"电台" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(centerBtn.mas_right);
            make.top.equalTo(titleView);
        }];
        
        UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn1.tag = 1225;
        [rightBtn1 setTitle:@"TTS" forState:UIControlStateNormal];
        [rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        rightBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:rightBtn1];
        [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(rightBtn.mas_right);
            make.top.equalTo(titleView);
        }];
        
        
        barLineImageView = [[UIImageView alloc] init];
        barLineImageView.backgroundColor = [UIColor JQTColor];
        barLineImageView.layer.cornerRadius = 2.0;
        [titleView addSubview:barLineImageView];
        [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(6));
            make.centerX.equalTo(leftBtn);
            make.bottom.equalTo(titleView.mas_bottom);
        }];
        
        [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    }else if ([_label isEqualToString:@"播放历史"]) {
        
        titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, POINT_Y(90))];
        titleView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:titleView];
        
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.tag = 1221;
        [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(titleView);
            make.top.equalTo(titleView);
        }];
        leftBtn.selected = YES;
        
        UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        centerBtn.tag = 1222;
        [centerBtn setTitle:@"声音" forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:centerBtn];
        [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(leftBtn.mas_right);
            make.top.equalTo(titleView);
        }];
        
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = 1223;
        [rightBtn setTitle:@"电台" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(centerBtn.mas_right);
            make.top.equalTo(titleView);
        }];
        
        UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn1.tag = 1224;
        [rightBtn1 setTitle:@"TTS" forState:UIControlStateNormal];
        [rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rightBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
        rightBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        [titleView addSubview:rightBtn1];
        [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
            make.height.mas_equalTo(POINT_Y(90));
            make.left.equalTo(rightBtn.mas_right);
            make.top.equalTo(titleView);
        }];
        
        
        barLineImageView = [[UIImageView alloc] init];
        barLineImageView.backgroundColor = [UIColor JQTColor];
        barLineImageView.layer.cornerRadius = 2.0;
        [titleView addSubview:barLineImageView];
        [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
            make.height.mas_equalTo(POINT_Y(6));
            make.centerX.equalTo(leftBtn);
            make.bottom.equalTo(titleView.mas_bottom);
        }];
        
        [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    if ([_label isEqualToString:@"我的喜欢"]) {
        /** 首先切换标识条 */
        [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(6));
            make.centerX.equalTo(aBtn);
            make.bottom.equalTo(titleView.mas_bottom);
        }];
        
        aBtn.selected = YES;
        
        UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
        UIButton *leftBtn1 = (UIButton *)[titleView viewWithTag:1222];
        UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1223];
        UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1225];
        UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1224];
        if (aBtn.tag == 1221) {
            
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn1.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
            
        }else if (aBtn.tag == 1222) {
            
            leftBtn.selected = NO;
            rightBtn.selected = NO;
            centerBtn.selected = NO;
            rightBtn1.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
            
        }else if (aBtn.tag == 1223) {
            
            leftBtn.selected = NO;
            rightBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn1.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
        }else if (aBtn.tag == 1224) {
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn1.selected = NO;
            centerBtn.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
        }else if (aBtn.tag == 1225) {
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn.selected = NO;
            centerBtn.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 4, 0);
        }
    }else if ([_label isEqualToString:@"播放历史"]) {
        
        /** 首先切换标识条 */
        [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
            make.height.mas_equalTo(POINT_Y(6));
            make.centerX.equalTo(aBtn);
            make.bottom.equalTo(titleView.mas_bottom);
        }];
        
        aBtn.selected = YES;
        
        UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
        UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1222];
        UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1224];
        UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1223];
        if (aBtn.tag == 1221) {
            
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
            
        }else if (aBtn.tag == 1222) {
            
            leftBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
            
        }else if (aBtn.tag == 1223) {
            
            leftBtn.selected = NO;
            centerBtn.selected = NO;
            rightBtn1.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
        }else if (aBtn.tag == 1224) {
            
            leftBtn.selected = NO;
            rightBtn.selected = NO;
            centerBtn.selected = NO;
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
        }
        
    }
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([_label isEqualToString:@"我的喜欢"]) {
        /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
        if (scrollView == contentScrollView) {
            
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
                make.height.mas_equalTo(POINT_Y(6));
                make.left.mas_equalTo((scrollView.contentOffset.x/5));
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            
            UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
            UIButton *leftBtn1 = (UIButton *)[titleView viewWithTag:1222];
            UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1223];
            UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1224];
            UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1225];
            
            if (scrollView.contentOffset.x == K_Screen_Width) {
                
                leftBtn.selected = NO;
                leftBtn1.selected = YES;
                centerBtn.selected = NO;
                rightBtn.selected = NO;
                rightBtn1.selected = NO;
                
            }else if (scrollView.contentOffset.x == 0){
                
                leftBtn.selected = YES;
                leftBtn1.selected = NO;
                centerBtn.selected = NO;
                rightBtn.selected = NO;
                rightBtn1.selected = NO;
                
            }else if (scrollView.contentOffset.x == K_Screen_Width*2){
                
                leftBtn.selected = NO;
                leftBtn1.selected = NO;
                rightBtn1.selected = NO;
                centerBtn.selected = YES;
                rightBtn.selected = NO;
            }else if (scrollView.contentOffset.x == K_Screen_Width*3){
                
                leftBtn.selected = NO;
                leftBtn1.selected = NO;
                rightBtn1.selected = NO;
                centerBtn.selected = NO;
                rightBtn.selected = YES;
                
            }else if (scrollView.contentOffset.x == K_Screen_Width*4){
                
                leftBtn.selected = NO;
                leftBtn1.selected = NO;
                rightBtn1.selected = YES;
                centerBtn.selected = NO;
                rightBtn.selected = NO;
            }
        }
    }else if ([_label isEqualToString:@"播放历史"]) {
        
        if (scrollView == contentScrollView) {
            
            /** 首先切换标识条 */
            [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/4);
                make.height.mas_equalTo(POINT_Y(6));
                make.left.mas_equalTo((scrollView.contentOffset.x/4));
                make.bottom.equalTo(titleView.mas_bottom);
            }];
            
            UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
            UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1222];
            UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1223];
            UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1224];
            
            if (scrollView.contentOffset.x == K_Screen_Width) {
                
                leftBtn.selected = NO;
                centerBtn.selected = YES;
                rightBtn.selected = NO;
                rightBtn1.selected = NO;
                
            }else if (scrollView.contentOffset.x == 0){
                
                leftBtn.selected = YES;
                centerBtn.selected = NO;
                rightBtn.selected = NO;
                rightBtn1.selected = NO;
                
            }else if (scrollView.contentOffset.x == K_Screen_Width*2){
                
                leftBtn.selected = NO;
                rightBtn1.selected = NO;
                centerBtn.selected = NO;
                rightBtn.selected = YES;
                
            }else if (scrollView.contentOffset.x == K_Screen_Width*3){
                
                leftBtn.selected = NO;
                rightBtn1.selected = YES;
                centerBtn.selected = NO;
                rightBtn.selected = NO;
            }
        }
        
    }
}

//点击跳转到对应部分
- (void)scollerViewChange:(NSNotification *)not {
    if ([_label isEqualToString:@"我的喜欢"]) {
        NSString *str = not.userInfo[@"Str"];
        
        if ([str isEqualToString:@"声音"]) {
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
        }else if ([str isEqualToString:@"专辑"]) {
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
        }else if ([str isEqualToString:@"电台"]){
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
        }else if ([str isEqualToString:@"TTS"]){
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 4, 0);
        }
    }else if ([_label isEqualToString:@"播放历史"]) {
        NSString *str = not.userInfo[@"Str"];
        
        if ([str isEqualToString:@"声音"]) {
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
        }else if ([str isEqualToString:@"电台"]){
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
        }else if ([str isEqualToString:@"TTS"]){
            
            contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
        }
        
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

- (IBAction)cleanBtnClick:(id)sender {
    
    if ([_label isEqualToString:@"播放历史"]){
    
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"清空历史" message:@"是否清空历史记录" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *actiongengxin = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        UIAlertAction *actionquxiao = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            FMDatabase *db = [FMDBTool createDatabaseAndTable:@"BFLS"];
            BOOL isok = [db executeUpdate:@"DELETE FROM BFLS"];
            if (isok) {
                
                NSLog(@"清空历史");
                [_DataArray removeAllObjects];
                [_DataShengYinArr removeAllObjects];
                [_DataDianTaiArr removeAllObjects];
                [_DataTTSArr removeAllObjects];
                
                [self initTiteBarView];
                [self initScrollerView];
                
            }
            
        }];
        
        
        [alert addAction:actiongengxin];
        [alert addAction:actionquxiao];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }else if([_label isEqualToString:@"我的喜欢"]) {
        
        NSLog(@"清空喜欢");
        
    }
    
}
@end
