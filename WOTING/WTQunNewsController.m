//
//  WTQunNewsController.m
//  WOTING
//
//  Created by jq on 2017/4/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunNewsController.h"

#import "WTJoinQunCell.h"   //加入群

@interface WTQunNewsController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataJoinArr;   //申请列表数据源
}

@end

@implementation WTQunNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _contentName.text = _contentQunName;
    dataJoinArr = [NSMutableArray arrayWithCapacity:0];
    
    _QunNewsTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _QunNewsTabV.delegate = self;
    _QunNewsTabV.dataSource = self;
    
    [self registerQunNewsTabCell];
    
    if (_JoinType == 0) {   //加群消息
        
        [self loadQunNewsData];
    }else{  //审核消息
        
        [self loadQunNewsDataShenHe];
    }
    
}

- (void)registerQunNewsTabCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTJoinQunCell" bundle:nil];
    
    [_QunNewsTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
}

- (void)loadQunNewsData{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDesDict[@"GroupId"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_GetApplyUserList;
    
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataJoinArr removeAllObjects];
            [dataJoinArr addObjectsFromArray:resultDict[@"UserList"]];
            
            [_QunNewsTabV reloadData];
            
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [WKProgressHUD popMessage:@"暂无申请列表" inView:nil duration:0.5 animated:YES];
            [dataJoinArr removeAllObjects];
            [_QunNewsTabV reloadData];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
}

- (void)loadQunNewsDataShenHe{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDesDict[@"GroupId"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_GetNeedCheckInviteUserGroupList;
    
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataJoinArr removeAllObjects];
            [dataJoinArr addObjectsFromArray:resultDict[@"UserList"]];
            
            [_QunNewsTabV reloadData];
            
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [WKProgressHUD popMessage:@"暂无申请列表" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataJoinArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    WTJoinQunCell *cell = (WTJoinQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTJoinQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (_JoinType == 0) {
        
        cell.contentName.text = [NSString NULLToString:dataJoinArr[indexPath.row][@"NickName"]];
        cell.auditLab.text = [NSString stringWithFormat:@"我是%@",dataJoinArr[indexPath.row][@"NickName"]];
    }else{
        
        //申请
    }
    
    cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
    
    //传值
    objc_setAssociatedObject(cell.agreeBtn, @"ApplyUserId", [NSString NULLToString:dataJoinArr[indexPath.row][@"UserId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//邀请人id
    objc_setAssociatedObject(cell.JuJueBtn, @"ApplyUserId", [NSString NULLToString:dataJoinArr[indexPath.row][@"UserId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//邀请人id
    [cell.agreeBtn addTarget:self action:@selector(agreeBtnJoinQunClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.JuJueBtn addTarget:self action:@selector(JuJueBtnJoinQunClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//同意
- (void)agreeBtnJoinQunClick:(UIButton *)btn{
    
    NSString *ApplyUserId = objc_getAssociatedObject(btn, @"ApplyUserId");
    NSString *GroupId = [NSString NULLToString:_dataQunDesDict[@"GroupId"]];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",ApplyUserId,@"ApplyUserId",@"1",@"DealType",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_ApplyDeal;
    NSLog(@"%@", parameters);
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            if (_JoinType == 0) {
                
                [self loadQunNewsData];
            }else{
                
                [self loadQunNewsDataShenHe];
            }
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
    
}

//拒绝
- (void)JuJueBtnJoinQunClick:(UIButton *)btn{
    
    NSString *ApplyUserId = objc_getAssociatedObject(btn, @"ApplyUserId");
    NSString *GroupId = [NSString NULLToString:_dataQunDesDict[@"GroupId"]];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",ApplyUserId,@"ApplyUserId",@"2",@"DealType",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_ApplyDeal;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            if (_JoinType == 0) {
                
                [self loadQunNewsData];
            }else{
                
                [self loadQunNewsDataShenHe];
            }
            
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
