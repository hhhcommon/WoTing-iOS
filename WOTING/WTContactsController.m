//
//  WTContactsController.m
//  WOTING
//
//  Created by jq on 2017/4/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTContactsController.h"

#import "WTNewFriendController.h"   //新的朋友
#import "WTQunDetailsController.h"  //群详情

#import "WTContactsNewFriCell.h"    //新的朋友
#import "WTContactsFriCell.h"   //好友列表cell
#import "WTContactsCell.h"  //群列表cell

@interface WTContactsController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray *dataQunContaArr;   //通讯录群数据源
    NSMutableArray *dataFriContaArr;    //通讯录好友数据源
    
    NSMutableDictionary *dataFriDict;   //好友数据字典
    NSMutableDictionary *dataQunDict;   //群数据字典
}

@end

@implementation WTContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataQunContaArr = [NSMutableArray arrayWithCapacity:0];
    dataFriContaArr = [NSMutableArray arrayWithCapacity:0];
    
    dataFriDict = [NSMutableDictionary dictionaryWithCapacity:0];
    dataQunDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContactsData) name:@"LoginChangeNotification" object:nil];
    
    _ContactsTabV.delegate = self;
    _ContactsTabV.dataSource = self;
    
    _ContactsTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    [self loadContactsData];
    [self rigstTabCell];
}

- (void)ErrorShowImageView{
    
    
    
}

- (void)rigstTabCell{
    
    UINib *cellNewFriNib = [UINib nibWithNibName:@"WTContactsNewFriCell" bundle:nil];
    
    [_ContactsTabV registerNib:cellNewFriNib forCellReuseIdentifier:@"cellNewFr"];
    
    UINib *cellNib = [UINib nibWithNibName:@"WTContactsCell" bundle:nil];
    
    [_ContactsTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *cellFriNib = [UINib nibWithNibName:@"WTContactsFriCell" bundle:nil];
    
    [_ContactsTabV registerNib:cellFriNib forCellReuseIdentifier:@"cellFr"];
    
}

//请求数据
- (void)loadContactsData{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    if ([uid isEqualToString:@"0"]||[uid isEqualToString:@""]) {
        
        [self ErrorShowImageView];
        [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
    }else {
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];

        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",nil];
        
        NSString *login_Str = WoTing_GroupsAndFriends;
        
        NSLog(@"%@", parameters);
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            NSString  *Message = [resultDict objectForKey:@"Message"];
            if ([Message isEqualToString:@"用户已登录"]) {
                
                NSDictionary *FriendList = resultDict[@"FriendList"];
                [dataFriContaArr removeAllObjects];
                [dataFriContaArr addObjectsFromArray:FriendList[@"Friends"]];
                
                [dataFriDict removeAllObjects];
                [dataFriDict addEntriesFromDictionary:FriendList];
                
                NSDictionary *GroupList = resultDict[@"GroupList"];
                [dataQunContaArr removeAllObjects];
                [dataQunContaArr addObjectsFromArray:GroupList[@"Groups"]];
                
                [dataQunDict removeAllObjects];
                [dataQunDict addEntriesFromDictionary:GroupList];
                
                [_ContactsTabV reloadData];
                
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
//    if (_letterArr) {
//        
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
//        
//        for (NSDictionary *dict in _letterArr) {
//            
//            [array addObject:dict[@"char"]];
//            
//        }
//        
//        return array;
//    }
//    
    NSArray *rightShouZiMuArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    return rightShouZiMuArr;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0;
    }else if (section == 1){
        
        return 0;
    }else{
        
        return 21;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }else if (section == 1){
        
        return 0;
    }else{
        
        return @"X";
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 30;
    }else if (section == 1){
        
        return 30;
    }else{
        
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 0) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, 21)];
        view.backgroundColor = [UIColor colorWithRed:252/255.0 green:225/255.0 blue:188/255.0 alpha:1.0];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"群聊";
        lab.font = [UIFont boldSystemFontOfSize:12];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(40);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(view.mas_centerY);
            make.height.mas_equalTo(21);
        }];
        
        return view;
    }else if (section == 1){
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, 21)];
        view.backgroundColor = [UIColor colorWithRed:252/255.0 green:225/255.0 blue:188/255.0 alpha:1.0];
        UILabel *lab = [[UILabel alloc] init];
        lab.text = @"好友";
        lab.font = [UIFont boldSystemFontOfSize:12];
        [view addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(40);
            make.width.mas_equalTo(100);
            make.centerY.equalTo(view.mas_centerY);
            make.height.mas_equalTo(21);
        }];
        
        return view;
    }else{
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else if (section == 1){
        
        return dataQunContaArr.count;
    }else{
    
        return dataFriContaArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"cellNewFr";
        
        WTContactsNewFriCell *cell = (WTContactsNewFriCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTContactsNewFriCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        return cell;
    }else if (indexPath.section == 1){
        
        static NSString *cellID = @"cellID";
        
        WTContactsCell *cell = (WTContactsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTContactsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dataQunContaArr.count) {
            
            NSDictionary *dict = dataQunContaArr[indexPath.row];
            
            [cell setCellWithDict:dict];
        }
        
        return cell;
        
    }else{
        
        static NSString *cellID = @"cellFr";
        
        WTContactsFriCell *cell = (WTContactsFriCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTContactsFriCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[0]	(null)	@"PortraitBig" : @"http://www.wotingfm.com/dataCenter/userimg/user_462f.png"
        if (dataFriContaArr.count) {
            
           cell.contentName.text = [NSString NULLToString:dataFriContaArr[indexPath.row][@"NickName"]];
            if ([[NSString NULLToString:dataFriContaArr[indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
               [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataFriContaArr[indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else if ([NSString NULLToString:dataFriContaArr[indexPath.row][@"PortraitBig"]].length){
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,dataFriContaArr[indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
        }
        
        
        return cell;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        WTNewFriendController *newFVC = [[WTNewFriendController alloc] init];
        newFVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newFVC animated:YES];
    }else if(indexPath.section == 1){
        
        WTQunDetailsController *QunDVC = [[WTQunDetailsController alloc] init];
        QunDVC.hidesBottomBarWhenPushed = YES;
        QunDVC.dataQunDict = dataQunContaArr[indexPath.row];
        [self.navigationController pushViewController:QunDVC animated:YES];
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

@end
