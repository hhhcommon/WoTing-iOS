//
//  WTBoFangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangViewController.h"
#import <AVFoundation/AVFoundation.h>

#import "WTBoFangTableViewCell.h"
#import "WTBoFangView.h"
#import "WTBoFangModel.h"
#import "JQMusicTool.h"

@interface WTBoFangViewController ()<UITableViewDelegate, UITableViewDataSource, WTBoFangViewDelegate, AVAudioPlayerDelegate>{
    
    NSMutableArray  *dataBFArray;
    
    NSString        *urlStr;
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
    
    dataBFArray = [NSMutableArray arrayWithCapacity:0];
    _musics = [[NSMutableArray alloc] init];
    
    _JQtableView.delegate = self;
    _JQtableView.dataSource = self;
    
    _JQtableView.tableFooterView = [[UIView alloc] init];
    
    _headerV = [WTBoFangView creatXib];
    _headerV.userInteractionEnabled = YES;
    _headerV.bounds = CGRectMake(0, 0, K_Screen_Width, 400);
    _headerV.delegate = self;
    _JQtableView.tableHeaderView = _headerV;
    
    [self loadData];
    [self registerTabViewCell];
    

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
            dataBFArray = ResultList[@"List"];
            for (NSDictionary *dict in ResultList[@"List"]) {
                
                WTBoFangModel *model = [[WTBoFangModel alloc] initWithDictionary:dict error:nil];
                [_musics addObject:model];
            }
            
            [_JQtableView reloadData];
            [self playMusic];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [E_HUDView showMsg:@"服务器异常" inView:nil];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
}

#pragma mark 播放工具条的代理
-(void)playerToolBar:(WTBoFangView *)toolbar btnClickWithType:(BtnType)btnType{
    //实现这个播放，把播放的操作放在一个工具类
    switch (btnType) {
        case BtnTypePlay:
            NSLog(@"BtnTypePlay");
            [[JQMusicTool sharedJQMusicTool] play];
            break;
        case BtnTypePause:
            NSLog(@"BtnTypePause");
            [[JQMusicTool sharedJQMusicTool] pause];
            break;
        case BtnTypePrevious:
            NSLog(@"BtnTypePrevious");
            [self previous];
            break;
        case BtnTypeNext:
            NSLog(@"BtnTypeNext");
            [self next];
            break;
            
    }
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
    
    //设置player的代理
  //  [JQMusicTool sharedJQMusicTool].player.delegate = self;
    
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

    static NSString *cellID = @"cellID";
    
    WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = dataBFArray[indexPath.row];
    [cell setCellWithDict:dict];

    
    return cell;
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
    
    self.musicIndex = indexPath.row;
    //播放音乐
    [self playMusic];
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
