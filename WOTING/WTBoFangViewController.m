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

@interface WTBoFangViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataBFArray;
    
    /** 头视图 */
    UIView  *headerView;
    UIButton *LuKuangbtn; //路况btn
    UIButton *HTbtn;    //语言输入Btn
    UILabel *BTLab;     //当前播放节目名
    
    /** 播放线*/
    UISlider        *wtSlider;
    
    /** 播放时间 */
    UILabel         *timeLab;
    /** 总时间 */
    UILabel         *cutimeLab;
    
    /** 播放器*/
    AVPlayer        *player;
    
    /** */
    BOOL            isPlayer;
}

@end

@implementation WTBoFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataBFArray = [NSMutableArray arrayWithCapacity:0];
    isPlayer = NO;
    
    _JQtableView.delegate = self;
    _JQtableView.dataSource = self;
    
    _JQtableView.tableFooterView = [[UIView alloc] init];
    
    [self initHeaderView];
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
            
            [_JQtableView reloadData];
            NSLog(@"%@", dataBFArray);
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [E_HUDView showMsg:@"服务器异常" inView:nil];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
}


- (void)initHeaderView{
    
    if (!headerView) {
        
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(610))];
        headerView.backgroundColor = [UIColor whiteColor];
        _JQtableView.tableHeaderView = headerView;
    }
    
    //路况、文字、话筒
    if (!LuKuangbtn) {
        
        LuKuangbtn = [[UIButton alloc] init];
        [LuKuangbtn setImage:[UIImage imageNamed:@"home_btn_traffic.png"] forState:UIControlStateNormal];
        [headerView addSubview:LuKuangbtn];
        [LuKuangbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(POINT_X(30));
            make.top.mas_equalTo(POINT_Y(35));
            make.width.mas_equalTo(POINT_X(50));
            make.height.mas_equalTo(POINT_Y(50));
        }];
    }
    
    if (!HTbtn) {
        
        HTbtn = [[UIButton alloc] init];
        [HTbtn setImage:[UIImage imageNamed:@"home_btn_voice search.png"] forState:UIControlStateNormal];
        [headerView addSubview:HTbtn];
        [HTbtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-POINT_X(30));
            make.top.mas_equalTo(POINT_Y(35));
            make.width.mas_equalTo(POINT_X(50));
            make.height.mas_equalTo(POINT_X(50));
        }];
    }
    
    if (!BTLab) {
        
        BTLab = [[UILabel alloc] init];
        BTLab.font = [UIFont boldSystemFontOfSize:15];
        BTLab.text = @"稻花香";
        BTLab.textAlignment = NSTextAlignmentCenter;
        [headerView addSubview:BTLab];
        [BTLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(LuKuangbtn.mas_right).with.offset(POINT_X(30));
            make.right.equalTo(HTbtn.mas_left).with.offset(-POINT_X(30));
            make.top.mas_equalTo(POINT_Y(35));
            make.height.mas_equalTo(POINT_Y(40));
        }];
    }
    
    
    NSURL *url = [NSURL URLWithString:@""];
    //http://audio.xmcdn.com/group9/M05/9A/45/wKgDZldqF4OyhEmRABokhROZU3k474.m4a
    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:url];
    player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    player.volume = 1.0;
    //播放器
    UIView *PlayView = [[UIView alloc] initWithFrame:CGRectMake(0, POINT_Y(95), K_Screen_Width, POINT_Y(440))];
    PlayView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:PlayView];

    //播放、暂停
    UIImageView *BeginImgV = [[UIImageView alloc] init];
    BeginImgV.userInteractionEnabled = YES;
    BeginImgV.image = [UIImage imageNamed:@"img_radio_default.png"];
    [PlayView addSubview:BeginImgV];
    [BeginImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(POINT_Y(20));
        make.centerX.equalTo(PlayView.mas_centerX);
        make.width.mas_equalTo(POINT_X(200));
        make.height.mas_equalTo(POINT_X(200));
    }];
    UIButton *BeginBtn = [[UIButton alloc] init];
    [BeginBtn setImage:[UIImage imageNamed:@"wt_play_stop.png"] forState:UIControlStateNormal];
    [BeginBtn addTarget:self action:@selector(BeginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [BeginImgV addSubview:BeginBtn];
    [BeginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(BeginImgV.mas_centerY);
        make.centerX.equalTo(BeginImgV.mas_centerX);
        make.width.mas_equalTo(POINT_X(60));
        make.height.mas_equalTo(POINT_X(60));
    }];
    
    //六边形
    UIImageView *LiuImgV = [[UIImageView alloc] init];
    LiuImgV.image = [UIImage imageNamed:@"WT_BoFang_Kuang.png"];
    [PlayView addSubview:LiuImgV];
    [LiuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(POINT_Y(20));
        make.centerX.equalTo(PlayView.mas_centerX);
        make.width.mas_equalTo(POINT_X(200));
        make.height.mas_equalTo(POINT_X(200));
    }];

    
    
    //前一首
    UIButton *QyBtn = [[UIButton alloc] init];
    [QyBtn setImage:[UIImage imageNamed:@"home_btn_last.png"] forState:UIControlStateNormal];
    [PlayView addSubview:QyBtn];
    [QyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(100));
        make.top.mas_equalTo(POINT_X(100));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_X(50));
    }];
    
    //后一首
    UIButton *HyBtn = [[UIButton alloc] init];
    [HyBtn setImage:[UIImage imageNamed:@"home_btn_next.png"] forState:UIControlStateNormal];
    [PlayView addSubview:HyBtn];
    [HyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(100));
        make.top.mas_equalTo(POINT_X(100));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_X(50));
    }];
    
    //播放线
    wtSlider = [[UISlider alloc] init];
    [PlayView addSubview:wtSlider];
    wtSlider.value = 1.0;
    wtSlider.backgroundColor = [UIColor clearColor];
    wtSlider.minimumValue = 0.5;
    wtSlider.maximumValue = 1.0;
    [wtSlider setThumbImage:[UIImage imageNamed:@"progressbar_circular.png"] forState:UIControlStateNormal];
    [wtSlider setMinimumTrackImage:[UIImage imageNamed:@"progressbar_play.png"] forState:UIControlStateNormal];
    [wtSlider setMaximumTrackImage:[UIImage imageNamed:@"progressbar_cache.png"] forState:UIControlStateNormal];
    [wtSlider addTarget:self action:@selector(wtslidervaluechange:) forControlEvents:UIControlEventValueChanged];
    [wtSlider addTarget:self action:@selector(wtslidertouchupchange:) forControlEvents:UIControlEventTouchUpInside];
    [wtSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(150));
        make.top.equalTo(LiuImgV.mas_bottom).with.offset(POINT_Y(60));
        make.left.mas_equalTo(POINT_X(150));
        make.height.mas_equalTo(POINT_X(9));
    }];
    
    //播放总时间
    cutimeLab = [[UILabel alloc] init];
    cutimeLab.textColor = [UIColor JQTColor];
    cutimeLab.font = [UIFont systemFontOfSize:11];
    cutimeLab.text = @"00:00:00";
    [PlayView addSubview:cutimeLab];
    [cutimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(wtSlider.mas_centerY);
        make.left.equalTo(wtSlider.mas_right).with.offset(POINT_X(10));
        make.width.mas_equalTo(POINT_X(110));
        make.height.mas_equalTo(POINT_Y(40));
    }];
    //播放时间
    timeLab = [[UILabel alloc] init];
    timeLab.textColor = [UIColor JQTColor];
    timeLab.font = [UIFont systemFontOfSize:11];
    timeLab.text = @"00:00:00";
    [PlayView addSubview:timeLab];
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(wtSlider.mas_centerY);
        make.right.equalTo(wtSlider.mas_left).with.offset(-POINT_X(10));
        make.width.mas_equalTo(POINT_X(110));
        make.height.mas_equalTo(POINT_Y(40));
    }];
    
    //分享
    UIButton *FenXiang = [[UIButton alloc] init];
    [FenXiang setImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [PlayView addSubview:FenXiang];
    [FenXiang mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(PlayView.mas_centerX);
        make.top.equalTo(wtSlider.mas_bottom).with.offset(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(60));
        make.height.mas_equalTo(POINT_X(60));
    }];
    UILabel *FenXLab = [[UILabel alloc] init];
    FenXLab.text = @"分享";
    FenXLab.textColor = [UIColor JQTColor];
    FenXLab.textAlignment = NSTextAlignmentCenter;
    FenXLab.font = [UIFont systemFontOfSize:13];
    [PlayView addSubview:FenXLab];
    [FenXLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(wtSlider.mas_centerX);
        make.top.equalTo(FenXiang.mas_bottom);
        make.width.mas_equalTo(POINT_X(60));
        make.height.mas_equalTo(POINT_X(30));
    }];
    
    //灰线
    UIImageView *lineImageView = [[UIImageView alloc] init];
    lineImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [headerView addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(PlayView.mas_bottom);
        make.left.mas_equalTo(POINT_X(30));
        make.right.mas_equalTo(-POINT_X(30));
        make.height.equalTo(@1);
    }];
    
    //灰线以下
    UIImageView *JieMuImgV = [[UIImageView alloc] init];
    JieMuImgV.image = [UIImage imageNamed:@"home_btn_program details.png"];
    [headerView addSubview:JieMuImgV];
    [JieMuImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(30));
        make.top.equalTo(lineImageView.mas_bottom).with.offset(POINT_Y(10));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_X(50));
    }];
    UILabel *jieMLb = [[UILabel alloc] init];
    jieMLb.text = @"节目详情";
    jieMLb.textColor = [UIColor JQTColor];
    jieMLb.textAlignment = NSTextAlignmentCenter;
    jieMLb.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:jieMLb];
    [jieMLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(JieMuImgV.mas_centerY);
        make.left.equalTo(JieMuImgV.mas_right);
        make.width.mas_equalTo(POINT_X(120));
        make.height.mas_equalTo(POINT_Y(30));
    }];
    
    UIButton *disPlayBtn = [[UIButton alloc] init];
    [disPlayBtn setBackgroundImage:[UIImage imageNamed:@"home_btn_background.png"] forState:UIControlStateNormal];
    [disPlayBtn setTitle:@"显示" forState:UIControlStateNormal];
    [headerView addSubview:disPlayBtn];
    [disPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(JieMuImgV.mas_centerY);
        make.right.mas_equalTo(-POINT_X(30));
        make.width.mas_equalTo(POINT_X(60));
        make.height.mas_equalTo(POINT_Y(35));
    }];
    
}

//点击播放
- (void)BeginBtnClick:(UIButton *)btn{
    
    if (isPlayer) {
        [btn setImage:[UIImage imageNamed:@"wt_play_stop.png"] forState:UIControlStateNormal];
        [player pause];
        isPlayer = NO;
    }else{
        [btn setImage:[UIImage imageNamed:@"wt_play_play.png"] forState:UIControlStateNormal];
        [player play];
        isPlayer = YES;
    }
    
    
}
//播放线交互
- (void)wtslidervaluechange:(UISlider *)sender {
    
    player.volume = sender.value;
}
- (void)wtslidertouchupchange:(UISlider *)sender {
    
    player.volume = sender.value;
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
