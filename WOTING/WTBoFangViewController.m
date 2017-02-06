//
//  WTBoFangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "WTPingLunViewController.h"     //评论页
#import "WTZhuanJiViewController.h"     //专辑页
#import "WTGengDuoController.h"         //更多页

#import "WTBoFangTableViewCell.h"   //节目, 电台格式cell
#import "WTLikeCell.h"      //专辑格式cell
#import "WTBoFangCell.h"
#import "WTBoFangJMCell.h"
#import "WTBoFangXQCell.h"
//#import "WTBoFangView.h"
#import "WTMoveView.h"      //更多view
#import "WTSearchView.h"    //语音搜索
#import "WTBoFangModel.h"
#import "JQMusicTool.h"


#import <UShareUI/UShareUI.h>   //分享

@interface WTBoFangViewController ()<UITableViewDelegate, UITableViewDataSource,WTBoFangViewDelegate,WTBoFangJMCellDelegate, WTBoFangXQCellDelegate,WTMoveViewDelegate, AVAudioPlayerDelegate>{
    
    NSMutableArray  *dataBFArray;
    
    NSString        *urlStr;
    
    NSInteger       changPag;   //判断是否从别的页面传过的值
    NSString        *SearchStr; //接受传过来的值
    
    UIView          *blackView; //蒙板
    WTMoveView      *MoveView;  //更多view
    WTSearchView    *YuyinView; //语音view
    
    NSInteger       BoFangXQ;   //详情cell的高度
    NSInteger       BFXQdelegate; //传过来的值
}

@property (nonatomic ,strong) AVPlayer   *player;
//@property (nonatomic, strong) WTBoFangView   *headerV;
@property (nonatomic, strong) WTBoFangCell   *headerV;
@property(assign, nonatomic)NSInteger musicIndex;//当前播放音乐索引
@property(strong,nonatomic) NSMutableArray *musics;//音乐数据

@end

@implementation WTBoFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    changPag = 0;
    _musicIndex = 0;
    BoFangXQ = 0;
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewAndData:) name:@"TABLEVIEWCLICK" object:nil];
    
    dataBFArray = [NSMutableArray arrayWithCapacity:0];
    _musics = [[NSMutableArray alloc] init];
    
    _JQtableView.delegate = self;
    _JQtableView.dataSource = self;
    
    _JQtableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
    [self registerTabViewCell];
    

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 上拉加载更多 */
    _JQtableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveData)];
}

//接受到了传过来的数据
- (void)reloadTableViewAndData:(NSNotification *)nt {
    
    NSDictionary *dataDict = nt.userInfo;
    [dataBFArray removeAllObjects];
    [dataBFArray addObject:dataDict];
    
    SearchStr = dataDict[@"ContentName"];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",SearchStr,@"SearchStr",@"2",@"Page",@"0",@"PageType",  nil];
    
    NSString *login_Str = WoTing_searchBy;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            
            [_musics removeAllObjects];
            [dataBFArray addObjectsFromArray: ResultList[@"List"]];
            
            for (NSDictionary *dict in dataBFArray) {
                
                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                [_musics addObject:model];
            }
            
            changPag = 1;
            [_JQtableView.mj_footer resetNoMoreData];
            [_JQtableView reloadData];
            [self playMusic];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1011"]) {
            
            [_musics removeAllObjects];
            
            for (NSDictionary *dict in dataBFArray) {
                
                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                [_musics addObject:model];
            }
            [_JQtableView reloadData];
            [self playMusic];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_JQtableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];

    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [_JQtableView registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
    
    UINib *BoFangNib = [UINib nibWithNibName:@"WTBoFangCell" bundle:nil];
    
    [_JQtableView registerNib:BoFangNib forCellReuseIdentifier:@"cellIDB"];
    
    UINib *BoFangJMNib = [UINib nibWithNibName:@"WTBoFangJMCell" bundle:nil];
    
    [_JQtableView registerNib:BoFangJMNib forCellReuseIdentifier:@"cellIDJM"];
    
    UINib *BoFangXQNib = [UINib nibWithNibName:@"WTBoFangXQCell" bundle:nil];
    
    [_JQtableView registerNib:BoFangXQNib forCellReuseIdentifier:@"cellIDXQ"];
}

//网络请求
- (void)loadData {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",@"0",@"PageType",@"10",@"PageSize",  nil];
    
    NSString *login_Str = WoTing_MainPage;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataBFArray removeAllObjects];
            [dataBFArray addObjectsFromArray: ResultList[@"List"]];
            for (NSDictionary *dict in ResultList[@"List"]) {
                
                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                [_musics addObject:model];
            }
           
            [_JQtableView reloadData];
            [self playMusic];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

//加载更多数据
- (void)loadMoveData {
    
    if (changPag == 0) {
        
        static NSInteger page = 2;
        NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",@"0",@"PageType",@"10",@"PageSize",  nil];
        
        NSString *login_Str = WoTing_MainPage;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            [_JQtableView.mj_footer endRefreshing];
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                NSDictionary *ResultList = resultDict[@"ResultList"];
                
                [dataBFArray addObjectsFromArray: ResultList[@"List"]];
                [_musics removeAllObjects];
                
                for (NSDictionary *dict in dataBFArray) {
                    
                    WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                    
                    [_musics addObject:model];
                }
                
                [_JQtableView reloadData];
        
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1011"]){
                
                [_JQtableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } fail:^(NSError *error) {
            
            [_JQtableView.mj_footer endRefreshing];
            
        }];

        page++;
    }else {
        
        static NSInteger page = 3;
        NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",uid,@"UserId",SearchStr,@"SearchStr",@"0",@"PageType",  nil];
        
        NSString *login_Str = WoTing_searchBy;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            [_JQtableView.mj_footer endRefreshing];
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                NSDictionary *ResultList = resultDict[@"ResultList"];
                
                [dataBFArray addObjectsFromArray: ResultList[@"List"]];
                [_musics removeAllObjects];
                
                for (NSDictionary *dict in dataBFArray) {
                    
                    WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                    
                    [_musics addObject:model];
                }
                
                [_JQtableView reloadData];
                
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1011"]){
                
                [_JQtableView.mj_footer endRefreshingWithNoMoreData];
            }
            
        } fail:^(NSError *error) {
            
            [_JQtableView.mj_footer endRefreshing];
            
        }];
        
        page++;
        
    }
}

#pragma mark 播放工具条的代理
-(void)playerToolBar:(WTBoFangCell *)toolbar btnClickWithType:(BtnType)btnType{
    //实现这个播放，把播放的操作放在一个工具类
    switch (btnType) {
        case BtnTypePlay://播放

            [[JQMusicTool sharedJQMusicTool] play];
            break;
        case BtnTypePause://暂停
            
            [[JQMusicTool sharedJQMusicTool] pause];
            break;
        case BtnTypePrevious://上一首
            
            [self previous];
            break;
        case BtnTypeNext://下一首
            
            [self next];
            break;
        case BtnTypeLike://点击喜欢
            
           // [WKProgressHUD popMessage:@"点击喜欢" inView:nil duration:0.5 animated:YES];
            [self  addLike];
            break;
        case BtnTypeDownLoad://点击下载
            
            [WKProgressHUD popMessage:@"节目进入下载任务列表" inView:nil duration:0.5 animated:YES];
            [self DownLoad];
            break;
        case BtnTypeShare://点击分享
            
            [self ShareWT];
            break;
        case BtnTypeCommit://点击评论
            
            [self Commits];
            break;
        case BtnTypeMore://点击更多
            
            [self MoveBtn];
            break;
        case BtnTypeYuYin://点击语音搜索
            
            [self YuYin];
            break;
            
    }
}

#pragma mark 点击语音搜索
- (void)YuYin {
    
    //蒙板
    if (!blackView) {
        
        blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height + 300)];
        [self.view addSubview:blackView];
    }
    blackView.hidden = NO;
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    blackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewtap:)];
    [blackView addGestureRecognizer:tap];
    
    //更多View
    if (!YuyinView) {
        
        YuyinView = [[WTSearchView alloc] initWithFrame:CGRectMake(0, K_Screen_Height, K_Screen_Width, 250)];
        YuyinView.userInteractionEnabled = YES;
        YuyinView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Viewtap)];
        [YuyinView addGestureRecognizer:tap];
        [blackView addSubview:YuyinView];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        YuyinView.frame = CGRectMake(0, K_Screen_Height - 250, K_Screen_Width, 250);
    }];
    
}

#pragma mark 点击更多
- (void)MoveBtn {
    //蒙板
    if (!blackView) {
        
        blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height + 300)];
        [self.view addSubview:blackView];
    }
    blackView.hidden = NO;
    blackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    blackView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blackViewtap:)];
    [blackView addGestureRecognizer:tap];
    
    //更多View
    if (!MoveView) {
        
        MoveView = [[WTMoveView alloc] initWithFrame:CGRectMake(0, K_Screen_Height, K_Screen_Width, 350)];
        MoveView.userInteractionEnabled = YES;
        MoveView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Viewtap)];
        [MoveView addGestureRecognizer:tap];
        [blackView addSubview:MoveView];
    }

    [UIView animateWithDuration:0.5 animations:^{
        MoveView.frame = CGRectMake(0, K_Screen_Height - 390, K_Screen_Width, 390);
    }];
}
- (void)Viewtap {
}
//MoveViewDelegate
- (void)WTMoveViewTap:(UITapGestureRecognizer *)tap{
    
    UIView *view = tap.view;
    if (view.tag == 0) {

        WTBoFangModel *model = _musics[_musicIndex];
        NSString *ContentId = model.ContentId;
        
        WTZhuanJiViewController *wtzhuJVC = [[WTZhuanJiViewController alloc] init];
        wtzhuJVC.contentID = ContentId;
        wtzhuJVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtzhuJVC animated:YES];
    }else if (view.tag == 1){
        
        [WKProgressHUD popMessage:@"查看主播" inView:nil duration:0.5 animated:YES];
    }else if (view.tag == 2){
        
        [WKProgressHUD popMessage:@"播放历史" inView:nil duration:0.5 animated:YES];
    }else {
        
        [WKProgressHUD popMessage:@"定时关闭" inView:nil duration:0.5 animated:YES];
    }
}


#pragma mark 点击下载
- (void)DownLoad {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIDICT" object:nil userInfo:dataBFArray[_musicIndex]];
    
}

#pragma mark 点击喜欢
- (void)addLike {
    
    WTBoFangModel *model = _musics[_musicIndex];
    NSString *MediaType = model.MediaType;
    NSString *ContentId = model.ContentId;
    NSString *ContentFavorite = model.ContentFavorite;
    
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
        
        [_JQtableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"添加成功" inView:nil duration:0.5 animated:YES];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"请先登录后再试" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark 点击评论
- (void)Commits {
    
    WTBoFangModel *model = _musics[_musicIndex];
    

    WTPingLunViewController *wtPLVC = [[WTPingLunViewController alloc] init];
    
    wtPLVC.hidesBottomBarWhenPushed = YES;
    
    wtPLVC.ContentID = model.ContentId;
    wtPLVC.Metype = model.MediaType;
    
    [self.navigationController pushViewController:wtPLVC animated:YES];

}
//- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
//{
//    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
//        UMSocialUserInfoResponse *userinfo =result;
//        NSString *message = [NSString stringWithFormat:@"name: %@\n icon: %@\n gender: %@\n",userinfo.name,userinfo.iconurl,userinfo.gender];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UserInfo"
//                                                        message:message
//                                                       delegate:nil
//                                              cancelButtonTitle:NSLocalizedString(@"确定", nil)
//                                              otherButtonTitles:nil];
//        [alert show];
//    }];
//}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    WTBoFangModel *model = _musics[_musicIndex];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象 、 为显示图片 在加载block里进行分享
    UIImageView *imageV = [[UIImageView alloc] init];
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:model.ContentImg]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:model.ContentName descr:model.ContentDescn thumImage:image];
        
        //设置网页地址
        shareObject.webpageUrl =model.ContentShareURL;
        
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
#pragma mark 点击分享
- (void)ShareWT {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_WechatSession)]];
    
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];

}


#pragma mark 播放上一首
-(void)previous{
    if (self.musicIndex == 0) {//第一首
        self.musicIndex = self.musics.count - 1;
    }else{
        self.musicIndex --;
    }
    
    [self playMusic];
}

#pragma mark 播放下一首
-(void)next{
    
    //1.更改播放的索引
    if (self.musicIndex == self.musics.count - 1) {//最后条
        self.musicIndex = 0;
    }else{
        self.musicIndex ++;
    }
    
    
    [self playMusic];
}

-(void)playMusic{
    
    //2.重新初始化一个 "播放器"
    [[JQMusicTool sharedJQMusicTool] prepareToPlayWithMusic:self.musics[self.musicIndex]];
    
    //3.更改 “播放器工具条” 的数据
    self.headerV.playingMusic = self.musics[self.musicIndex];
    
    //4.播放
    if (self.headerV.isPlaying) {
        
        [[JQMusicTool sharedJQMusicTool] play];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - 点击蒙板
- (void)blackViewtap:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.5 animations:^{
        MoveView.frame = CGRectMake(0, K_Screen_Height , K_Screen_Width, 300);
        YuyinView.frame = CGRectMake(0, K_Screen_Height, K_Screen_Width, 250);
    }];
    
    blackView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - WTBoFangXQCell delegate
- (void)ChangeHeight:(NSInteger)integer {
    
    BFXQdelegate = integer - 21;
}

#pragma mark - WTBoFangJMCell delegeta
-(void)XianShiBtnClick:(UIButton *)btn {
    
    if (BoFangXQ == 0) {
        
        BoFangXQ = 160 + BFXQdelegate;
    }else {
        
        BoFangXQ = 0;
    }
    
    [self.JQtableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 3;
    }else {
        
        return dataBFArray.count;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            static NSString *cellID = @"cellIDB";
            
            WTBoFangCell *cell = (WTBoFangCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            _headerV = cell;
            cell.delegate = self;
            
            return cell;
            
        }else if (indexPath.row == 1){
            
            static NSString *cellID = @"cellIDJM";
            
            WTBoFangJMCell *cell = (WTBoFangJMCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            cell.delegate = self;
            
            return cell;
            
            
        }else {
            
            static NSString *cellID = @"cellIDXQ";
            
            WTBoFangXQCell *cell = (WTBoFangXQCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            cell.delegate = self;
            
            if (_musics && _musics.count != 0) {
                
                WTBoFangModel *model = _musics[_musicIndex];
                
                [cell setDictWithCell:model];
            }
            if (BoFangXQ == 0) {
                
                cell.hidden = YES;
            }
            
            return cell;
            
        }

        
    }else {
        
        if ([dataBFArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            static NSString *cellID = @"cellIDL";
            
            WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            
            NSDictionary *dict = dataBFArray[indexPath.row];
            [cell setCellWithDict:dict];
            
            
            return cell;
        }else {
        
            static NSString *cellID = @"cellID";
            
            WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
          
            NSDictionary *dict = dataBFArray[indexPath.row];
            [cell setCellWithDict:dict];

            
            return cell;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 0.00000000000001;
    }else {
        
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00000000000000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0;
    }else {
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *labeltitle = [[UILabel alloc] init];
        labeltitle.text = @"相关推荐";
        labeltitle.font = [UIFont boldSystemFontOfSize:15];
        labeltitle.textColor = [UIColor skTitleCenterBlackColor];
        [view addSubview:labeltitle];
        
        [labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
        }];
        
        return view;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 280;
        }else if (indexPath.row == 1){
            
            return 44;
        }else{
            
            return BoFangXQ;
        }
        
    }else {
    
        return 70;
    }

    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        
        
        
    }else {
    
        if ([dataBFArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];

            wtZJVC.hidesBottomBarWhenPushed = YES;
            wtZJVC.contentID = [NSString NULLToString:dataBFArray[indexPath.row][@"ContentId"]] ;
            [self.navigationController pushViewController:wtZJVC animated:YES];
            
        }else{
        
            //如果cell处于显示状态， 使其隐藏
            if (BoFangXQ != 0) {
                
               [self XianShiBtnClick:nil];
            }
            
            self.musicIndex = indexPath.row;
            //播放音乐
            [self playMusic];
        }
        
    }
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

@end
