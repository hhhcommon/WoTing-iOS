//
//  WTGengDuoDianTaiController.m
//  WOTING
//
//  Created by jq on 2017/4/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTGengDuoDianTaiController.h"

#import "WTPingLunViewController.h"     //评论页
#import "WTZhuanJiViewController.h"     //专辑页
#import "WTJMDViewController.h"         //节目单
#import "WTJieMuViewController.h"       //节目详情
#import "WTDingShiController.h"         //定时关闭
#import "WTLikeListViewController.h"    //我的喜欢 or 播放历史
#import "WTDingYueController.h"         //订阅页
#import "WTJuBaoViewController.h"       //举报页
#import "WTDownLoadViewController.h"    //我的下载页
#import "WTZhuBoController.h"           //主播页

#import <UShareUI/UShareUI.h>   //分享

@interface WTGengDuoDianTaiController (){
    
    NSDictionary *dataGengDict; //数据源
}

@end

@implementation WTGengDuoDianTaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataGengDict = [[NSDictionary alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creaetContentGengDuo:) name:@"GENGDUOCHANGER" object:nil];
    
    NSNotification *notnill = nil;
    [self creaetContentGengDuo:notnill];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    float constant = (K_Screen_Width -(65*4) - 20)/3.0;
    _PaiXuone.constant = 10;
    _PaiXutwo.constant = constant;
    _Paixuthere.constant = constant;
    _PaiXufour.constant = constant;
    _PaiXufive.constant = 10;
    
}

- (void)creaetContentGengDuo:(NSNotification *)not{
    
    if (not == nil) {
        
        dataGengDict = _dataDict;
    }else{
        
        dataGengDict = not.userInfo;
    }
    
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    if ([uid isEqualToString:@"0"]||[uid isEqualToString:@""]) {
        
        _DingYueBtn.hidden = YES;
        _WDXiHuan.hidden = YES;
    }else {
        
        _DingYueBtn.hidden = NO;
        _WDXiHuan.hidden = NO;
    }
    
    _contentName.text = dataGengDict[@"ContentName"];
    _XiaZaiBtn.enabled = NO;
    
    if ([[NSString NULLToString:dataGengDict[@"ContentFavorite"]] isEqualToString:@"1"]) {
        
        _XiHuanBtn.selected = YES;
        
    }else {
        
        _XiHuanBtn.selected = NO;
        
    }
    
}


- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象 、 为显示图片 在加载block里进行分享
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataGengDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:dataGengDict[@"ContentName"] descr:dataGengDict[@"ContentDescn"] thumImage:image];
        
        //设置网页地址
        shareObject.webpageUrl =dataGengDict[@"ContentShareURL"];
        
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

//点击喜欢
- (IBAction)XiHuanBtnClick:(id)sender {
    
    NSString *MediaType = dataGengDict[@"MediaType"];
    NSString *ContentId = dataGengDict[@"ContentId"];
    NSString *ContentFavorite = dataGengDict[@"ContentFavorite"];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters;
    
    if ([ContentFavorite isEqualToString:@"0"]) {
        
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
}

//点击分享
- (IBAction)FenXiangBtnClick:(id)sender {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];
}

//点击评论
- (IBAction)PingLunBtnClick:(id)sender {
    
    WTPingLunViewController *wtPLVC = [[WTPingLunViewController alloc] init];
    
    wtPLVC.hidesBottomBarWhenPushed = YES;
    
    wtPLVC.ContentID = dataGengDict[@"ContentId"];
    wtPLVC.Metype = dataGengDict[@"MediaType"];
    
    [self.navigationController pushViewController:wtPLVC animated:YES];
}

//点击节目详情
- (IBAction)JieMuBtnClick:(id)sender {
    
    WTJieMuViewController *WTJieMuVC = [[WTJieMuViewController alloc] init];
    
    WTJieMuVC.hidesBottomBarWhenPushed = YES;
    WTJieMuVC.dataDictJM = dataGengDict;
    [self.navigationController pushViewController:WTJieMuVC animated:YES];
}

//点击节目单
- (IBAction)ZhuanJiBtnClick:(id)sender {
    
    WTJMDViewController *WTJieMuVC = [[WTJMDViewController alloc] init];
    
    WTJieMuVC.hidesBottomBarWhenPushed = YES;
    WTJieMuVC.contentID = dataGengDict[@"ContentId"];
    [self.navigationController pushViewController:WTJieMuVC animated:YES];
    
}

//点击查看主播
- (IBAction)ZhuBoBtnClick:(id)sender {
    //[12]	(null)	@"ContentPersons" : @"1 element" [1]	(null)	@"PerId" : (no summary)
    
    if ([dataGengDict[@"ContentPersons"][0][@"PerId"] isKindOfClass:[NSNull class]]) {
        
        [WKProgressHUD popMessage:@"该节目暂无主播信息" inView:nil duration:0.5 animated:YES];
    }else{
        
        WTZhuBoController *wtZBVC = [[WTZhuBoController alloc] init];
        wtZBVC.dataDefDict = dataGengDict;
        [self.navigationController pushViewController:wtZBVC animated:YES];
        
    }
    
}

//点击定时关闭
- (IBAction)DingShiBtnClick:(id)sender {
    
    WTDingShiController *WTDSVC = [[WTDingShiController alloc] init];
    
    WTDSVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:WTDSVC animated:YES];
}

//点击举报
- (IBAction)JuBaoBtnClick:(id)sender {
    
    WTJuBaoViewController *WTJBVC = [[WTJuBaoViewController alloc] init];
    
    WTJBVC.ContentId = dataGengDict[@"ContentId"];
    WTJBVC.MediaType = dataGengDict[@"MediaType"];
    
    WTJBVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:WTJBVC animated:YES];
}

//点击播放历史
- (IBAction)BoFangHistoryBtnClick:(id)sender {
    
    WTLikeListViewController *WTlikeVC = [[WTLikeListViewController alloc] init];
    WTlikeVC.label = @"播放历史";
    WTlikeVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:WTlikeVC animated:YES];
}

//点击订阅
- (IBAction)DingYueBtnClick:(id)sender {
    
    WTDingYueController *WTdingYeVC = [[WTDingYueController alloc] init];
    
    WTdingYeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:WTdingYeVC animated:YES];
}

//我的下载
- (IBAction)WoDeXiaZaiBtnClick:(id)sender {
    
    WTDownLoadViewController *wtDownLoadVC = [[WTDownLoadViewController alloc] init];
    
    wtDownLoadVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtDownLoadVC animated:YES];
}

//点击查看我的喜欢
- (IBAction)WoDeXiHuanBtnClick:(id)sender {
    
    WTLikeListViewController *WTlikeVC = [[WTLikeListViewController alloc] init];
    WTlikeVC.label = @"我的喜欢";
    WTlikeVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:WTlikeVC animated:YES];
}

//返回
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
