//
//  WTMainViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTMainViewController.h"

#import "WTLikeListViewController.h"
#import "WTSheZhiViewController.h"
#import "WTLoginViewController.h"

#import "SGGenerateQRCodeVC.h"  //二维码生成器

@interface WTMainViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    /** 设置ICON */
    NSArray         *iconsArray;
    /** 设置Title */
    NSArray         *titlesArray;
    
    /** 昵称*/
    NSString        *userName;
    
    /** 地址*/
    NSString        *Region;
    
    /** 标记登录状态值 */
    NSInteger   Login; //0为未登录
    
    NSDictionary     *loginDict;
}

@end

@implementation WTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // loginDict = [[NSDictionary alloc] init];
    loginDict = [AutomatePlist readPlistForDict:@"LoginDict"];
    self.navigationController.navigationBar.hidden = YES;
    
    NSString *Uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    if (Uid && ![Uid  isEqual: @"0"] && ![Uid isEqual:@""]) {
        
        Login = 1;
        Region = [AutomatePlist readPlistForKey:@"Region"];
        userName = [AutomatePlist readPlistForKey:@"UName"];
    }else{
        Login = 0;
    }
    //监听登陆状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginNotification:) name:@"LoginChangeNotification" object:nil];
    
    [self creterNSArray];
    
    
    self.JQMainTV.delegate = self;
    self.JQMainTV.dataSource = self;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self initContents];
   
}

- (void)creterNSArray {
    
    if (Login == 0) {
        
        iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"mine_icon_play history.png", nil], [NSArray arrayWithObjects:@"mine_icon_234G.png", nil],[NSArray arrayWithObjects:@"mine_icon_yingjian.png",@"mine_icon_app share.png", nil],[NSArray arrayWithObjects:@"mine_icon_set.png", nil], nil];
        
        titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"播放历史", nil], [NSArray arrayWithObjects:@"2/3/4G网络播放和下载提醒",  nil],[NSArray arrayWithObjects:@"智能硬件",@"应用分享",  nil], [NSArray arrayWithObjects:@"其它设置",  nil] ,nil];
    }else{
        
        iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"mine_icon_play history.png",@"mine_icon_like.png",@"mine_icon_follow.png",@"mine_icon_subscribe.png",@"mine_icon_my upload.png", nil], [NSArray arrayWithObjects:@"mine_icon_234G.png", nil],[NSArray arrayWithObjects:@"mine_icon_yingjian.png",@"mine_icon_app share.png", nil],[NSArray arrayWithObjects:@"mine_icon_set.png", nil], nil];
        
        titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"播放历史",@"我的喜欢",@"我的关注",@"我的订阅",@"我的上传", nil], [NSArray arrayWithObjects:@"2/3/4G网络播放和下载提醒",  nil],[NSArray arrayWithObjects:@"智能硬件",@"应用分享",  nil], [NSArray arrayWithObjects:@"其它设置",  nil] ,nil];
        
    }
    
    
}

- (void)initContents{
    
    UIImageView *headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(375))];
    headerView.userInteractionEnabled = YES;
    headerView.image = [UIImage imageNamed:@"mine_bg.png"];
    self.JQMainTV.tableHeaderView = headerView;
    
    //二维码
    UIButton *erwBtn = [[UIButton alloc] init];
    [erwBtn setImage:[UIImage imageNamed:@"mine_icon_codes.png"] forState:UIControlStateNormal];
    [erwBtn addTarget:self action:@selector(erweimaBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:erwBtn];
    [erwBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(POINT_Y(80));
        make.left.mas_equalTo(40);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    //编辑资料
    UIButton *ZLBtn = [[UIButton alloc] init];
    [ZLBtn setImage:[UIImage imageNamed:@"mine_icon_edit profile.png"] forState:UIControlStateNormal];
    [ZLBtn addTarget:self action:@selector(ziliaoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:ZLBtn];
    [ZLBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(POINT_Y(80));
        make.right.mas_equalTo(-40);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    //姓名
    UILabel *NameLb = [[UILabel alloc] init];
    
    if (Login == 0) {
        NameLb.text = @"我的";
    }else{
        NameLb.text = userName;
    }
    
    NameLb.textAlignment = NSTextAlignmentCenter;
    NameLb.font = [UIFont boldSystemFontOfSize:15];
    NameLb.textColor = [UIColor whiteColor];
    [headerView addSubview:NameLb];
    [NameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(POINT_Y(80));
        make.width.mas_equalTo(POINT_X(220));
        make.height.mas_equalTo(POINT_Y(40));
    }];
    
    //透明的btn
    UIButton *LoginBtn = [[UIButton alloc] init];
    LoginBtn.backgroundColor = [UIColor clearColor];
    [LoginBtn addTarget:self action:@selector(LoginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:LoginBtn];
    [LoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(NameLb.mas_bottom).with.offset(POINT_Y(10));
        make.width.mas_equalTo(POINT_X(120));
        make.height.mas_equalTo(POINT_Y(120));
    }];
    
    //登陆ID
    UILabel *LogID = [[UILabel alloc] init];
    LogID.text = @"点击登陆";
    LogID.textAlignment = NSTextAlignmentCenter;
    LogID.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:LogID];
    [LogID mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(LoginBtn.mas_bottom).with.offset(POINT_Y(25));
        make.width.mas_equalTo(POINT_X(220));
        make.height.mas_equalTo(POINT_Y(25));
    }];
    if (Login == 0) {
        
        LogID.hidden = NO;
        LoginBtn.hidden = NO;
        erwBtn.hidden = YES;
        ZLBtn.hidden = YES;
    }else{
        
        LogID.hidden = YES;
        LoginBtn.hidden = YES;
        erwBtn.hidden = NO;
        ZLBtn.hidden = NO;
    }
    
    //一句话介绍自己
    UILabel *MainID = [[UILabel alloc] init];
    if (Login == 0) {
        
        MainID.text = @"用我听,听我想听,说我想说！";
    }else{
        
        if (Region) {
            
            MainID.text = Region;
        }else{
            MainID.text = @"您还没有添写地址";
        }
    }
    
    MainID.textAlignment = NSTextAlignmentCenter;
    MainID.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:MainID];
    [MainID mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(LogID.mas_bottom).with.offset(POINT_Y(20));
        make.width.mas_equalTo(POINT_Y(450));
        make.height.mas_equalTo(POINT_Y(30));
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (Login == 0) {
            
            return 1;
        }else{
            return 5;
        }
    }else if (section == 1) {
        return 1;
    }else if (section == 2){
        
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor skTitleHighBlackColor];
    }
    
    cell.imageView.image = [UIImage imageNamed:[[iconsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.textLabel.text = [[titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (Login == 1) {
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            
            WTLikeListViewController *WTlikeVC = [[WTLikeListViewController alloc] init];

            WTlikeVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:WTlikeVC animated:YES];
            
        }
        
    }
    
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        
        WTSheZhiViewController *WTszVC = [[WTSheZhiViewController alloc] init];
        WTszVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:WTszVC animated:YES];

    }
}

//登录状态改变触发
- (void)LoginNotification:(NSNotification *)nt{
    
    if ([[nt.userInfo objectForKey:@"User"] isEqualToString:@"jq"]) {
        
        Login = 0;
        [self creterNSArray];
        [self initContents];
        [_JQMainTV reloadData];
    }else {
    
        Login = 1;
        userName = [nt.userInfo objectForKey:@"UserName"];
        Region = [nt.userInfo objectForKey:@"Region"];
        [self creterNSArray];
        [self initContents];
        [_JQMainTV reloadData];
    }
}

//跳转到登录页
- (void)LoginBtnClick:(UIButton *)btn{
    
    WTLoginViewController *loginVC = [[WTLoginViewController alloc] init];
    
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];

}

//查看二维码
- (void)erweimaBtnClick:(UIButton *)btn {
    
    SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
    VC.dict = loginDict;
    
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

//编辑资料
- (void)ziliaoBtnClick:(UIButton *)btn {
    
    
    
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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
