//
//  WTBoFangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "WTPingLunViewController.h"

#import "WTBoFangTableViewCell.h"   //节目, 电台格式cell
#import "WTLikeCell.h"      //专辑格式cell
#import "WTBoFangView.h"
#import "WTBoFangModel.h"
#import "JQMusicTool.h"

@interface WTBoFangViewController ()<UITableViewDelegate, UITableViewDataSource, WTBoFangViewDelegate, AVAudioPlayerDelegate>{
    
    NSMutableArray  *dataBFArray;
    
    NSString        *urlStr;
    
    NSInteger       changPag;   //判断是否从别的页面传过的值
    NSString        *SearchStr; //接受传过来的值
    
  //  NSInteger       page; //刷新page
}

@property (nonatomic ,strong) AVPlayer   *player;
@property (nonatomic, strong) WTBoFangView   *headerV;
@property(assign, nonatomic)NSInteger musicIndex;//当前播放音乐索引
@property(strong,nonatomic) NSMutableArray *musics;//音乐数据

@end

@implementation WTBoFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    changPag = 0;
    
    //设置音乐后台播放的会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewAndData:) name:@"TABLEVIEWCLICK" object:nil];
    
    dataBFArray = [NSMutableArray arrayWithCapacity:0];
    _musics = [[NSMutableArray alloc] init];
    
    _JQtableView.delegate = self;
    _JQtableView.dataSource = self;
    
    _JQtableView.tableFooterView = [[UIView alloc] init];
    
    _headerV = [WTBoFangView creatXib];
    _headerV.userInteractionEnabled = YES;
   // _JQtableView.tableHeaderView.frame = CGRectMake(0,0,K_Screen_Width, 400);
    _headerV.bounds = CGRectMake(0, 0, K_Screen_Width, 480);
    _headerV.delegate = self;
    _JQtableView.tableHeaderView = _headerV;
    
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
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_JQtableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

//网络请求
- (void)loadData {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",  nil];
    
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
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",  nil];
        
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
-(void)playerToolBar:(WTBoFangView *)toolbar btnClickWithType:(BtnType)btnType{
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
            
            [WKProgressHUD popMessage:@"点击下载" inView:nil duration:0.5 animated:YES];
            break;
        case BtnTypeShare://点击分享
            
            [WKProgressHUD popMessage:@"点击分享" inView:nil duration:0.5 animated:YES];
            break;
        case BtnTypeCommit://点击评论
            
            [self Commits];
            break;
        case BtnTypeMore://点击更多
            
            [WKProgressHUD popMessage:@"点击更多" inView:nil duration:0.5 animated:YES];
            break;
            
    }
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
            
            [WKProgressHUD popMessage:@"加入喜欢成功" inView:nil duration:0.5 animated:YES];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [WKProgressHUD popMessage:@"请先登录后再试" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
    
}

#pragma mark 点击评论
- (void)Commits {
    
    WTBoFangModel *model = _musics[_musicIndex];
    
    self.hidesBottomBarWhenPushed=YES;
    WTPingLunViewController *wtPLVC = [[WTPingLunViewController alloc] init];
    
    wtPLVC.ContentID = model.ContentId;
    wtPLVC.Metype = model.MediaType;
    
    [self.navigationController pushViewController:wtPLVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
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
}

#pragma mark 播放器的代表
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    //自动播放下一首
    [self next];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataBFArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[12]	(null)	@"MediaType" : @"SEQU"
    if ([dataBFArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        static NSString *cellID = @"cellID";
        
        WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataBFArray[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
    }else {
    
        static NSString *cellID = @"cellID";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataBFArray[indexPath.row];
        [cell setCellWithDict:dict];

        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *labeltitle = [[UILabel alloc] init];
    labeltitle.text = @"相关推荐";
    labeltitle.font = [UIFont boldSystemFontOfSize:15];
    labeltitle.textColor = [UIColor skTitleCenterBlackColor];
    [view addSubview:labeltitle];
    
    [labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(20);
    }];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([dataBFArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        
    }else{
    
        self.musicIndex = indexPath.row;
        //播放音乐
        [self playMusic];
    }
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
