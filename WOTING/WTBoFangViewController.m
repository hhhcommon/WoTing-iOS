//
//  WTBoFangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "WTNewsViewController.h"
#import "WTSearchViewController.h"

#import "WTPingLunViewController.h"     //评论页
#import "WTZhuanJiViewController.h"     //专辑页
#import "WTGengDuoController.h"         //更多页
#import "WTGengDuoDianTaiController.h"  //更多电台页

#import "WTLikeListViewController.h"    //喜欢或播放历史界面
#import "WTDingShiController.h"         //定时关闭
#import "WTJMDViewController.h"       //节目单

#import "WTBoFangTableViewCell.h"   //节目, 电台格式cell
#import "WTLikeCell.h"      //专辑格式cell
#import "WTDianTaiTableViewCell.h"  //电台样式cell
#import "WTBoFangCell.h"
#import "WTBoFangJMCell.h"
#import "WTBoFangXQCell.h"
//#import "WTBoFangView.h"
#import "WTMoveView.h"      //更多view
#import "WTSearchView.h"    //语音搜索
#import "WTBoFangModel.h"
#import "JQMusicTool.h"

#import "JSDownLoadManager.h"   //下载器


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
    
    UIImageView     *BoFangimgV;
    long            BoFangDH;   //播放动画判断
    BOOL            isBegin;    //判断播放状态还是暂停状态
    
    WTBoFangCell    *bofangCell;
    
    NSInteger       page;       //数据加载更多请求&
    NSInteger       pageSearch; //数据Search加载更多
}

@property (nonatomic ,strong) AVPlayer   *player;
//@property (nonatomic, strong) WTBoFangView   *headerV;
@property (nonatomic, strong) WTBoFangCell   *headerV;
@property(assign, nonatomic)NSInteger musicIndex;//当前播放音乐索引
@property(strong,nonatomic) NSMutableArray *musics;//音乐数据

@property (nonatomic, strong) JSDownLoadManager *manager;//下载器

@end

@implementation WTBoFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
    changPag = 0;
    _musicIndex = 0;
    BoFangXQ = 0;
    BoFangDH = 0;
    page = 2;
    pageSearch = 3;
    //跳转过来的新数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewAndData:) name:@"TABLEVIEWCLICK" object:nil];
    
    //监听是否语音搜索完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(YUYinNotification) name:@"YUYINNOTIFICATION" object:nil];
    
    //监听是否是播放状态
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginbtnYes) name:@"BRGINBTNYES" object:nil];
    //监听播放动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boFangDongHua) name:@"BOFANGDONGHUA" object:nil];
    //监听暂停动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zanTingDongHua) name:@"ZANTINGDONGHUA" object:nil];
    
    dataBFArray = [NSMutableArray arrayWithCapacity:0];
    _musics = [[NSMutableArray alloc] init];
    
    _JQtableView.delegate = self;
    _JQtableView.dataSource = self;
    
    _JQtableView.tableFooterView = [[UIView alloc] init];
    
    [self loadData];
    [self registerTabViewCell];
    
    bofangCell = [_JQtableView dequeueReusableCellWithIdentifier:@"cellIDB"];
    
    
    _JQtableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveData)];
    _JQtableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataMove)];
    
}

//语音搜索结束
- (void)YUYinNotification {
    
    [UIView animateWithDuration:0.5 animations:^{
        YuyinView.frame = CGRectMake(0, K_Screen_Height, K_Screen_Width, 250);
    }];
    
    blackView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 上拉加载更多 */
    
}

//接受到了传过来的数据
- (void)reloadTableViewAndData:(NSNotification *)nt {
    self.musicIndex = 0;
    BoFangDH = 0;
    [self beginbtnYes]; //保存播放历史
    
    NSDictionary *dataDict = nt.userInfo;
    [dataBFArray removeAllObjects];
    
    if (dataDict[@"ContentName"]) {
        
        [dataBFArray addObject:dataDict];
        [_musics removeAllObjects];
        for (NSDictionary *dict in dataBFArray) {
            
            WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
            [_musics addObject:model];
        }
        
        bofangCell.playing = YES;
        bofangCell.beginBtn.selected = YES;
        changPag = 1;
        [_JQtableView reloadData];
        [self playMusic];
        [[JQMusicTool sharedJQMusicTool] play];
        //改变图片
        NSDictionary *dataDict = dataBFArray[_musicIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];   //开始旋转
        //还原动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RESTORETIME" object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
        
        SearchStr = dataDict[@"ContentName"];
    }else {     //语音搜索传过来的字典
        
        SearchStr = dataDict[@"Search"];
    }
    
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
            
//            for (NSDictionary *dict in dataBFArray) {
//                
//                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
//                [_musics addObject:model];
//            }
//            
//            changPag = 1;
//            [_JQtableView.mj_footer resetNoMoreData];
//            
//            [_JQtableView reloadData];
//            [self playMusic];
//            
//            //改变图片
//            NSDictionary *dataDict = dataBFArray[_musicIndex];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1011"]) {
            
//            [_musics removeAllObjects];
//            
//            for (NSDictionary *dict in dataBFArray) {
//                
//                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
//                [_musics addObject:model];
//            }
//            [_JQtableView reloadData];
//            [self playMusic];
//            
//            //改变图片
//            NSDictionary *dataDict = dataBFArray[self.musicIndex];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
        }
        
    } fail:^(NSError *error) {
        
        
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
    
    UINib *BoFangDTNib = [UINib nibWithNibName:@"WTDianTaiTableViewCell" bundle:nil];
    
    [_JQtableView registerNib:BoFangDTNib forCellReuseIdentifier:@"cellIDT"];
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
    NSLog(@"%@", parameters);
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [_JQtableView.mj_footer resetNoMoreData];   //如果全部了，恢复控件
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataBFArray removeAllObjects];
            [dataBFArray addObjectsFromArray: ResultList[@"List"]];
            for (NSDictionary *dict in ResultList[@"List"]) {
                
                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                [_musics addObject:model];
            }
           
            [_JQtableView reloadData];
            [self playMusic];
            
            //改变图片
            NSDictionary *dataDict = dataBFArray[_musicIndex];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

//加载更多数据(下拉)

- (void)loadDataMove {
    
    if (changPag == 0) {
        
        
        NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",@"0",@"PageType",@"10",@"PageSize",  nil];
        
        NSString *login_Str = WoTing_MainPage;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            [_JQtableView.mj_header endRefreshing];
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                NSDictionary *ResultList = resultDict[@"ResultList"];
                
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    [dataBFArray insertObject:dict atIndex:0];
                    
                }
                [_musics removeAllObjects];
                
                for (NSDictionary *dict in dataBFArray) {
                    
                    WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                    
                    [_musics addObject:model];
                }
                
                [_JQtableView reloadData];
                
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1011"]){
                
                [_JQtableView.mj_footer endRefreshingWithNoMoreData];   //显示全部加载
            }
            
        } fail:^(NSError *error) {
            
            [_JQtableView.mj_header endRefreshing];
            
        }];
        
        page++;
    }else {
        
        NSString *pageStr = [NSString stringWithFormat:@"%ld",pageSearch];
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",uid,@"UserId",SearchStr,@"SearchStr",@"0",@"PageType",  nil];
        
        NSString *login_Str = WoTing_searchBy;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            [_JQtableView.mj_header endRefreshing];
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                NSDictionary *ResultList = resultDict[@"ResultList"];
                
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    [dataBFArray insertObject:dict atIndex:0];
                    
                }
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
            
            [_JQtableView.mj_header endRefreshing];
            
        }];
        
        pageSearch++;
        
    }

}

//加载更多数据(上拉)
- (void)loadMoveData {
    
    if (changPag == 0) {
        
        
        NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",@"0",@"PageType",@"10",@"PageSize",  nil];
        
        NSString *login_Str = WoTing_MainPage;
        NSLog(@"%@", parameters);
        
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
                
                [_JQtableView.mj_footer endRefreshingWithNoMoreData];   //显示全部加载
            }
            
        } fail:^(NSError *error) {
            
            [_JQtableView.mj_footer endRefreshing];
            
        }];

        page++;
    }else {

        NSString *pageStr = [NSString stringWithFormat:@"%ld",pageSearch];
        
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
        
        pageSearch++;
        
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
            
        
            break;
        case BtnTypeDownLoad://点击下载
            
           
            break;
        case BtnTypeJMD://进入节目单

            [self JinJMD];
            break;
        case BtnTypeShare://点击分享
            
           
            break;
        case BtnTypeCommit://点击评论
            
         
            break;
        case BtnTypeMore://点击更多
            
            [self MoveBtn];
            break;
        case BtnTypeYuYin://点击语音搜索
            
            [self YuYin];
            break;
            
    }
}

#pragma mark 保存播放历史数据
- (void)beginbtnYes {
    
    FMDatabase *db = [FMDBTool createDatabaseAndTable:@"BFLS"];
    
    if (dataBFArray.count != 0) {
        
        NSDictionary *dict = dataBFArray[self.musicIndex];
        
        NSLog( @"%@",dict);
        
        BOOL isRept = NO;
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM BFLS"];
        // 遍历结果，如果重复就不进行保存
        while ([resultSet next]) {
            
            NSData *ID = [resultSet dataForColumn:@"BFLS"];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
            if ([dict[@"ContentId"] isEqualToString:jsonDict[@"ContentId"]]) {
                
                
                isRept = YES;
            }
        }
        if (!isRept) {         
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
            NSString *sqlInsert = @"insert into BFLS values(?)";
            BOOL isOk = [db executeUpdate:sqlInsert, data];
            if (isOk) {
                NSLog(@"添加数据成功");
            }
          
        }
 
    }
    
}

#pragma mark 播放动画
- (void)boFangDongHua {
    
    [BoFangimgV startAnimating];
    isBegin = YES;
}

#pragma mark 暂停动画
- (void)zanTingDongHua {
    
    [BoFangimgV stopAnimating];
    isBegin = NO;
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
#pragma mark 进入节目单
- (void)JinJMD {
     WTBoFangModel *model = _musics[_musicIndex];
    
    WTJMDViewController *WTJieMuVC = [[WTJMDViewController alloc] init];
    
    WTJieMuVC.hidesBottomBarWhenPushed = YES;
    WTJieMuVC.contentID = model.ContentId;
    [self.navigationController pushViewController:WTJieMuVC animated:YES];
}

#pragma mark 点击更多
- (void)MoveBtn {
    if (dataBFArray.count != 0) {
        if ([dataBFArray[_musicIndex][@"MediaType"] isEqualToString:@"RADIO"]) {
            
            WTGengDuoDianTaiController *gengDTVC = [[WTGengDuoDianTaiController alloc] init];
            
            gengDTVC.dataDict = dataBFArray[_musicIndex];

            gengDTVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gengDTVC animated:YES];
        }else{
        
            WTGengDuoController *gengDVC = [[WTGengDuoController alloc] init];
        
            gengDVC.dataDict = dataBFArray[_musicIndex];
            
            gengDVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gengDVC animated:YES];
        }
    }
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
        
        WTLikeListViewController *WTlikeVC = [[WTLikeListViewController alloc] init];
        WTlikeVC.label = @"播放历史";
        WTlikeVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:WTlikeVC animated:YES];
    }else { //定时关闭
        
        WTDingShiController *WTDSVC = [[WTDingShiController alloc] init];
        
        WTDSVC.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:WTDSVC animated:YES];
    }
}





#pragma mark 播放上一首
-(void)previous{
    if (self.musicIndex == 0) {//第一首
        self.musicIndex = self.musics.count - 1;
    }else{
        self.musicIndex --;
    }
    //改变图片
    NSDictionary *dataDict = dataBFArray[self.musicIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
    BoFangDH = self.musicIndex;
    [_JQtableView reloadData];
    [self playMusic];
    [[JQMusicTool sharedJQMusicTool] play];
    
    //改变更多页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GENGDUOCHANGER" object:nil userInfo:dataDict];
}

#pragma mark 播放下一首
-(void)next{
    
    //1.更改播放的索引
    if (self.musicIndex == self.musics.count - 1) {//最后条
        self.musicIndex = 0;
    }else{
        self.musicIndex ++;
    }
    //改变图片
    NSDictionary *dataDict = dataBFArray[self.musicIndex];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
    BoFangDH = self.musicIndex;
    [_JQtableView reloadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self playMusic];
    [[JQMusicTool sharedJQMusicTool] play];
    
    //改变更多页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GENGDUOCHANGER" object:nil userInfo:dataDict];
}

- (void)HYCNext{
    
    [self next];
    
}


-(void)playMusic{
    
    if (self.musics.count == 0) {
        
    }else{
        //2.重新初始化一个 "播放器"
        [[JQMusicTool sharedJQMusicTool] prepareToPlayWithMusic:self.musics[self.musicIndex]];
        
        //3.更改 “播放器工具条” 的数据
        self.headerV.playingMusic = self.musics[self.musicIndex];
        
        //4.播放
        if (self.headerV.isPlaying) {
            
            [[JQMusicTool sharedJQMusicTool] play];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HYCNext) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    
        
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else {
        
        return dataBFArray.count;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {

            _headerV = bofangCell;
            bofangCell.delegate = self;
            
            return bofangCell;
            
        }


        
    }else {
        
        if ([dataBFArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            static NSString *cellID = @"cellIDL";
            
            WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            
            NSDictionary *dict = dataBFArray[indexPath.row];
            [cell setCellWithDict:dict];
            
            
            return cell;
        }else if ([dataBFArray[indexPath.row][@"MediaType"] isEqualToString:@"RADIO"]){
            
            static NSString *cellID = @"cellIDT";
            
            WTDianTaiTableViewCell *cell = (WTDianTaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            
            NSDictionary *dict = dataBFArray[indexPath.row];
            [cell setCellWithDict:dict];
            
            // 加载所有的动画图片
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 1; i <= 18; i++) {
                NSString *filename = [NSString stringWithFormat:@"%@_%d", @"play_flag_wave", i];
                NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:file];
                [images addObject:image];
            }
            
            
            cell.BoFangImgV.hidden = YES;
            
            if (BoFangDH == (long)indexPath.row) {
                
                cell.BoFangImgV.hidden = NO;
                cell.BoFangImgV.animationImages = images;
                BoFangimgV = cell.BoFangImgV;
                
                if (isBegin) {  //判断播放状态
                    
                    [BoFangimgV startAnimating];
                }
            }
            
            
            
            return cell;
    
        }else {
        
            static NSString *cellID = @"cellID";
            
            WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
          
            NSDictionary *dict = dataBFArray[indexPath.row];
            [cell setCellWithDict:dict];
            
            // 加载所有的动画图片
            NSMutableArray *images = [NSMutableArray array];
            for (int i = 1; i <= 18; i++) {
                NSString *filename = [NSString stringWithFormat:@"%@_%d", @"play_flag_wave", i];
                NSString *file = [[NSBundle mainBundle] pathForResource:filename ofType:@"png"];
                UIImage *image = [UIImage imageWithContentsOfFile:file];
                [images addObject:image];
            }
            
    
            cell.WTBoFangImgV.hidden = YES;
            
            if (BoFangDH == (long)indexPath.row) {
                
                cell.WTBoFangImgV.hidden = NO;
                cell.WTBoFangImgV.animationImages = images;
                BoFangimgV = cell.WTBoFangImgV;
                
                if (isBegin) {  //判断播放状态
                    
                    [BoFangimgV startAnimating];
                }
            }
            
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
            
            return 180;
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
        
            bofangCell.playing = YES;
            bofangCell.beginBtn.selected = YES;
            [self beginbtnYes];
            
            //如果cell处于显示状态， 使其隐藏
            if (BoFangXQ != 0) {
                
               [self XianShiBtnClick:nil];
            }
            
            self.musicIndex = indexPath.row;
            BoFangDH = indexPath.row;
            
            isBegin = YES;
            //播放音乐
            [self playMusic];
            [[JQMusicTool sharedJQMusicTool] play];
            [_JQtableView reloadData];
            
            //改变图片
            NSDictionary *dataDict = dataBFArray[indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGEIMAGEVIEW" object:nil userInfo:dataDict];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];   //开始旋转
            //还原动画
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RESTORETIME" object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
            
            
            
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

- (IBAction)NewBtnClick:(id)sender {
    
    WTNewsViewController *wtnewVC = [[WTNewsViewController alloc] init];
    wtnewVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtnewVC animated:YES];
}

- (IBAction)searchBtnClick:(id)sender {
    
    WTSearchViewController *wtSearVC = [[WTSearchViewController alloc] init];
    wtSearVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtSearVC animated:YES];

}
@end
