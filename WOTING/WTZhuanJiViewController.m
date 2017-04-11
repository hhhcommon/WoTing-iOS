//
//  WTZhuanJiViewController.m
//  WOTING
//
//  Created by jq on 2016/12/19.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZhuanJiViewController.h"

#import "WTPingLunViewController.h"     //评论页
#import "WTJuBaoViewController.h"       //举报页

#import "WTZJTuijianController.h"
#import "WTZJJMController.h"

#import "SKMainScrollView.h"

#import <UShareUI/UShareUI.h>   //分享

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
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [WKProgressHUD popMessage:@"没有查到任何专辑" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
}

//填充界面
- (void)FillInterface {
    
    _NameLab.text = [NSString NULLToString:dataZJDict[@"ContentName"]];
    
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataZJDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    if ([[NSString NULLToString:dataZJDict[@"ContentFavorite"]] isEqualToString:@"0"] || [NSString NULLToString:dataZJDict[@"ContentFavorite"]] == nil) {
        
        _ZJlikeBtn.selected = NO;
    }else{
        
        _ZJlikeBtn.selected = YES;
    }
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


        make.width.equalTo(_titleView.mas_width).with.multipliedBy(1.0/2);
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

//专辑喜欢
- (IBAction)likeBtnClick:(id)sender {
    
    NSString *MediaType = dataZJDict[@"MediaType"];
    NSString *ContentId = dataZJDict[@"ContentId"];
    NSString *ContentFavorite = dataZJDict[@"ContentFavorite"];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    if ([uid isEqualToString:@"0"]||[uid isEqualToString:@""]) {
        
        NSDictionary *parameters;
        
        if ([ContentFavorite isEqualToString:@"0"] || ContentFavorite == nil) {
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",MediaType,@"MediaType",ContentId,@"ContentId",uid,@"UserId",@"1",@"Flag",  nil];
            
        }else {
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",MediaType,@"MediaType",ContentId,@"ContentId",uid,@"UserId",@"0",@"Flag",  nil];
        }
        
        
        NSString *login_Str = WoTing_like;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [WKProgressHUD popMessage:@"添加喜欢成功" inView:nil duration:0.5 animated:YES];
                
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"200"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                [WKProgressHUD popMessage:@"请先登录后再试" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
    }else{
        
        [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
    }
    
    
}
//专辑评论
- (IBAction)commitBtnClick:(id)sender {
    
    WTPingLunViewController *wtPLVC = [[WTPingLunViewController alloc] init];
    
    wtPLVC.hidesBottomBarWhenPushed = YES;
    
    wtPLVC.ContentID = dataZJDict[@"ContentID"];
    wtPLVC.Metype = dataZJDict[@"MediaType"];
    
    [self.navigationController pushViewController:wtPLVC animated:YES];
}
//专辑分享
- (IBAction)shareBtnClick:(id)sender {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

//点击专辑订阅
- (IBAction)dingYueBtnClick:(id)sender {
    
    NSString *ContentId = dataZJDict[@"ContentId"];
    NSString *ContentFavorite = dataZJDict[@"ContentFavorite"];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    if ([uid isEqualToString:@"0"]||[uid isEqualToString:@""]) {
        
        NSDictionary *parameters;
        
        if ([ContentFavorite isEqualToString:@"0"] || ContentFavorite == nil) {
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",ContentId,@"ContentId",uid,@"UserId",@"1",@"Flag",  nil];
            
        }else {
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",ContentId,@"ContentId",uid,@"UserId",@"0",@"Flag",  nil];
        }
        
        
        NSString *login_Str = WoTing_DingYue;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [WKProgressHUD popMessage:@"订阅成功" inView:nil duration:0.5 animated:YES];
                
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"200"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                [WKProgressHUD popMessage:@"请先登录后再试" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
    }else{
        
        [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
    }

}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象 、 为显示图片 在加载block里进行分享
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataZJDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dataZJDict[@"ContentName"] descr:dataZJDict[@"ContentDescn"] thumImage:image];
        
        //设置网页地址
        shareObject.webpageUrl =dataZJDict[@"ContentShareURL"];
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                NSLog(@"************Share fail with error %@*********",error);
            }else{
                NSLog(@"response data is %@",data);
            }
        }];
        
    } ];
    
    
}

- (IBAction)JuBaoBtnClick:(id)sender {
    
    WTJuBaoViewController *juBaoVC = [[WTJuBaoViewController alloc] init];
    
    juBaoVC.MediaType = dataZJDict[@"MediaType"];
    juBaoVC.ContentId = dataZJDict[@"ContentId"];
    
    [self.navigationController pushViewController:juBaoVC animated:YES];
}
@end
