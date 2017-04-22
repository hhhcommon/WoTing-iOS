//
//  WTQunDetailsController.m
//  WOTING
//
//  Created by jq on 2017/4/11.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunDetailsController.h"

#import "WTFriendDetailsController.h"   //好友详情

#import "WTQunDetailsCell.h"    //群二维码
#import "WTQunQianMingCell.h"   //群签名入口
#import "WTQunQMContentCell.h"  //群签名内容
#import "WTQunMemberCell.h"     //群成员
#import "WTQunShouQiCell.h"


#import "SGGenerateQRCodeVC.h"  //二维码页面

#import "WTQunManageController.h"   //群选择界面(复用)
#import "WTQunNewsController.h" //群审核,加群消息
#import "WTQunPsdController.h"  //修改群密码
#import "WTQunSetManageController.h"    //设置群管理

#import "WTQunCell.h"       //群详情内标题

#import "WTQuitQunCell.h"   //退出按钮

@interface WTQunDetailsController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *dataMembersArr;     //成员列表数组
    
    NSInteger   QunQianM;   //群签名内容高度
    NSInteger   QunMember;  //群成员高度
    BOOL    isQunZhu;  //是否是群主
    BOOL    isManager;  //是否是管理员
    BOOL    isShouQi;   //收起or显示
    
   // BOOL    isSuccess; //判断修改群资料是否成功
}

@end

@implementation WTQunDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataMembersArr = [NSMutableArray arrayWithCapacity:0];
    QunQianM = 0;
    QunMember = 0;
    isQunZhu = NO;
    isManager = NO;
    _ContentTextfield.hidden = YES;
    _QunNameTextfield.hidden = YES;
    
    _QunDetailsTabV.delegate = self;
    _QunDetailsTabV.dataSource = self;
    
    _QunDetailsTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _QunDetailsTabV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    //隐藏系统cell线
    _QunDetailsTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    [self loadMemberData];
    [self createHeader];
    [self rigisterQunDeTabCell];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self createHeader];
    [_QunDetailsTabV reloadData];
}

- (void)rigisterQunDeTabCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTQunDetailsCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *cellQMNib = [UINib nibWithNibName:@"WTQunQianMingCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellQMNib forCellReuseIdentifier:@"cellQM"];
    
    UINib *cellQMConNib = [UINib nibWithNibName:@"WTQunQMContentCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellQMConNib forCellReuseIdentifier:@"cellQMCon"];
    
    UINib *cellCYNib = [UINib nibWithNibName:@"WTQunMemberCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellCYNib forCellReuseIdentifier:@"cellCY"];
    
    UINib *cellSQNib = [UINib nibWithNibName:@"WTQunShouQiCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellSQNib forCellReuseIdentifier:@"cellSQ"];
    
    
    UINib *cellBTNib = [UINib nibWithNibName:@"WTQunCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellBTNib forCellReuseIdentifier:@"cellBT"];
    
    //退出
    UINib *cellQTNib = [UINib nibWithNibName:@"WTQuitQunCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellQTNib forCellReuseIdentifier:@"cellQT"];
}

//填充界面
- (void)createHeader{
    /*[0]	(null)	@"GroupId" : @"0bf2a246cf42"
     [1]	(null)	@"GroupNum" : @"794500"
     [2]	(null)	@"GroupSignature" : @"群"
     [3]	(null)	@"GroupCreator" : @"a855e41850b9"
     [4]	(null)	@"GroupType" : (long)0
     [5]	(null)	@"GroupCount" : (long)0
     [6]	(null)	@"GroupManager" : @"a855e41850b9"
     [7]	(null)	@"GroupName" : @"公开测试群"
     [8]	(null)	@"GroupMasterId" : @"a855e41850b9"	*/
    
    _QunDetailsView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(QunDeViewTap)];
    [_QunDetailsView addGestureRecognizer:tapView];
    
    if (_dataQunDict.count) {
        //图片
        if ([[NSString NULLToString:_dataQunDict[@"PortraitBig"]] hasPrefix:@"http"]) {
            [_contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataQunDict[@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
        }else if ([NSString NULLToString:_dataQunDict[@"PortraitBig"]].length){
            
            [_contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataQunDict[@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
            
        }else{
            
            _contentImgV.image = [UIImage imageNamed:@"Qun_header.png"];
        }
        
        //文字
        _ContentName.text = [NSString NULLToString:_dataQunDict[@"GroupName"]];
        _QunNumber.text = [NSString stringWithFormat:@"群号: %@",[NSString NULLToString:_dataQunDict[@"GroupNum"]]];
        _QunName.text = [NSString NULLToString:_dataQunDict[@"GroupSignature"]];
        
        //判断群主
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        if ([uid isEqualToString:_dataQunDict[@"GroupMasterId"]]) {
            
            isQunZhu = YES;
        }else{
            
            isQunZhu = NO;
            if ([uid isEqualToString:_dataQunDict[@"GroupManager"]]) {
                
                isManager = YES;
            }else{
                
                isManager = NO;
            }
        }
        
        
    }
    
    
}

- (void)loadMemberData{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_GroupMembers;
    
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataMembersArr removeAllObjects];
            [dataMembersArr addObjectsFromArray:resultDict[@"UserList"]];
            
            if (!isManager && !isQunZhu) {  //判断群主
                
                if (dataMembersArr.count >4) {
                    
                    QunMember = K_Screen_Width/4;
                }
            }else{
                if (dataMembersArr.count >2) {
                    
                    QunMember = K_Screen_Width/4;
                }
            }
            
            [_QunDetailsTabV reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        if (_QunDetailsType == 1) { //公开群
            
            if (isQunZhu) { //群主
                
                return 8;
            }else{
                
                return 6;
            }
        }else if (_QunDetailsType == 2){    //密码群
            
            if (isQunZhu) { //群主
                
                return 9;
            }else if (isManager){   //管理
                
                return 7;
            }else{
                
                return 6;
            }
            
        }else{  //审核群
            
            if (isQunZhu) { //群主
                
                return 10;
            }else if (isManager){   //管理
                
                return 8;
            }else{
                
                return 6;
            }
        }
  
    }else{
        
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 60;
        }else if (indexPath.row == 1){
            
            return 54;
        }else if (indexPath.row == 2){
            
            if (isShouQi) {
                
                return 0;
            }else{
                return 44;
            }
        }else if (indexPath.row == 3){
            
            return 21;
        }else if (indexPath.row == 4){
            
            return 60;
        }else if (indexPath.row == 5){
            
            if (QunMember == 0) {
                
                return K_Screen_Width/4;
            }else{
                return K_Screen_Width/2;
            }
        }else{
            
            return 60;
        }
       
    }else {
        
        return 60;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0;
    }else if(section == 1){
        
        return 10;
    }else{
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {   //群二维码
        
        if (indexPath.row == 0) {
            
            static NSString *cellID = @"cellID";
            
            WTQunDetailsCell *cell = (WTQunDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }else if (indexPath.row == 1){  //群签名
            
            static NSString *cellID = @"cellQM";
            
            WTQunQianMingCell *cell = (WTQunQianMingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunQianMingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
        }else if (indexPath.row == 2){  //群签名内容
            
            static NSString *cellID = @"cellQMCon";
            
            WTQunQMContentCell *cell = (WTQunQMContentCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunQMContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (isShouQi) {
                
                cell.hidden = YES;
            }else{
                
                cell.hidden = NO;
            }
            
            return cell;
            
        }else if (indexPath.row == 3){  //收起
            
            static NSString *cellID = @"cellSQ";
            
            WTQunShouQiCell *cell = (WTQunShouQiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunShouQiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.shouQiBtn addTarget:self action:@selector(shouQiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            return cell;
        }else if (indexPath.row == 4){  //群成员标题
            
            static NSString *cellID = @"cellBT";
            
            WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
          //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.QunLab.text = @"全部成员";
            
            return cell;
        }else if (indexPath.row == 5){  //群成员
            
            static NSString *cellID = @"cellCY";
            
            WTQunMemberCell *cell = (WTQunMemberCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegateQunMem = self;
            cell.dataQunMemArr = dataMembersArr;
            cell.dataQunDedict = _dataQunDict;  //群资料
            
            if (dataMembersArr.count) {
                
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setObject:dataMembersArr forKey:@"JQARR"];
                
                if (!isQunZhu && !isManager) {  //不是群主和管理
                    
                    [dict setObject:@"JQ" forKey:@"JQCY"];
                }
                NSDictionary *dictjq = [NSDictionary dictionaryWithDictionary:dict];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RELOADCOLLECTION" object:nil userInfo:dictjq];
            }
            return cell;
        }else if (indexPath.row == 6){
            
            if (_QunDetailsType == 1) {
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"设置管理员";
                
                return cell;
            }else if (_QunDetailsType == 2){
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"更改群密码";
                
                return cell;
            }else{
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"加群消息";
                
                return cell;
            }
            
            
        }else if (indexPath.row == 7){
            
            if (_QunDetailsType == 1) {
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                
                cell.QunLab.text = @"移交群主权限";
                
                return cell;
            }else if (_QunDetailsType == 2){
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"设置管理员";
                
                return cell;
            }else{
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"审核消息";
                
                return cell;
            }
            
        }else if (indexPath.row == 8){
            
            if (_QunDetailsType == 2){
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"移交群主权限";
                
                return cell;
            }else{
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"设置管理员";
                
                return cell;
            }
            
        }else if (indexPath.row == 9){
            
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.QunLab.text = @"移交群主权限";
                
                return cell;
            
        }
        
    }else if(indexPath.section == 1) {
        
        static NSString *cellID = @"cellQT";
        
        WTQuitQunCell *cell = (WTQuitQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQuitQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.QuitBtn addTarget:self action:@selector(QuitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
        
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
            VC.dict = _dataQunDict;
            
            VC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:VC animated:YES];
        }else if (indexPath.row == 1){
            
            NSLog(@"设置群签名");
        }else if (indexPath.row == 4){
            //查看群成员
            WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
            wtQunMVC.dataManageArr = dataMembersArr;
            wtQunMVC.contentText = [NSString stringWithFormat:@"全部成员(%lu)", dataMembersArr.count];
            wtQunMVC.QunType = 0;
            wtQunMVC.SureBtn.hidden = YES;
            wtQunMVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wtQunMVC animated:YES];

            
        }else if (indexPath.row == 6){
            
            if (_QunDetailsType == 1) {
                
//                WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
//                wtQunMVC.dataManageArr = dataMembersArr;
//                wtQunMVC.contentText = @"设置群管理";
//                wtQunMVC.QunType = 2;
//                wtQunMVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:wtQunMVC animated:YES];
                WTQunSetManageController *wtQunMVC = [[WTQunSetManageController alloc] init];
                wtQunMVC.dataQunManageArr = dataMembersArr;
                
                wtQunMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunMVC animated:YES];
            }else if (_QunDetailsType == 2){
                
                WTQunPsdController *wtQunPsdVC = [[WTQunPsdController alloc] init];
                wtQunPsdVC.dataQunDict = _dataQunDict;
                wtQunPsdVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunPsdVC animated:YES];
            }else{
                
                WTQunNewsController *wtQunNewVC = [[WTQunNewsController alloc] init];
                wtQunNewVC.dataQunDesDict = _dataQunDict;
                wtQunNewVC.contentQunName = @"加群消息";
                wtQunNewVC.JoinType = 0;
                wtQunNewVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunNewVC animated:YES];
            }
            
            
        }else if (indexPath.row == 7){
            
            if (_QunDetailsType == 1) {
                
                WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
                wtQunMVC.dataManageArr = dataMembersArr;
                wtQunMVC.dataQunDeDict = _dataQunDict;
                wtQunMVC.contentText = @"移交群管理权限";
                wtQunMVC.QunType = 1;
                wtQunMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunMVC animated:YES];
            }else if (_QunDetailsType == 2){
                //群管理
                WTQunSetManageController *wtQunMVC = [[WTQunSetManageController alloc] init];
                wtQunMVC.dataQunManageArr = dataMembersArr;
                
                wtQunMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunMVC animated:YES];
                
            }else{
                
                WTQunNewsController *wtQunNewVC = [[WTQunNewsController alloc] init];
                wtQunNewVC.dataQunDesDict = _dataQunDict;
                wtQunNewVC.contentQunName = @"审核消息";
                wtQunNewVC.JoinType = 1;
                wtQunNewVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunNewVC animated:YES];
            }
            
        }else if (indexPath.row == 8){
            
            if (_QunDetailsType == 2){
                
                WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
                wtQunMVC.dataManageArr = dataMembersArr;
                wtQunMVC.dataQunDeDict = _dataQunDict;
                wtQunMVC.contentText = @"移交群管理权限";
                wtQunMVC.QunType = 1;
                wtQunMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunMVC animated:YES];
                
            }else{
                
                WTQunSetManageController *wtQunMVC = [[WTQunSetManageController alloc] init];
                wtQunMVC.dataQunManageArr = dataMembersArr;
                
                wtQunMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunMVC animated:YES];
            }
        }else if (indexPath.row == 9){
            
            WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
            wtQunMVC.dataManageArr = dataMembersArr;
            wtQunMVC.dataQunDeDict = _dataQunDict;
            wtQunMVC.contentText = @"移交群管理权限";
            wtQunMVC.QunType = 1;
            wtQunMVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:wtQunMVC animated:YES];
        }
    }else{
        
        
    }
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

- (void)shouQiBtnClick:(UIButton *)btn{
    
    if (btn.selected) {
        
        btn.selected = NO;
        isShouQi = NO;
        [_QunDetailsTabV reloadData];
    }else{
        
        btn.selected = YES;
        isShouQi = YES;
        [_QunDetailsTabV reloadData];
    }
    
}

//发起退出群组请求
- (void)QuitBtnClick:(UIButton *)btn {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_ExitGroup;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [WKProgressHUD popMessage:@"退出组成功" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
    
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//对讲功能
- (IBAction)DuiJiangBtnClick:(id)sender {
}

//编辑群资料
- (IBAction)BianJiBtnClick:(id)sender {
    
    if (_XiuGaiBtn.selected) {
        
        _XiuGaiBtn.selected = NO;
        _ContentTextfield.hidden = YES;
        _QunNameTextfield.hidden = YES;
        
        [_ContentTextfield resignFirstResponder];
        [_QunNameTextfield resignFirstResponder];
        [self isUpdateGroupSuccess:^(BOOL succ) {   //修改群资料返回
            
            if (succ) {
                
                _ContentName.text = _ContentTextfield.text;
                _QunName.text = _QunNameTextfield.text;
            }else{
                
                
            }
        }];
        
    }else{
        
        _ContentTextfield.hidden = NO;
        _QunNameTextfield.hidden = NO;
        
        _ContentTextfield.text = _ContentName.text;
        _QunNameTextfield.text = _QunName.text;
        _XiuGaiBtn.selected = YES;
    }
    
}

- (void)isUpdateGroupSuccess:(JQComplete)success{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
    
    NSString *GroupName;
    if (_ContentTextfield.text.length >0) {
        
        GroupName = _ContentTextfield.text;
    }else{
        
        GroupName = _ContentName.text;
    }
    
    NSString *Descn;
    if (_QunNameTextfield.text.length >0) {
        
        Descn = _QunNameTextfield.text;
    }else{
        
        Descn = _ContentName.text;
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupName,@"GroupName",Descn,@"Descn",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_UpdateGroup;
    
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            success(YES);
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            success(NO);
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
            
            success(NO);
        }
        
    } fail:^(NSError *error) {
        
        success(NO);
    }];
    
    
    
    
}

//取消键盘
- (void)QunDeViewTap{
    
    [_ContentTextfield resignFirstResponder];
    [_QunNameTextfield resignFirstResponder];
}


@end
