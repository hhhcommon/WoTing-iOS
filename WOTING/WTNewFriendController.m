//
//  WTNewFriendController.m
//  WOTING
//
//  Created by jq on 2017/4/11.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTNewFriendController.h"

#import "WTJoinQunCell.h"   //数据源cell

@interface WTNewFriendController ()<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *dataNewFriArr;  //新的群邀请数据源
    NSMutableArray *dataZongArr;    //群邀请+好友邀请
}

@end

@implementation WTNewFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataZongArr = [NSMutableArray arrayWithCapacity:0];
    dataNewFriArr = [NSMutableArray arrayWithCapacity:0];
    _NewFriendLab.text = _ConText;
    
    _NewFriendTabV.delegate = self;
    _NewFriendTabV.dataSource = self;
    
    _NewFriendTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _NewFriendTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self registerNewFriendTabCell];
    [self loadNewFriendData];
    
}

//好友邀请列表
- (void)loadNewQunData{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_FriendInvitedList;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataNewFriArr removeAllObjects];
            [dataNewFriArr addObjectsFromArray:resultDict[@"UserList"]];
            
            [dataZongArr addObjectsFromArray:dataNewFriArr];
            
            [_NewFriendTabV reloadData];
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [WKProgressHUD popMessage:@"暂无我的邀请信息" inView:nil duration:0.5 animated:YES];

            [_NewFriendTabV reloadData];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
}


//加群邀请列表
- (void)loadNewFriendData{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_GetInviteMeList;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataZongArr removeAllObjects];
            
            [dataNewFriArr removeAllObjects];
            [dataNewFriArr addObjectsFromArray:resultDict[@"GroupList"]];
            
            [dataZongArr addObjectsFromArray:dataNewFriArr];
            
            [self loadNewQunData];  //好友邀请数据
            
        }else if ([ReturnType isEqualToString:@"1011"]){
            [dataZongArr removeAllObjects];
            [dataNewFriArr removeAllObjects];
            [self loadNewQunData];  //好友邀请数据
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
}

- (void)registerNewFriendTabCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTJoinQunCell" bundle:nil];
    
    [_NewFriendTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataZongArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    WTJoinQunCell *cell = (WTJoinQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTJoinQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *GroupId = [NSString NULLToString:dataZongArr[indexPath.row][@"GroupId"]];
    if (GroupId.length > 0) {   //群邀请
        
        //[3]	(null)	@"InviteUserInfo" : 3 key/value pairs
        cell.contentName.text = [NSString NULLToString: dataZongArr[indexPath.row][@"InviteUserInfo"][@"NickName"]];
        
        cell.ShenQLab.text = @"邀请你加入群组";
        cell.auditLab.text = [NSString stringWithFormat:@"邀请你加入%@",dataZongArr[indexPath.row][@"GroupName"]];
        cell.contentImgV.image = [UIImage imageNamed:@"Qun_header.png"];
        
        //传值
        objc_setAssociatedObject(cell.agreeBtn, @"InviteUserId", [NSString NULLToString:dataZongArr[indexPath.row][@"InviteUserId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//邀请人id
        objc_setAssociatedObject(cell.agreeBtn, @"GroupId", [NSString NULLToString:dataZongArr[indexPath.row][@"GroupId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//用户组id
        objc_setAssociatedObject(cell.JuJueBtn, @"InviteUserId", [NSString NULLToString:dataZongArr[indexPath.row][@"InviteUserId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//邀请人id
        objc_setAssociatedObject(cell.JuJueBtn, @"GroupId", [NSString NULLToString:dataZongArr[indexPath.row][@"GroupId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//用户组id
        
        [cell.agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.JuJueBtn addTarget:self action:@selector(JuJueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }else{  //好友邀请
        
        cell.contentName.text = [NSString NULLToString: dataZongArr[indexPath.row][@"NickName"]];
        
        cell.ShenQLab.text = @"请求添加你为好友";
        cell.auditLab.text = [NSString stringWithFormat:@"我是%@",dataZongArr[indexPath.row][@"NickName"]];
        cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
        
        objc_setAssociatedObject(cell.agreeBtn, @"InviteUserId", [NSString NULLToString:dataZongArr[indexPath.row][@"UserId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//邀请人id
        objc_setAssociatedObject(cell.JuJueBtn, @"InviteUserId", [NSString NULLToString:dataZongArr[indexPath.row][@"UserId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//邀请人id
        
        [cell.agreeBtn addTarget:self action:@selector(agreeFriBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.JuJueBtn addTarget:self action:@selector(JuJueFriBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    
    return cell;
}

//同意加好友
- (void)agreeFriBtnClick:(UIButton *)btn{
    
    NSString *InviteUserId = objc_getAssociatedObject(btn, @"InviteUserId");
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",InviteUserId,@"InviteUserId",@"1",@"DealType",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_FriendInviteDeal;
   
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [self loadNewFriendData];   //从新加载数据
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];

    
}


//拒绝加好友
- (void)JuJueFriBtnClick:(UIButton *)btn{
    
    NSString *InviteUserId = objc_getAssociatedObject(btn, @"InviteUserId");
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",InviteUserId,@"InviteUserId",@"2",@"DealType",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_FriendInviteDeal;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [self loadNewFriendData];   //从新加载数据
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
}

//同意入群
- (void)agreeBtnClick:(UIButton *)btn{
    
    NSString *InviteUserId = objc_getAssociatedObject(btn, @"InviteUserId");
    NSString *GroupId = objc_getAssociatedObject(btn, @"GroupId");
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",InviteUserId,@"InviteUserId",@"1",@"DealType",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_InviteDeal;
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [self loadNewFriendData];   //从新加载数据
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];

    
}

//拒绝入群
- (void)JuJueBtnClick:(UIButton *)btn{
    
    NSString *InviteUserId = objc_getAssociatedObject(btn, @"InviteUserId");
    NSString *GroupId = objc_getAssociatedObject(btn, @"GroupId");
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",InviteUserId,@"InviteUserId",@"2",@"DealType",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_InviteDeal;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [self loadNewFriendData];   //从新加载数据
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];

    
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
