//
//  WTQunDetailsController.m
//  WOTING
//
//  Created by jq on 2017/4/11.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunDetailsController.h"

#import "WTFriendDetailsController.h"   //好友详情

#import "WTQunAndFriendDetailsCell.h"   //群详情
#import "WTQunDetailsCell.h"    //群二维码
#import "WTQunQianMingCell.h"   //群签名入口
#import "WTQunQMContentCell.h"  //群签名内容
#import "WTQunMemberCell.h"     //群成员
#import "WTQunShouQiCell.h"

#import "WTFriDetailQMingCell.h"        //加群签名
#import "WTFriAddFCell.h"               //加群验证

#import "SGGenerateQRCodeVC.h"  //二维码页面

#import "WTQunManageController.h"   //群选择界面(复用)
#import "WTQunNewsController.h" //群审核,加群消息
#import "WTQunPsdController.h"  //修改群密码
#import "WTQunSetManageController.h"    //设置群管理
#import "WTQunSignChangeController.h"   //修改签名

#import "WTQunCell.h"       //群详情内标题

#import "WTQuitQunCell.h"   //退出按钮

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

@interface WTQunDetailsController ()<UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, WTQunQMContentCellDelegate>{
    
    NSMutableArray *dataMembersArr;     //成员列表数组
    
    NSInteger   QunQianM;   //群签名内容高度
    NSInteger   QunMember;  //群成员高度
    BOOL    isQunZhu;  //是否是群主
    BOOL    isManager;  //是否是管理员
    BOOL    isShouQi;   //收起or显示
    
    BOOL    isJoin;     //判断当前是否是群成员
    
    BOOL    isSuccess; //判断修改群资料是否成功
    
    NSString *Beizhu;
    NSString *nikcName;
    NSString *JiaQun;
}

//监听键盘
@property (nonatomic,strong)UITapGestureRecognizer *keyboardTap;
@property (nonatomic, assign) NSInteger keyboardTagRow;//键盘弹出，界面上滑
@property (nonatomic, assign) NSInteger keyboardTagSection;//键盘弹出，界面上滑
@property (nonatomic, assign) CGFloat scrollFloat;//键盘弹出，界面上滑

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
    
    
    [self createHeader];
    [self rigisterQunDeTabCell];
}


- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self createHeader];
    [_QunDetailsTabV reloadData];
    
    [self addKeyboardNotification];//键盘监听
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //释放
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)isMember{   //是否是群成员
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    for (NSDictionary *dict in dataMembersArr) {
        
        if ([dict[@"UserId"] isEqualToString:uid]) {
            
            isJoin = YES;
            break;
        }else{
            
            isJoin = NO;
        }
    }
    
}

- (void)rigisterQunDeTabCell{
    
    UINib *cellADNib = [UINib nibWithNibName:@"WTFriAddFCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellADNib forCellReuseIdentifier:@"cellAD"];
    
    UINib *cellFQMNib = [UINib nibWithNibName:@"WTFriDetailQMingCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellFQMNib forCellReuseIdentifier:@"cellFQM"];
    
    UINib *cellQFNib = [UINib nibWithNibName:@"WTQunAndFriendDetailsCell" bundle:nil];
    
    [_QunDetailsTabV registerNib:cellQFNib forCellReuseIdentifier:@"cellQF"];
    
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
 
    //判断群主
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    if ([uid isEqualToString:_dataQunDict[@"GroupMasterId"]]) {
        
        isQunZhu = YES;
    }else{  //判断管理员
        
        isQunZhu = NO;
        NSArray *ManageArr;
        if ([_dataQunDict[@"GroupManager"] containsString:@","]) {  //多管理员
            
            ManageArr = [_dataQunDict[@"GroupManager"] componentsSeparatedByString:@","];
            
            for (NSString *MStr in ManageArr) {
                
                if ([uid isEqualToString:MStr]) {
                    
                    isManager = YES;
                    break;
                }else{
                    
                    isManager = NO;
                }
            }
        }else{
            
            if ([uid isEqualToString:_dataQunDict[@"GroupManager"]]) {
                
                isManager = YES;
            }else{
                
                isManager = NO;
            }
        }
        
    }

    
    [self loadMemberData];  //得到群成员
    
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
            
            //判断当前是否是群成员
            [self isMember];
            
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
    
    if (isJoin) {   //是群成员
        
        if (section == 0) {
            
            if (_QunDetailsType == 1) { //公开群
                
                if (isQunZhu) { //群主
                    
                    return 9;
                }else{
                    
                    return 7;
                }
            }else if (_QunDetailsType == 2){    //密码群
                
                if (isQunZhu) { //群主
                    
                    return 10;
                }else if (isManager){   //管理
                    
                    return 8;
                }else{
                    
                    return 7;
                }
                
            }else{  //审核群
                
                if (isQunZhu) { //群主
                    
                    return 11;
                }else if (isManager){   //管理
                    
                    return 9;
                }else{
                    
                    return 7;
                }
            }
            
        }else{
            
            return 1;
        }
        
    }else{  //不是群成员
        
        if (section == 0) {
            
            if (_QunDetailsType == 1) { //公开群
                
                
                return 3;
            }else if (_QunDetailsType == 2){    //密码群
                
                return 5;
                
            }else{  //审核群
                
                return 5;
            }
            
        }else{
            
            return 1;
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isJoin) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                return 200;
            }else if (indexPath.row == 1){
                
                return 60;
                
            }else if (indexPath.row == 2){
                
                return 54;
                
            }else if (indexPath.row == 3){
                
                if (isShouQi) {
                    
                    return 50;
                }else{
                    return 50 + QunQianM;
                }
            
            }else if (indexPath.row == 4){
                
                return 30;
                
            }else if (indexPath.row == 5){
                
                return 60;
                
            }else if (indexPath.row == 6){
                
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
    }else{
    
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                return 200;
            }else if (indexPath.row == 1){
                
                return 54;
                
            }else if (indexPath.row == 2){
                
                if (isShouQi) {
                    
                    return 50;
                }else{
                    return 50 + QunQianM;
                }
            
            }else if (indexPath.row == 3){
                
                return 21;
                
            }else if (indexPath.row == 4){
                
                return 120;
                
            }else{
                
                return 0; //没有这个
            }
           
        }else {
            
            return 60;
        }
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (isJoin) {
        
        if (section == 0) {
            
            return 0;
        }else{
            
            return 10;
        }
    }else{  //未加入群组
        
        if (section == 0) {
            
            return 0;
        }else{
            
            return 100;
        }
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isJoin) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                static NSString *cellID = @"cellQF";
                
                WTQunAndFriendDetailsCell *cell = (WTQunAndFriendDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunAndFriendDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (_dataQunDict.count) {
                    //图片
                    if ([[NSString NULLToString:_dataQunDict[@"PortraitBig"]] hasPrefix:@"http"]) {
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataQunDict[@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
                    }else if ([NSString NULLToString:_dataQunDict[@"PortraitBig"]].length){
                        
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataQunDict[@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
                        
                    }else{
                        
                        cell.contentImgV.image = [UIImage imageNamed:@"Qun_header.png"];
                    }
                    
                    if (isManager || isQunZhu) {
                        
                        cell.contentImgV.userInteractionEnabled = YES;
                        UITapGestureRecognizer *imgVTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentImgVTap)];
                        [cell.contentImgV addGestureRecognizer:imgVTap];
                        
                        
                    }
                    
                    cell.BianjiBtn.hidden = NO;
                    cell.DuiJiangBtn.hidden = NO;
                    
                    //文字[8]	(null)	@"GroupMyAlias" : @"德玛三群"
                    cell.BeiZhuLab.text = [NSString NULLToString:_dataQunDict[@"GroupMyAlias"]];
                    cell.DetailsLab.text = [NSString stringWithFormat:@"群号: %@",[NSString NULLToString:_dataQunDict[@"GroupNum"]]];
                    cell.NickLab.text = [NSString stringWithFormat:@"群名:%@", [NSString NULLToString:_dataQunDict[@"GroupName"]]];
                }
                
                
                [cell.DuiJiangBtn addTarget:self action:@selector(DuiJiangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BianjiBtn addTarget:self action:@selector(BianJiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BeiZhuTextF addTarget:self action:@selector(BeiZhuChange:) forControlEvents:UIControlEventEditingChanged];
                [cell.NickTextF addTarget:self action:@selector(NickChange:) forControlEvents:UIControlEventEditingChanged];
                
                NSString *GroupName = [NSString NULLToString:_dataQunDict[@"GroupName"]];
                if (cell.BianjiBtn.selected) {
                    
                    if (isQunZhu || isManager) {//群主或管理
                        
                        cell.BeiZhuTextF.hidden = NO;
                        cell.NickTextF.hidden = NO;
                        
                        if (Beizhu.length >0) {
                            
                            cell.BeiZhuTextF.text = Beizhu;
                        }else{
                            
                            cell.BeiZhuTextF.text = cell.BeiZhuLab.text;
                        }
                        
                        if (nikcName.length > 0) {
                            
                            cell.NickTextF.text = nikcName;
                        }else{
                            
                            cell.NickTextF.text = GroupName;
                        }
                    }else{  //群众
                        
                        cell.BeiZhuTextF.hidden = NO;
                        
                        if (Beizhu.length >0) {
                            
                            cell.BeiZhuTextF.text = Beizhu;
                        }else{
                            
                            cell.BeiZhuTextF.text = cell.BeiZhuLab.text;
                        }
                    }
                   
                }else{
                    
                    cell.BeiZhuTextF.hidden = YES;
                    cell.NickTextF.hidden = YES;
                    
                    [cell.BeiZhuTextF resignFirstResponder];
                    [cell.NickTextF resignFirstResponder];
                    
                    if (isSuccess) {
                        
                        if (Beizhu.length >0) {
                            
                            cell.BeiZhuLab.text = Beizhu;
                        }
                        
                        if (nikcName.length > 0) {
                            
                            cell.NickLab.text = [NSString stringWithFormat:@"群名:%@", nikcName];
                        }
                        
                    }else{
                        
                        cell.BeiZhuLab.text = [NSString NULLToString:_dataQunDict[@"GroupMyAlias"]];
                        cell.NickLab.text = [NSString stringWithFormat:@"群名:%@", [NSString NULLToString:_dataQunDict[@"GroupName"]]];
                    }
                }
                
                return cell;
                
            }else if (indexPath.row == 1) { //群二维码
                
                static NSString *cellID = @"cellID";
                
                WTQunDetailsCell *cell = (WTQunDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                return cell;
            }else if (indexPath.row == 2){  //群签名
                
                static NSString *cellID = @"cellQM";
                
                WTQunQianMingCell *cell = (WTQunQianMingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunQianMingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                return cell;
            }else if (indexPath.row == 3){  //群签名内容
                
                static NSString *cellID = @"cellQMCon";
                
                WTQunQMContentCell *cell = (WTQunQMContentCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunQMContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell cellWithString:[NSString NULLToString:_dataQunDict[@"GroupSignature"]]];  //设置群签名
                
                cell.delegate = self;
                
                if (isShouQi) {
                    
                    cell.contentLab.numberOfLines = 1;
                    cell.ContentLabHeight.constant = 21;
                }else{
                    
                    cell.contentLab.numberOfLines = 0;
                }
                
                return cell;
                
            }else if (indexPath.row == 4){  //收起
                
                static NSString *cellID = @"cellSQ";
                
                WTQunShouQiCell *cell = (WTQunShouQiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunShouQiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.shouQiBtn addTarget:self action:@selector(shouQiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                return cell;
            }else if (indexPath.row == 5){  //群成员标题
                
                static NSString *cellID = @"cellBT";
                
                WTQunCell *cell = (WTQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                //  cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.QunLab.text = [NSString stringWithFormat:@"全部成员(%lu)",dataMembersArr.count];
                
                return cell;
            }else if (indexPath.row == 6){  //群成员
                
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
            }else if (indexPath.row == 7){
                
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
                
                
            }else if (indexPath.row == 8){
                
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
                
            }else if (indexPath.row == 9){
                
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
                
            }else if (indexPath.row == 10){
                
                
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
            
            [cell.QuitBtn addTarget:self action:@selector(QuitBtnQunClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.QuitBtn setTitle:@"退出群组" forState:UIControlStateNormal];
            cell.QuitBtn.backgroundColor = [UIColor JQTColor];
            
            return cell;
            
        }

    }else{
    
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                static NSString *cellID = @"cellQF";
                
                WTQunAndFriendDetailsCell *cell = (WTQunAndFriendDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunAndFriendDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.BianjiBtn.hidden = YES;
                cell.DuiJiangBtn.hidden = YES;
                cell.BeiZhuTextF.hidden = YES;
                cell.NickTextF.hidden = YES;
                
                if (_dataQunDict.count) {
                    //图片
                    if ([[NSString NULLToString:_dataQunDict[@"PortraitBig"]] hasPrefix:@"http"]) {
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataQunDict[@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
                    }else if ([NSString NULLToString:_dataQunDict[@"PortraitBig"]].length){
                        
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataQunDict[@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
                        
                    }else{
                        
                        cell.contentImgV.image = [UIImage imageNamed:@"Qun_header.png"];
                    }
                    
                    //文字
                    cell.BeiZhuLab.text = [NSString NULLToString:_dataQunDict[@"GroupMyAlias"]];
                    cell.DetailsLab.text = [NSString stringWithFormat:@"群号: %@",[NSString NULLToString:_dataQunDict[@"GroupNum"]]];
                    cell.NickLab.text = [NSString NULLToString:_dataQunDict[@"GroupName"]];
                }
                
                
                return cell;
                
            }else if (indexPath.row == 1) { //群签名
                
                static NSString *cellID = @"cellQM";
                
                WTQunQianMingCell *cell = (WTQunQianMingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunQianMingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                return cell;
            }else if (indexPath.row == 2) { //群签名内容
                
                static NSString *cellID = @"cellQMCon";
                
                WTQunQMContentCell *cell = (WTQunQMContentCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunQMContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                [cell cellWithString:[NSString NULLToString:_dataQunDict[@"GroupSignature"]]];  //设置群签名
                
                cell.delegate = self;
                
                if (isShouQi) {
                    
                    cell.contentLab.numberOfLines = 1;
                    cell.ContentLabHeight.constant = 21;
                }else{
                    
                    cell.contentLab.numberOfLines = 0;
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
            }else if (indexPath.row == 4){  //加群验证
                
                static NSString *cellID = @"cellAD";
                
                WTFriAddFCell *cell = (WTFriAddFCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTFriAddFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.HaoyouLab.text = @"加群验证";
                
                if (_QunDetailsType == 2) {
                    
                    cell.ContentTextF.placeholder = @"请输入群密码";
                }else{
                    
                    cell.ContentTextF.placeholder = @"请输入验证信息";
                }
                
                [cell.ContentTextF addTarget:self action:@selector(jiaQunYanZheng:) forControlEvents:UIControlEventEditingChanged];
                
                return cell;
                
            }            
        }else if(indexPath.section == 1) {
            
            static NSString *cellID = @"cellQT";
            
            WTQuitQunCell *cell = (WTQuitQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQuitQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.QuitBtn addTarget:self action:@selector(QuitBtnQunClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (_QunDetailsType == 1) {
                
                [cell.QuitBtn setTitle:@"加入群组" forState:UIControlStateNormal];
                cell.QuitBtn.backgroundColor = [UIColor JQTColor];
                
            }else{
                
                [cell.QuitBtn setTitle:@"申请入群" forState:UIControlStateNormal];
                cell.QuitBtn.backgroundColor = [UIColor JQTColor];
                
            }
            
            return cell;
            
        }
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isJoin) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 1) {
                
                SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
                VC.dict = _dataQunDict;
                
                VC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:VC animated:YES];
            }else if (indexPath.row == 2){  //修改群签名
                
                if (isQunZhu || isManager) {
                    
                    WTQunSignChangeController *qunSignVC = [[WTQunSignChangeController alloc] init];
                    [qunSignVC setSignStrChange:^(NSString *SignStr) {

                        if (SignStr.length >0) {
                            
                            NSMutableDictionary *TDict = [NSMutableDictionary dictionaryWithCapacity:0];
                            
                            [TDict addEntriesFromDictionary:_dataQunDict];
                            
                            [TDict setObject:SignStr forKey:@"GroupSignature"];
                            
                            _dataQunDict = [NSDictionary dictionaryWithDictionary:TDict];
                        }
                    }];
                    qunSignVC.dataQunDeditc = _dataQunDict;
                    qunSignVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:qunSignVC animated:YES];
                }else{
                    
                    //没有权限修改
                }
                
            }else if (indexPath.row == 5){
                //查看群成员
                WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
                wtQunMVC.dataManageArr = dataMembersArr;
                wtQunMVC.dataQunDeDict = _dataQunDict;
                wtQunMVC.contentText = [NSString stringWithFormat:@"全部成员(%lu)", dataMembersArr.count];
                wtQunMVC.QunType = 0;
                wtQunMVC.SureBtn.hidden = YES;
                wtQunMVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:wtQunMVC animated:YES];
                
                
            }else if (indexPath.row == 7){
                
                if (_QunDetailsType == 1) { //设置群管理
                    
                    WTQunSetManageController *wtQunMVC = [[WTQunSetManageController alloc] init];
                    wtQunMVC.dataQunManageArr = dataMembersArr;
                    wtQunMVC.dataQunDetilDict = _dataQunDict;
                    wtQunMVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:wtQunMVC animated:YES];
                }else if (_QunDetailsType == 2){    //修改群密码
                    
                    WTQunPsdController *wtQunPsdVC = [[WTQunPsdController alloc] init];
                    [wtQunPsdVC setPsdChange:^(NSString *NewPad) {
                        
                        if (NewPad.length > 0) {
                            
                            NSMutableDictionary *TDict = [NSMutableDictionary dictionaryWithCapacity:0];
                            
                            [TDict addEntriesFromDictionary:_dataQunDict];
                            
                            [TDict setObject:NewPad forKey:@"GroupPassword"];
                            
                            _dataQunDict = [NSDictionary dictionaryWithDictionary:TDict];
                           // [_dataQunDict setValue:NewPad forKey:@"GroupPassword"];
                        }
                    }];
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
                
                
            }else if (indexPath.row == 8){
                
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
                    wtQunMVC.dataQunDetilDict = _dataQunDict;
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
                
            }else if (indexPath.row == 9){
                
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
                    wtQunMVC.dataQunDetilDict = _dataQunDict;
                    wtQunMVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:wtQunMVC animated:YES];
                }
            }else if (indexPath.row == 10){
                
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

    }else{  //收起
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 3){
                
                NSLog(@"收起");
            }
        }
        
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
        QunQianM = 21;
        [_QunDetailsTabV reloadData];
    }
    
}

//发起退出群组请求 或者加群
- (void)QuitBtnQunClick:(UIButton *)btn {
    
    if (isJoin) {   //退群
        
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
        
    }else{  //加群
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSString *GroupNum = [NSString NULLToString:_dataQunDict[@"GroupNum"]];
        
        NSDictionary *parameters;
        
        NSString *login_Str;
        
        if (_QunDetailsType == 1) { //公开群
            
            login_Str = WoTing_JoinInGroup;
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupNum,@"GroupNum",uid,@"UserId",nil];
            
            [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
                
                NSDictionary *resultDict = (NSDictionary *)response;
                
                NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
                if ([ReturnType isEqualToString:@"1001"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [WKProgressHUD popMessage:@"加入组成功" inView:nil duration:0.5 animated:YES];
                }else if ([ReturnType isEqualToString:@"T"]){
                    
                    [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
                }else if ([ReturnType isEqualToString:@"200"]){
                    
                    [AutomatePlist writePlistForkey:@"Uid" value:@""];
                    [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
                }
                
            } fail:^(NSError *error) {
                
                
            }];
        }else if (_QunDetailsType == 2){    //密码群
            
            login_Str = WoTing_JoinInGroup;
            
            
            if (JiaQun.length >= 6) {
                
                parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupNum,@"GroupNum",uid,@"UserId",JiaQun,@"GroupPwd",nil];
                
                [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
                    
                    NSDictionary *resultDict = (NSDictionary *)response;
                    
                    NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
                    if ([ReturnType isEqualToString:@"1001"]) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                        [WKProgressHUD popMessage:@"加入组成功" inView:nil duration:0.5 animated:YES];
                    }else if ([ReturnType isEqualToString:@"T"]){
                        
                        [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
                    }else if ([ReturnType isEqualToString:@"200"]){
                        
                        [AutomatePlist writePlistForkey:@"Uid" value:@""];
                        [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
                    }else if ([ReturnType isEqualToString:@"1006"]){
                        
                        [WKProgressHUD popMessage:@"群密码不正确" inView:nil duration:0.5 animated:YES];
                    }else if ([ReturnType isEqualToString:@"1007"]){
                        
                        [WKProgressHUD popMessage:@"群密码不正确" inView:nil duration:0.5 animated:YES];
                    }
                    
                } fail:^(NSError *error) {
                    
                    
                }];
            }else if (JiaQun.length == 0){
                
                [WKProgressHUD popMessage:@"请输入群密码" inView:nil duration:0.5 animated:YES];
            }else{
                
                [WKProgressHUD popMessage:@"群密码不正确" inView:nil duration:0.5 animated:YES];
            }
            
            
        }else { //验证群
            
            NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
            
            login_Str = WoTing_GroupApply;
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",JiaQun,@"ApplyMsg",nil];
            
            [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
                
                NSDictionary *resultDict = (NSDictionary *)response;
                
                NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
                if ([ReturnType isEqualToString:@"1001"]) {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [WKProgressHUD popMessage:@"发出申请成功" inView:nil duration:0.5 animated:YES];
                }else if ([ReturnType isEqualToString:@"T"]){
                    
                    [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
                }else if ([ReturnType isEqualToString:@"200"]){
                    
                    [AutomatePlist writePlistForkey:@"Uid" value:@""];
                    [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
                }
                
            } fail:^(NSError *error) {
                
                
            }];
        }
        
        
    }
    
   
    
    
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//加群验证或群密码
- (void)jiaQunYanZheng:(UITextField *)tf{
    
    JiaQun = tf.text;
}

- (void)BeiZhuChange:(UITextField *)tf{
    
    Beizhu = tf.text;
}

- (void)NickChange:(UITextField *)tf{
    
    nikcName = tf.text;
}

//对讲功能
- (void)DuiJiangBtnClick:(UIButton *)sender {
}

//编辑群资料
- (void)BianJiBtnClick:(UIButton *)sender{
    
    if (sender.selected) {
        
        sender.selected = NO;
        
        [self isUpdateGroupSuccess:^(BOOL succ) {   //修改群资料返回
            
            if (succ) {
                
                isSuccess = YES;
                [_QunDetailsTabV reloadData];
            }else{
                
                isSuccess = NO;
            }
        }];
        
    }else{
        
        isSuccess = NO;
        sender.selected = YES;
        [_QunDetailsTabV reloadData];
    }
    
}
//修改资料
- (void)isUpdateGroupSuccess:(JQComplete)success{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
    
    NSString *GroupName;
    if (Beizhu.length >0) {
        
        GroupName = Beizhu;
    }else{
        
        GroupName = [NSString NULLToString:_dataQunDict[@"GroupMyAlias"]];;
    }
    
    NSString *Descn;
    if (nikcName.length >0) {
        
        Descn = nikcName;
    }else{
        
        Descn = [NSString NULLToString:_dataQunDict[@"GroupName"]];
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupName,@"GroupAlias",Descn,@"GroupName",GroupId,@"GroupId",uid,@"UserId",nil];
    
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

//修改群图片
- (void)contentImgVTap{
    
    if (IOS8) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //相机
                UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
                imagePickerC.delegate = self;
                imagePickerC.allowsEditing = YES;
                imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerC animated:YES completion:^{
                    
                }];
            }];
            
            [alertController addAction:defaultAction];
        }
        
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //相册
            UIImagePickerController *iamgePickerC = [[UIImagePickerController alloc] init];
            iamgePickerC.delegate = self;
            iamgePickerC.allowsEditing = YES;
            iamgePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:iamgePickerC animated:YES completion:^{
                
            }];
            
        }];
        
        UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cancelA];
        [alertController addAction:defaultAction1];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        UIActionSheet *sheet;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        }else{
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        }
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSInteger sourceType = 0;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
        
    }else{
        if (buttonIndex == 1) {
            
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        
    }
    
    //跳转
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = YES;
    imagePickerC.sourceType = sourceType;
    [self presentViewController:imagePickerC animated:YES completion:nil];
}

//选择照片完成之后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    _contentImgV.image = resultImage;
    
    //上传头像
    [self UploadHeaderQunImageView:resultImage];
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//点击取消按钮所执行的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)UploadHeaderQunImageView:(UIImage *)image{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDict[@"GroupId"]];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI",
        ScreenSize,@"ScreenSize",
        @"1",@"PCDType",
        MobileClass, @"MobileClass",
        GPS_longitude,@"GPS-longitude",
        GPS_latitude,@"GPS-latitude",
        @"GroupP",@"FType",
        @"jpg,png",@"ExtName",
        uid,@"UserId",
        GroupId,@"GroupId",
    nil];
    
    NSString *login_Str = WoTing_Upload4App;
    
    [ZCBNetworking uploadWithImage:image url:login_Str filename:nil name:@"liangYan" mimeType:@"image/jpg" parameters:parameters progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
    } success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = resultDict[@"ful"][0][@"ReturnType"];
        
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"修改头像成功" inView:nil duration:0.5 animated:YES];
            
        }
        
        
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark WTQunQMContentCellDelegate
- (void)ChangeQMHeight:(NSInteger)integer{
    
    QunQianM = integer - 21;
}

//取消键盘
- (void)QunDeViewTap{
    
    [_ContentTextfield resignFirstResponder];
    [_QunNameTextfield resignFirstResponder];
}

#pragma mark -- 键盘等页面效果变化
#pragma mark -键盘监听
- (void)addKeyboardNotification
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _keyboardTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidekeyBoard:)];
    _keyboardTap.cancelsTouchesInView = NO;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int keyboardHeight = keyboardRect.size.height;
    
    NSTimeInterval animationDuration=0.30f;
    
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:_keyboardTagRow inSection:_keyboardTagSection];
    CGRect rectInTableView =[_QunDetailsTabV rectForRowAtIndexPath:indexPath];
    CGRect rectInSuperview = [_QunDetailsTabV convertRect:rectInTableView toView:self.view];
    if (keyboardHeight>(K_Screen_Height-(rectInSuperview.origin.y+rectInSuperview.size.height))) {
        [UIView animateWithDuration:animationDuration animations:^{
            _QunDetailsTabV.contentInset = UIEdgeInsetsMake(64, 0, keyboardHeight, 0);
            [_QunDetailsTabV scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }];
    }
    [self.view addGestureRecognizer:_keyboardTap];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{
    _QunDetailsTabV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view removeGestureRecognizer:_keyboardTap];
}
#pragma mark - 点击隐藏键盘
-(void)hidekeyBoard:(UITapGestureRecognizer *)gesture{
    UIView *view = gesture.view;
    [self hideKeyboardImpl:view];
}

-(void) hideKeyboardImpl:(UIView*) view
{
    [self findResponderAndResign:view];
}

-(BOOL) findResponderAndResign:(UIView*) view
{
    if (view)
    {
        if ([view isFirstResponder])
        {
            [view resignFirstResponder];
            return YES;
        }
        NSArray *children = [view subviews];
        for (int i = 0; i < children.count; ++i)
        {
            UIView *child = children[i];
            if ([self findResponderAndResign:child])
            {
                return YES;
            }
        }
    }
    return NO;
}

@end
