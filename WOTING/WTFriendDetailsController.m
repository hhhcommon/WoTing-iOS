//
//  WTFriendDetailsController.m
//  WOTING
//
//  Created by jq on 2017/4/12.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTFriendDetailsController.h"

#import "WTQunSignChangeController.h"   //修改签名

#import "WTQunAndFriendDetailsCell.h"   //资料cell
#import "WTQunQianMingCell.h"           //好友签名
#import "WTQunQMContentCell.h"
#import "WTQunShouQiCell.h"             //收起展开
#import "WTFriAddFCell.h"               //加好友验证
#import "WTQuitQunCell.h"               //添加或删除好友

@interface WTFriendDetailsController ()<UITableViewDelegate, UITableViewDataSource>{
    
    BOOL    isSQ; //签名显示与收起
    BOOL    isFriend;   //是否是好友
    BOOL    isUserSuccess;  //是否修改成功好友资料
    
    NSInteger   FriQianM;   //签名高度
    
    NSString *FriBeizhu;    //好友备注
    NSString *FrinikcName;  //好友描述
    
    NSString *YanZStr;      //加好友验证
}

@end

@implementation WTFriendDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSQ = NO;
    
    _FriendTabV.delegate = self;
    _FriendTabV.dataSource = self;
    
    _FriendTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _FriendTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self DetermineWhetherFriends]; //判断当前是否是好友
    
    [self registerFriendDetailsTabCell];
}

- (void)DetermineWhetherFriends{
    
    if (_dataFriDict.count > 0) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *array = [user valueForKey:@"JQFriend"];
        NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:0];
        [Marr addObjectsFromArray:array];
        
        for (NSDictionary *dict in array) {
            
            if ([dict[@"UserId"] isEqualToString:_dataFriDict[@"UserId"]]) {
                
                isFriend = YES;
                break;
            }else{
                
                isFriend = NO;
            }
        }
    }

}

- (void)registerFriendDetailsTabCell{
    //资料
    UINib *cellNib = [UINib nibWithNibName:@"WTQunAndFriendDetailsCell" bundle:nil];
    
    [_FriendTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    //好友签名
    UINib *cellQMNib = [UINib nibWithNibName:@"WTQunQianMingCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQMNib forCellReuseIdentifier:@"cellQM"];
    
    UINib *cellQMConNib = [UINib nibWithNibName:@"WTQunQMContentCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQMConNib forCellReuseIdentifier:@"cellQMCon"];

    //收起
    UINib *cellSQNib = [UINib nibWithNibName:@"WTQunShouQiCell" bundle:nil];
    
    [_FriendTabV registerNib:cellSQNib forCellReuseIdentifier:@"cellSQ"];
    
    //添加好友编辑
    UINib *cellQMCNib = [UINib nibWithNibName:@"WTFriAddFCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQMCNib forCellReuseIdentifier:@"cellADD"];
    
    
    //添加或删除
    UINib *cellQTNib = [UINib nibWithNibName:@"WTQuitQunCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQTNib forCellReuseIdentifier:@"cellQT"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 200;
    }else if (indexPath.row == 1){
        
        return 54;
    }else if (indexPath.row == 2){
        
        if (isSQ) {
            
            return 44;
        }else{
            return 44 + FriQianM;
        }
    }else if (indexPath.row == 3){
        
        return 30;
    }else if (indexPath.row == 4){
        
        if (K_Screen_Height > 700) {
            
            return 260;
        }else if (K_Screen_Height > 600 && K_Screen_Height < 700){
            
            return 180;
        }else{
            
            return 120;
        }

    }else{
        
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        static NSString *cellID = @"cellID";
        
        WTQunAndFriendDetailsCell *cell = (WTQunAndFriendDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunAndFriendDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataFriDict.count) {
            //图片
            if ([[NSString NULLToString:_dataFriDict[@"PortraitBig"]] hasPrefix:@"http"]) {
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataFriDict[@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else if ([NSString NULLToString:_dataFriDict[@"PortraitBig"]].length){
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataFriDict[@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
            //文字[2]	(null)	@"UserAliasName" : @"测试备注"  Region UserNum
            NSString *UserAliasName = [NSString NULLToString:_dataFriDict[@"UserAliasName"]];
            NSString *Region = [NSString NULLToString:_dataFriDict[@"Region"]];
            NSString *UserNum = [NSString NULLToString:_dataFriDict[@"UserNum"]];
            if (UserAliasName.length > 0) {
                
                cell.BeiZhuLab.text = [NSString NULLToString:_dataFriDict[@"UserAliasName"]];
            }else{
                
                cell.BeiZhuLab.text = [NSString NULLToString:_dataFriDict[@"NickName"]];
            }
            
            if (Region.length > 0 || UserNum.length >0) {
                
                Region = [self StringWithQuGuang:Region];
                cell.DetailsLab.text = Region;
                if (UserNum.length > 0) {
                    
                    cell.DetailsLab.text = [NSString stringWithFormat:@"%@.用户号:%@",Region, UserNum];
                }
            }else{
                
                
                cell.DetailsLab.text = @"暂无用户信息";
            }
            
            
            cell.NickLab.text = [NSString stringWithFormat:@"昵称:%@", [NSString NULLToString:_dataFriDict[@"NickName"]]];
        }

        cell.NickTextF.hidden = YES;
        [cell.BeiZhuTextF addTarget:self action:@selector(BeiZhuFriChange:) forControlEvents:UIControlEventEditingChanged];
        [cell.BianjiBtn addTarget:self action:@selector(BianjiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (isFriend) {
            
            if (cell.BianjiBtn.selected) {
                
                cell.BeiZhuTextF.hidden = NO;
                
                if (FriBeizhu.length >0) {
                    
                    cell.BeiZhuTextF.text = FriBeizhu;
                }else{
                    
                    cell.BeiZhuTextF.text = cell.BeiZhuLab.text;
                }
                
            }else{
                
                cell.BeiZhuTextF.hidden = YES;
                
                [cell.BeiZhuTextF resignFirstResponder];
                
                if (isUserSuccess) {
                    
                    if (FriBeizhu.length >0) {
                        
                        cell.BeiZhuLab.text = FriBeizhu;
                    }
                    
                    
                }else{
                    
                    NSString *UserAliasName = [NSString NULLToString:_dataFriDict[@"UserAliasName"]];
                    if (UserAliasName.length > 0) {
                        
                        cell.BeiZhuLab.text = [NSString NULLToString:_dataFriDict[@"UserAliasName"]];
                    }else{
                        
                        cell.BeiZhuLab.text = [NSString NULLToString:_dataFriDict[@"NickName"]];
                    }
                    
                    cell.NickLab.text = [NSString NULLToString:_dataFriDict[@"NickName"]];
                }
                
            }
        }else{
            
            cell.BianjiBtn.hidden = YES;
            cell.DuiJiangBtn.hidden = YES;
            cell.BeiZhuTextF.hidden = YES;
            cell.NickTextF.hidden = YES;
        }
        
        
        return cell;
    }else if (indexPath.row == 1){  //签名
        
        static NSString *cellID = @"cellQM";
        
        WTQunQianMingCell *cell = (WTQunQianMingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunQianMingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentLab.text = @"签名";
        cell.JTImgV.hidden = YES;
        
        return cell;
    }else if (indexPath.row == 2){  //签名内容
        
        static NSString *cellID = @"cellQMCon";
        
        WTQunQMContentCell *cell = (WTQunQMContentCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunQMContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString *QMSign = [NSString NULLToString:_dataFriDict[@"UserSign"]];
        
        if (QMSign.length > 0) {
            
            cell.contentLab.text = QMSign;
            CGFloat previewH = [cell.contentLab.text boundingRectWithSize:CGSizeMake(cell.contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
            cell.ContentLabHeight.constant = previewH;
            
            FriQianM = (NSInteger )cell.ContentLabHeight.constant;
        }else{
            
            cell.contentLab.text = @"暂无签名";
        }
        
        if (isSQ) {
            
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
        [cell.shouQiBtn addTarget:self action:@selector(shouQiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }else if (indexPath.row == 4){  //加好友验证
        
        static NSString *cellID = @"cellADD";
        
        WTFriAddFCell *cell = (WTFriAddFCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTFriAddFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        if (isFriend) {
            
            cell.ContentTextF.hidden = YES;
            cell.HaoyouLab.hidden = YES;
        }else{
            
            cell.ContentTextF.hidden = NO;
            cell.HaoyouLab.hidden = NO;
            
            [cell.ContentTextF addTarget:self action:@selector(TextFChange:) forControlEvents:UIControlEventEditingChanged];
            
        }
        
        return cell;
    }else {  //添加或删除
        
        static NSString *cellID = @"cellQT";
        
        WTQuitQunCell *cell = (WTQuitQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQuitQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.QuitBtn addTarget:self action:@selector(QuitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (isFriend) {
            
            [cell.QuitBtn setTitle:@"删除好友" forState:UIControlStateNormal];
            cell.QuitBtn.backgroundColor = [UIColor JQTColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }else{
            
            [cell.QuitBtn setTitle:@"添加对方为好友" forState:UIControlStateNormal];
            cell.QuitBtn.backgroundColor = [UIColor JQTColor];
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

//修改备注
- (void)BeiZhuFriChange:(UITextField *)tf{
    
    FriBeizhu = tf.text;
}

//加好友验证
- (void)TextFChange:(UITextField *)tf{
    
    YanZStr = tf.text;
    
}


//收起
- (void)shouQiBtn:(UIButton *)btn{
    
    if (btn.selected) {
        
        btn.selected = NO;
        isSQ = NO;
        [_FriendTabV reloadData];
    }else{
        
        btn.selected = YES;
        isSQ = YES;
        FriQianM = 21;
        [_FriendTabV reloadData];
    }
}

//编辑
- (void)BianjiBtnClick:(UIButton *)btn{
    
    if (btn.selected) {
        
        btn.selected = NO;
        [self isUpdateUserInfoSuccess:^(BOOL succ) {   //修改群资料返回
            
            if (succ) {
                
                isUserSuccess = YES;
                [_FriendTabV reloadData];
            }else{
                
                isUserSuccess = NO;
            }
        }];
        
    }else{
        
        isUserSuccess = NO;
        btn.selected = YES;
        [_FriendTabV reloadData];
    }

}

- (void)QuitBtnClick:(UIButton *)btn{
    
    if (isFriend) {
        
        //删除
        [self DeleteFriendPost];
    }else{
        
        //添加
        [self AddFriendPost];
    }
}


- (void)isUpdateUserInfoSuccess:(JQComplete)success{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *FriendUserId = [NSString NULLToString:_dataFriDict[@"UserId"]];
    
    NSString *FriendAliasName;  //好友别名
    if (FriBeizhu.length >0) {
        
        FriendAliasName = FriBeizhu;
    }else{
        
        FriendAliasName = [NSString NULLToString:_dataFriDict[@"UserAliasName"]];;
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",FriendAliasName,@"FriendAliasName",FriendUserId,@"FriendUserId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_UpdateFriendInfo;
    
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



//添加好友
- (void)AddFriendPost{
    
    if (_dataFriDict.count >0) {
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        
        NSString *BeInvitedUserId = [NSString NULLToString:_dataFriDict[@"UserId"]];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",BeInvitedUserId,@"BeInvitedUserId",uid,@"UserId",YanZStr,@"InviteMsg",nil];
        
        NSString *login_Str = WoTing_FriendInvite;
        
        NSLog(@"%@", parameters);
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                [WKProgressHUD popMessage:@"已发起添加请求" inView:nil duration:0.5 animated:YES];
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


//删除好友
- (void)DeleteFriendPost{
    
    if (_dataFriDict.count >0) {
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        
        NSString *FriendUserId = [NSString NULLToString:_dataFriDict[@"UserId"]];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",FriendUserId,@"FriendUserId",uid,@"UserId",nil];
        
        NSString *login_Str = WoTing_DelFriend;
        
        NSLog(@"%@", parameters);
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                [WKProgressHUD popMessage:@"好友删除成功" inView:nil duration:0.5 animated:YES];
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

- (NSString *)StringWithQuGuang:(NSString *)Str{
    
    NSArray *StrArr = [Str componentsSeparatedByString:@"/"];
    
    NSString *registerStr;
    if (StrArr.count > 3) {
        
        registerStr = [NSString stringWithFormat:@"%@%@", [StrArr objectAtIndex:1],[StrArr objectAtIndex:3]];
    }else{
        
        registerStr = @"";
    }
    
    
    return registerStr;
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
