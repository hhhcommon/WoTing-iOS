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
#import "WTFriendDetailsController.h"   //好友详情

#import "WTContactsNewFriCell.h"    //新的朋友
#import "WTContactsFriCell.h"   //好友列表cell
#import "WTContactsCell.h"  //群列表cell

@interface WTContactsController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    
    NSMutableArray *dataQunContaArr;   //通讯录群数据源
    NSMutableArray *dataFriContaArr;    //通讯录好友数据源
    
    NSMutableArray  *Searchresults;     //搜索后的好友数据源
    NSMutableArray  *SearchQunresults;  //搜索后的群数据源
    NSMutableArray  *_letterArr;        //好友处理完数据
    
    NSMutableDictionary *dataFriDict;   //好友数据字典
    NSMutableDictionary *dataQunDict;   //群数据字典
    
    
    BOOL    isSearch;   //是否是搜索状态
}

@end

@implementation WTContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataQunContaArr = [NSMutableArray arrayWithCapacity:0];
    dataFriContaArr = [NSMutableArray arrayWithCapacity:0];
    _letterArr = [NSMutableArray arrayWithCapacity:0];
    Searchresults = [NSMutableArray arrayWithCapacity:0];
    SearchQunresults = [NSMutableArray arrayWithCapacity:0];
    isSearch = NO;
    
    dataFriDict = [NSMutableDictionary dictionaryWithCapacity:0];
    dataQunDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContactsData) name:@"LoginChangeNotification" object:nil];
    
    _ContactsSearch.delegate = self;
    
    _ContactsTabV.delegate = self;
    _ContactsTabV.dataSource = self;
    
    _ContactsTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //设置右侧索引
    _ContactsTabV.sectionIndexBackgroundColor =[UIColor clearColor];
    _ContactsTabV.sectionIndexColor = [UIColor lightGrayColor];
    
    [self loadContactsData];
    [self rigstTabCell];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadContactsData];
}

//加载view
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
                
                //存好友列表
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                [user setValue:dataFriContaArr forKey:@"JQFriend"];
                [user synchronize];
                
                [self createrCSList];   //将好友列表排序
                
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

- (void)createrCSList {
    
    [_letterArr removeAllObjects];
    
    for (int i = 0; i < dataFriContaArr.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dataFriContaArr[i]];
        
        NSString *CataName ;
        
        if (dict[@"NickName"] != nil) {
            
            CataName = dict[@"NickName"];
        }
        
        NSString *Char = [WKProgressHUD firstCharactor:CataName];
        
        [dict setValue:Char forKey:@"CharName"];
        
        //去重
        BOOL setBool = YES;
        for (int z = 0; z < _letterArr.count; z++) {
            
            NSString *charEve = _letterArr[z][@"char"];
            
            if ([charEve isEqualToString:Char]) {
                
                setBool = NO;
                
                NSMutableArray *cityArray = _letterArr[z][@"cityS"];
                [cityArray addObject:dict];
                
                NSDictionary *charCityEveDict = @{@"char":Char,@"cityS":cityArray};
                _letterArr[z] = charCityEveDict;
                
            }
        }
        
        if (setBool == YES) {
            
            NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:0];
            [cityArray addObject:dict];
            NSDictionary *charCityEveDict = @{@"char":Char,@"cityS":cityArray};
            [_letterArr addObject:charCityEveDict];
            
        }
        
    }
    
    
    //  _________________________________________________________________________________________________HYC_________________________________________________________________________________
    //排序
    for (int q = 0; q < _letterArr.count; q ++) {
        
        for (int w = 0; w < q; w++) {
            
            //比较两个字符串 大 小 相等
            NSString *str15= _letterArr[w][@"char"];
            NSString *str16=_letterArr[w+1][@"char"];
            NSComparisonResult ret2=[str15 compare:str16];
            
            if (ret2==1) {
                
                NSDictionary *ttt = _letterArr[w];
                
                _letterArr[w] = _letterArr[w+1];
                _letterArr[w+1] = ttt;
                q--;
                
                
            }
            
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (isSearch) {
        
        if (SearchQunresults.count > 0) {
            
            return 2 + Searchresults.count;
        }else{
            return 1 + Searchresults.count;
        }
    }else{
    
        return 2 + _letterArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSArray *rightShouZiMuArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    return rightShouZiMuArr;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (isSearch) {
        
        if (section == 0) {
            
            return 0;
        }else if (section == 1){
            
            return 30;
        }else{
            
            return 21;
        }
    }else{
    
        if (section == 0) {
            
            return 0;
        }else if (section == 1){
            
            return 0;
        }else{
            
            return 21;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (isSearch){
        
        if (SearchQunresults.count > 0) {
            
            if (section == 0) {
                
                return 0;
            }else if (section == 1){
                
                return 0;
                
            }else{
                
                return Searchresults[section - 2][@"char"];
            }
            
        }else{
            
            if (section == 0) {
                
                return 0;
            }else{
                
                
                return Searchresults[section - 1][@"char"];
            }
        }
        
    }else{
        if (section == 0) {
            
            return 0;
        }else if (section == 1){
            
            return 0;
        }else{
            
            
            if (_letterArr.count > 0) {
                
                return _letterArr[section - 2][@"char"];
            }else{
                
                return 0;
            }
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (isSearch) {
        
        if (SearchQunresults.count > 0) {
            
            if (section == 0) {
                
                return 0;
            }else if (section == 1){
                
                return 30;
            }else{
                
                return 0;
            }
        }else{
            
            if (section == 0) {
                
                return 30;
            }else{
                
                return 0;
            }
        }
    }else{
    
        if (section == 0) {
            
            return 30;
        }else if (section == 1){
            
            return 30;
        }else{
            
            return 0;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (isSearch) {
        
        if (SearchQunresults.count > 0) {
            
            if (section == 0) {
                
                return 0;
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
        }else{
            
            if (section == 0){
                
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
        
        
        return 0;
    }else{
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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (isSearch) {
        
        if (section == 0) {
            
            return 0;
        }else if (section == 1){
            
            if (SearchQunresults.count > 0) {
                
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
            }else{
                
                
                return 0;
            }
            
            
        }else{
            
            return 0;
        }

    }else{
        
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (isSearch) {
        
        if (SearchQunresults.count > 0) {
            
            if (section == 0) {
                
                return 1;
            }else if (section == 1){
                
                return SearchQunresults.count;
            }else{
                
                //        return dataFriContaArr.count;
                if (_letterArr.count > 0) {
                    
                    NSArray *array = Searchresults[section -2][@"cityS"];
                    
                    return array.count;
                }else{
                    
                    return 0;
                }
                
            }
            
        }else{
            
            if (section == 0) {
                
                return 1;
            }else{
                
                //        return dataFriContaArr.count;
                if (_letterArr.count > 0) {
                    
                    NSArray *array = Searchresults[section -1][@"cityS"];
                    
                    return array.count;
                }else{
                    
                    return 0;
                }
                
            }
        }
    }else{
    
        if (section == 0) {
            
            return 1;
        }else if (section == 1){
            
            return dataQunContaArr.count;
        }else{
        
    //        return dataFriContaArr.count;
            if (_letterArr.count > 0) {
                
                NSArray *array = _letterArr[section-2][@"cityS"];
                
                return array.count;
            }else{
                
                return 0;
            }
            
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isSearch) {
        
        if (SearchQunresults.count > 0) {
            
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
                    
                    NSDictionary *dict = SearchQunresults[indexPath.row];
                    
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
                    
                    cell.contentName.text = [NSString NULLToString:Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"NickName"]];
                    
                    cell.ConetNameHe.constant = 21;
                    cell.FriNumLab.hidden = YES;
                    cell.FriBeiZLab.hidden = YES;
                    
                    NSString *UserNum = [NSString NULLToString:Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"UserNum"]];
                    NSString *UserAliasName = [NSString NULLToString:Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"UserAliasName"]];
                    
                    if (UserNum.length >0) {
                        
                        cell.FriNumLab.hidden = NO;
                        cell.ConetNameHe.constant = 7;
                        cell.FriNumLab.text = [NSString stringWithFormat:@"ID: %@",UserNum];
                    }
                    
                    if (UserAliasName.length >0) {
                        
                        cell.FriBeiZLab.hidden = NO;
                        cell.ConetNameHe.constant = 7;
                        cell.FriBeiZLab.text = UserAliasName;
                    }
                    
                    
                    if ([[NSString NULLToString:Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                    }else if ([NSString NULLToString:Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"PortraitBig"]].length){
                        
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,Searchresults[indexPath.section -2 ][@"cityS"][indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                        
                    }else{
                        
                        cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
                    }
                    
                }
                
                
                return cell;
            }
            return 0;
        }else{
            if (indexPath.section == 0) {
                
                static NSString *cellID = @"cellNewFr";
                
                WTContactsNewFriCell *cell = (WTContactsNewFriCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTContactsNewFriCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
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
                    
                    cell.contentName.text = [NSString NULLToString:Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"NickName"]];
                    
                    cell.ConetNameHe.constant = 21;
                    cell.FriNumLab.hidden = YES;
                    cell.FriBeiZLab.hidden = YES;
                    
                    NSString *UserNum = [NSString NULLToString:Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"UserNum"]];
                    NSString *UserAliasName = [NSString NULLToString:Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"UserAliasName"]];
                    
                    if (UserNum.length >0) {
                        
                        cell.FriNumLab.hidden = NO;
                        cell.ConetNameHe.constant = 7;
                        cell.FriNumLab.text = [NSString stringWithFormat:@"ID: %@",UserNum];
                    }
                    
                    if (UserAliasName.length >0) {
                        
                        cell.FriBeiZLab.hidden = NO;
                        cell.ConetNameHe.constant = 7;
                        cell.FriBeiZLab.text = UserAliasName;
                    }
                    
                    if ([[NSString NULLToString:Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                    }else if ([NSString NULLToString:Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"PortraitBig"]].length){
                        
                        [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,Searchresults[indexPath.section -1 ][@"cityS"][indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                        
                    }else{
                        
                        cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
                    }
                    
                }
                
                
                return cell;
            }
            return 0;
        }
    }else{
    
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
            //[0]	(null)	@"PortraitBig" : @"http://www.wotingfm.com/dataCenter/userimg/user_462f.png" [8]	(null)	@"UserNum" : @"666666"	[2]	(null)	@"UserAliasName" : @"01"
            if (dataFriContaArr.count) {
                
                cell.contentName.text = [NSString NULLToString:_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"NickName"]];
                
                cell.ConetNameHe.constant = 21;
                cell.FriNumLab.hidden = YES;
                cell.FriBeiZLab.hidden = YES;
                
                NSString *UserNum = [NSString NULLToString:_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"UserNum"]];
                NSString *UserAliasName = [NSString NULLToString:_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"UserAliasName"]];
                
                if (UserNum.length >0) {
                    
                    cell.FriNumLab.hidden = NO;
                    cell.ConetNameHe.constant = 7;
                    cell.FriNumLab.text = [NSString stringWithFormat:@"ID: %@",UserNum];
                }
                
                if (UserAliasName.length >0) {
                    
                    cell.FriBeiZLab.hidden = NO;
                    cell.ConetNameHe.constant = 7;
                    cell.FriBeiZLab.text = UserAliasName;
                }
                
                if ([[NSString NULLToString:_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
                   [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                }else if ([NSString NULLToString:_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"PortraitBig"]].length){
                    
                    [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_letterArr[indexPath.section - 2][@"cityS"][indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                    
                }else{
                    
                    cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
                }
                
            }
            
            
            return cell;
        }
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (isSearch) {
        
        if (SearchQunresults.count > 0) {
            
            if (indexPath.section == 0 && indexPath.row == 0) {
                
                WTNewFriendController *newFVC = [[WTNewFriendController alloc] init];
                newFVC.ConText = @"新的朋友";
                newFVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newFVC animated:YES];
            }else if(indexPath.section == 1){
                
                WTQunDetailsController *QunDVC = [[WTQunDetailsController alloc] init];
                QunDVC.hidesBottomBarWhenPushed = YES;
                QunDVC.dataQunDict = SearchQunresults[indexPath.row];
                QunDVC.QunDetailsType = [SearchQunresults[indexPath.row][@"GroupType"] integerValue];
                [self.navigationController pushViewController:QunDVC animated:YES];
            }else {
                
                WTFriendDetailsController *friDVC = [[WTFriendDetailsController alloc] init];
                friDVC.dataFriDict = Searchresults[indexPath.section - 2][@"cityS"][indexPath.row];
                friDVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:friDVC animated:YES];
            }
        }else{
            if (indexPath.section == 0 && indexPath.row == 0) {
                
                WTNewFriendController *newFVC = [[WTNewFriendController alloc] init];
                newFVC.ConText = @"新的朋友";
                newFVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newFVC animated:YES];
            }else {
                
                WTFriendDetailsController *friDVC = [[WTFriendDetailsController alloc] init];
                
                friDVC.dataFriDict = Searchresults[indexPath.section - 1][@"cityS"][indexPath.row];
                friDVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:friDVC animated:YES];
            }
        }
    }else{
    
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            WTNewFriendController *newFVC = [[WTNewFriendController alloc] init];
            newFVC.ConText = @"新的朋友";
            newFVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:newFVC animated:YES];
        }else if(indexPath.section == 1){
            
            WTQunDetailsController *QunDVC = [[WTQunDetailsController alloc] init];
            QunDVC.hidesBottomBarWhenPushed = YES;
            QunDVC.dataQunDict = dataQunContaArr[indexPath.row];
            QunDVC.QunDetailsType = [dataQunContaArr[indexPath.row][@"GroupType"] integerValue];
            [self.navigationController pushViewController:QunDVC animated:YES];
        }else{
            
            WTFriendDetailsController *friDVC = [[WTFriendDetailsController alloc] init];
            
            friDVC.dataFriDict = _letterArr[indexPath.section - 2][@"cityS"][indexPath.row];
            friDVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:friDVC animated:YES];
        }
    }
}

#pragma mark UISearchBarDelegate

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"changed");
    
    NSString *text = _ContactsSearch.text;
    
    Searchresults = [self searchWordsWithText:text];  //好友
    
    SearchQunresults = [self searchQunWithText:text];   //群
    
    if (Searchresults.count > 0 || SearchQunresults.count > 0) {
        
        isSearch = YES;
        [_ContactsTabV reloadData];
    }else{
        
        isSearch = NO;
        [_ContactsTabV reloadData];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton =YES;
    
    for(id cc in [searchBar subviews])
        
    {
        
        if([cc isKindOfClass:[UIButton class]])
            
        {
            
            UIButton *btn = (UIButton *)cc;
            
            [btn setTitle:@"取消" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
        }
        
    }
    
    NSLog(@"shuould begin");
    
    
    return YES;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    
    NSLog(@"did begin");
    
        
    SearchQunresults = nil;
    Searchresults = nil;
    isSearch = NO;
    [_ContactsTabV reloadData];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    NSLog(@"did end");
    
    searchBar.showsCancelButton =NO;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"search clicked");
    
}

//点击搜索框上的 取消按钮时 调用

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"cancle clicked");
    
    _ContactsSearch.text = @"";
    
    [_ContactsSearch resignFirstResponder];

    SearchQunresults = nil;
    Searchresults = nil;
    isSearch = NO;
    [_ContactsTabV reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- 传入一个字符串进行模糊查询

- (NSMutableArray *)searchWordsWithText:(NSString *)text{
    
    //先判断text是否为空 为空时 不做操作
    if (text.length == 0) {
        
        return nil;
    }
    
    //(1) 需要一个数组存储查询的结果
    
    NSMutableArray *searchArray = [NSMutableArray array];
    
    //(2) 循环查询
    NSString *charHYC;
    
    for (NSDictionary *dict in _letterArr) {
        
        charHYC = dict[@"char"];
        
        NSMutableArray *cityS = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *word in dict[@"cityS"]) {
            
            if ([word[@"NickName"] containsString:text]) {
                //如果包含 满足条件
                [cityS addObject:word];
                
            }
            
            
            
        }
        
        
        if (cityS.count > 0) {
            
            [searchArray addObject:@{@"cityS":cityS,@"char":charHYC}];
            
        }
        
        
    }
//    //(3) 如果一个都没有找到 应该给与提示
//    
//    if (searchArray.count == 0) {
//        
//        NSString *alerStr = @"没有找到相应的结果";
//        
//        [searchArray addObject:alerStr];
//    }
    
    return searchArray;
    
}

- (NSMutableArray *)searchQunWithText:(NSString *)text{
    
    //先判断text是否为空 为空时 不做操作
    if (text.length == 0) {
        
        return nil;
    }
    
    //(1) 需要一个数组存储查询的结果
    
    NSMutableArray *searchArray = [NSMutableArray array];
    
    //(2) 循环查询
    
    for (NSDictionary *dict in dataQunContaArr) {
        
        if ([dict[@"GroupName"] containsString:text]) {
            //如果包含 满足条件
            [searchArray addObject:dict];
        }

    }
    
    return searchArray;
    
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
