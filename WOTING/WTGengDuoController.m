//
//  WTGengDuoController.m
//  WOTING
//
//  Created by jq on 2016/12/28.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTGengDuoController.h"

#import "WTPingLunViewController.h"     //评论页
#import "WTZhuanJiViewController.h"     //专辑页
#import "WTJMDViewController.h"         //节目单
#import "WTJieMuViewController.h"       //节目详情
#import "WTDingShiController.h"         //定时关闭
#import "WTLikeListViewController.h"    //我的喜欢 or 播放历史
#import "WTDingYueController.h"         //订阅页
#import "WTJuBaoViewController.h"       //举报页
#import "WTDownLoadViewController.h"    //我的下载页

#import <UShareUI/UShareUI.h>   //分享

@interface WTGengDuoController ()

@end

@implementation WTGengDuoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contentName.text = _dataDict[@"ContentName"];
    if ([[NSString NULLToString:_dataDict[@"ContentFavorite"]] isEqualToString:@"1"]) {
        
        _XiHuanBtn.selected = YES;
        _XiHuanLab.text = @"已喜欢";
    }else {
        
        _XiHuanBtn.selected = NO;
        _XiHuanLab.text = @"喜欢";
    }
    
    //判断是节目单还是去下载界面
    NSString *MediaType = _dataDict[@"MediaType"];
    if ([MediaType isEqualToString:@"AUDIO"]) {
        
        _downLoadLab.text = @"下载";
        _XiaZaiBtn.selected = NO;
        
    }else if ([MediaType isEqualToString:@"RADIO"]) {
        
        _downLoadLab.text = @"节目单";
        _XiaZaiBtn.selected = YES;
        
    }
    
    //判断本地数据库里是否下载该节目
    FMDatabase *fm = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
    // 1.执行查询语句
    FMResultSet *resultSet = [fm executeQuery:@"SELECT * FROM XIAZAI"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[NSString NULLToString:_dataDict[@"ContentId"]] isEqualToString:jsonDict[@"ContentId"]]) {
            
            _XiaZaiBtn.enabled = NO;
        }else {
            
            _XiaZaiBtn.enabled = YES;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    float constant = (K_Screen_Width - (24 *2)-(30*4))/3.0;
    _PaiXuone.constant = 24;
    _PaiXutwo.constant = constant;
    _Paixuthere.constant = constant;
    _PaiXufour.constant = constant;
    _PaiXufive.constant = 24;
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象 、 为显示图片 在加载block里进行分享
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_dataDict[@"ContentName"] descr:_dataDict[@"ContentDescn"] thumImage:image];
        
        //设置网页地址
        shareObject.webpageUrl =_dataDict[@"ContentShareURL"];
        
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
    
    NSString *MediaType = _dataDict[@"MediaType"];
    NSString *ContentId = _dataDict[@"ContentId"];
    NSString *ContentFavorite = _dataDict[@"ContentFavorite"];
    
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

//点击下载
- (IBAction)XiaZaiBtnClick:(id)sender {
    
    if (_XiaZaiBtn.selected) {
        
        WTJMDViewController *WTJieMuVC = [[WTJMDViewController alloc] init];
        
        WTJieMuVC.hidesBottomBarWhenPushed = YES;
        WTJieMuVC.contentID = _dataDict[@"ContentId"];
        [self.navigationController pushViewController:WTJieMuVC animated:YES];
        
    }else {
    
        FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
        
        BOOL isRept = NO;
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
        // 遍历结果，如果重复就不下载
        while ([resultSet next]) {
            
            NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
            if ([_dataDict[@"ContentId"] isEqualToString:jsonDict[@"ContentId"]]){
                
                isRept = YES;
            }
        }
        
        if (!isRept) {
            
            if (_dataDict.count) {
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:_dataDict options:NSJSONWritingPrettyPrinted error:nil];
                NSString *sqlInsert = @"insert into XIAZAI values(?,?,?)";
                BOOL isOk = [db executeUpdate:sqlInsert, _dataDict[@"ContentId"],data ,@"0"];
                if (isOk) {
                    NSLog(@"添加数据成功");
                    //通知下载中
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWEIWANCHENG" object:nil];
                    
                    [self downLoad]; //开始下载
                }
                
            }
            
        }
    }
}

- (void)downLoad{
    
    [[MCDownloadManager defaultInstance] downloadFileWithURL:[NSString NULLToString:_dataDict[@"ContentPlay"]]
                                                    progress:^(NSProgress * _Nonnull downloadProgress, MCDownloadReceipt *receipt) {
                                                        
                                                        
                                                        
                                                    }
                                                 destination:nil
                                                     success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSURL * _Nonnull filePath) {
                                                         
                                                         FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
                                                         
                                                         BOOL isRept = NO;
                                                         FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
                                                         // 遍历结果，如果重复就删除数据
                                                         while ([resultSet next]) {
                                                             
                                                             NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
                                                             NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
                                                             if ([_dataDict[@"ContentPlay"] isEqualToString:jsonDict[@"ContentPlay"]] && [[resultSet stringForColumn:@"XIAZAIBOOL"] isEqualToString:@"0"]){
                                                                 
                                                                 isRept = YES;
                                                             }
                                                         }
                                                         if (isRept) {
                                                            
                                                             BOOL isOk = [db executeUpdate:@"UPDATE XIAZAI SET XIAZAIBOOL = ? WHERE XIAZAINum =?",@"1",_dataDict[@"ContentId"]];
                                                             if (isOk) {
                                                                 NSLog(@"更改数据成功! 😄");
                                                                 
                                                                 [db close];  //关闭数据库
                                                                 
//                                                                 //通知下载完成
//                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWANCHENG" object:nil];
//                                                                 //通知下载中刷新UI
//                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWEIWANCHENG" object:nil];
                                                             }else{
                                                                 NSLog(@"更改数据失败! 💔");
                                                             }
                                                             
                                                         }

                                                     }
                                                     failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
                                                         
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
    
    wtPLVC.ContentID = _dataDict[@"ContentId"];
    wtPLVC.Metype = _dataDict[@"MediaType"];
    
    [self.navigationController pushViewController:wtPLVC animated:YES];
}

//点击节目详情
- (IBAction)JieMuBtnClick:(id)sender {
    
    WTJieMuViewController *WTJieMuVC = [[WTJieMuViewController alloc] init];
    
    WTJieMuVC.hidesBottomBarWhenPushed = YES;
    WTJieMuVC.dataDictJM = _dataDict;
    [self.navigationController pushViewController:WTJieMuVC animated:YES];
}

//点击查看专辑
- (IBAction)ZhuanJiBtnClick:(id)sender {
    
    NSString *ContentId = _dataDict[@"ContentId"];
    
    WTZhuanJiViewController *wtzhuJVC = [[WTZhuanJiViewController alloc] init];
    wtzhuJVC.contentID = ContentId;
    wtzhuJVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtzhuJVC animated:YES];
}

//点击查看主播
- (IBAction)ZhuBoBtnClick:(id)sender {
    
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
    
    WTJBVC.ContentId = _dataDict[@"ContentId"];
    WTJBVC.MediaType = _dataDict[@"MediaType"];
    
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
@end
