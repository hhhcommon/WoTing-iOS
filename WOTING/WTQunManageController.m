//
//  WTQunManageController.m
//  WOTING
//
//  Created by jq on 2017/4/14.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunManageController.h"

#import <objc/runtime.h>

#import "WTQunManageCell.h"     //默认样式
#import "WTQunZhuManageCell.h"  //群组, 管理员样式

@interface WTQunManageController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>{
    
    NSMutableArray  *dataJQArr;     //排序数据源
    NSMutableArray  *_letterArr;        //好友处理完数据
    NSMutableArray  *SearchManageResults;   //搜索处理
    NSMutableArray  *dataQunX;      //选中个数
    NSMutableArray  *dataQunZhuArr; //群主and管理员集
    
    NSString    *QunZhuStr;     //被移交的群主id
    NSMutableArray *XuanUserIdArr;   //选择的成员集
    
    BOOL    isManageSearch;    // 是否是搜索状态
}

@end

@implementation WTQunManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataJQArr = [NSMutableArray arrayWithCapacity:0];
    _letterArr = [NSMutableArray arrayWithCapacity:0];
    SearchManageResults = [NSMutableArray arrayWithCapacity:0];
    dataQunX = [NSMutableArray arrayWithCapacity:0];
    dataQunZhuArr = [NSMutableArray arrayWithCapacity:0];
    XuanUserIdArr = [NSMutableArray arrayWithCapacity:0];
    
    _ManageTabV.delegate = self;
    _ManageTabV.dataSource = self;
    _SearchManage.delegate = self;
    
    _ManageTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    _contentLab.text = _contentText;
    
    //设置右侧索引
    _ManageTabV.sectionIndexBackgroundColor =[UIColor clearColor];
    _ManageTabV.sectionIndexColor = [UIColor lightGrayColor];
    
    //设置页面样式
    if (_QunType == 1 || _QunType == 0 || _QunType == 4 || _QunType == 2) {    //移交群主  or 查看群成员  4:删除群成员    2:设置管理
        [dataQunZhuArr removeAllObjects];
        
        
        //判断群主还是管理还是等等[7]	(null)	@"GroupManager" : @"a855e41850b9"[8]	(null)	@"GroupMasterId" : @"4de8a79b26c1"
        NSString *QunZhu = [_dataQunDeDict objectForKey:@"GroupMasterId"];
        NSString *Manage = [_dataQunDeDict objectForKey:@"GroupManager"];
        BOOL  isManages;    //是否是多个群管理
        NSArray *ManageArr; //多管理
        if ([Manage containsString:@","]) {
            
            isManages = YES;
            ManageArr = [Manage componentsSeparatedByString:@","];
            ManageArr = [self ManageArr:ManageArr andQunStrId:QunZhu];  //去重群主
        }else{
            
            isManages = NO;
        }
        
        NSMutableArray * Marray = [NSMutableArray arrayWithCapacity:0];
        [Marray addObjectsFromArray:_dataManageArr];
        NSArray *TArr = [NSArray arrayWithArray:Marray];
        for (NSDictionary *dict in TArr) {
            
            if (isManages) {
                
                for (NSString *ManStr in ManageArr) {
                    
                    if ([dict[@"UserId"] isEqualToString:ManStr]) {
                        
                        [dataQunZhuArr addObject:dict];
                        [Marray removeObject:dict];
                    }
                }
                
                if ([dict[@"UserId"] isEqualToString:QunZhu]) {
                    
                    [dataQunZhuArr addObject:dict];
                    [Marray removeObject:dict];
                    
                }
                
            }else{
            
                if ([dict[@"UserId"] isEqualToString:QunZhu] || [dict[@"UserId"] isEqualToString:Manage]) {
                    
                    [dataQunZhuArr addObject:dict];
                    [Marray removeObject:dict];
                    
                }
            }
        }
        
        _letterArr = [self createrCSList:Marray];
    }else if (_QunType == 3) {    //添加群成员
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSArray *array = [user valueForKey:@"JQFriend"];
        NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:0];
        [Marr addObjectsFromArray:array];
        
        NSMutableArray  *JQArr = [self DistinctList:Marr];
        _letterArr = [self createrCSList:JQArr];
        
    }else{
    
        _letterArr = [self createrCSList:_dataManageArr];
    }
    
    
    [self registerQunManageCell];
}


- (void)registerQunManageCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTQunManageCell" bundle:nil];
    
    [_ManageTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *cellQunZhuNib = [UINib nibWithNibName:@"WTQunZhuManageCell" bundle:nil];
    
    [_ManageTabV registerNib:cellQunZhuNib forCellReuseIdentifier:@"cellQZ"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (_QunType == 1 || _QunType == 0 || _QunType == 4 || _QunType == 2) {    //1: 查看群成员 or 移交群主  4:删除群成员
        
        if (isManageSearch) {   //搜索
            
            return SearchManageResults.count;
        }else{
            
            return _letterArr.count + 1;
        }
    }else{
    
        if (isManageSearch) {
            
            return SearchManageResults.count;
        }else{
        
            return _letterArr.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    NSArray *rightShouZiMuArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    return rightShouZiMuArr;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_QunType == 1 || _QunType == 0 || _QunType == 4 || _QunType == 2) {
        
        if (isManageSearch) {
            
            return SearchManageResults[section ][@"char"];
        }else{
            
            if (section == 0) {
                
                return @"群主、管理员";
            }else{
                return _letterArr[section -1][@"char"];
            }
        }
    }else{
    
        if (isManageSearch) {
            
            return SearchManageResults[section ][@"char"];
        }else{
            
            return _letterArr[section ][@"char"];
        }
    }
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_QunType == 1 || _QunType == 0 || _QunType == 4 || _QunType == 2) {
        
        if (isManageSearch) {
            
            NSArray *array = SearchManageResults[section][@"cityS"];
            return array.count;
            
        }else{
            if (section == 0) {
                
                return dataQunZhuArr.count;
            }else{
                
                NSArray *array = _letterArr[section - 1][@"cityS"];
                return array.count;
            }
        }
    }else{
    
        if (isManageSearch) {
            
            NSArray *array = SearchManageResults[section][@"cityS"];
            return array.count;
            
        }else{
        
            NSArray *array = _letterArr[section][@"cityS"];
            return array.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_QunType == 1 || _QunType == 0 || _QunType == 4 || _QunType == 2) {
        
        if (isManageSearch) {
            
            static NSString *cellID = @"cellID";
            
            WTQunManageCell *cell = (WTQunManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.XuanZhongBtn addTarget:self action:@selector(XuanZhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
            if (_QunType == 0) {
                
                cell.XuanZhongBtn.hidden = YES;
            }else{
                
                cell.XuanZhongBtn.hidden = NO;
                
            }
            
            cell.contentLab.text = [NSString NULLToString:SearchManageResults[indexPath.section][@"cityS"][indexPath.row][@"NickName"]];
            if (_dataManageArr[indexPath.row][@"PortraitBig"] != nil) {
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:SearchManageResults[indexPath.section][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
            return cell;
            
        }else{
            
            if (indexPath.section == 0) {
                
                static NSString *cellID = @"cellQZ";
                
                WTQunZhuManageCell *cell = (WTQunZhuManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunZhuManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString *userId = dataQunZhuArr[indexPath.row][@"UserId"];
                //传值
                objc_setAssociatedObject(cell.XuanZBtn, @"UserId", userId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//实际上就是KVC
                [cell.XuanZBtn addTarget:self action:@selector(XuanZhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                if (_QunType == 1) {    //移交群主(单选)
                    
                    if (dataQunX.count >0) {
                        
                        if ([dataQunX[0] isEqualToString:dataQunZhuArr[indexPath.row][@"UserId"]]) {
                            
                            cell.XuanZBtn.selected = YES;
                        }else{
                            
                            cell.XuanZBtn.selected = NO;
                        }
                    }
                    
                }
                
                cell.contentName.text = [NSString NULLToString:dataQunZhuArr[indexPath.row][@"NickName"]];
                if (dataQunZhuArr[indexPath.row][@"PortraitBig"] != nil) {
                    
                    [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataQunZhuArr[indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                }else{
                    
                    cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
                }
                
                //判断群主还是管理还是等等
                NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
                NSString *QunZhu = [_dataQunDeDict objectForKey:@"GroupMasterId"];
                
                if ([dataQunZhuArr[indexPath.row][@"UserId"] isEqualToString:QunZhu]) { //群主
                    
                    cell.QunZhuBtn.selected = NO;
                    cell.XuanZBtn.hidden = YES;
                    if ([dataQunZhuArr[indexPath.row][@"UserId"] isEqualToString:uid]) {
                        
                        cell.MeLab.hidden = NO;
                    }else{
                        
                        cell.MeLab.hidden = YES;
                    }
                }else{  //管理
                    
                    cell.QunZhuBtn.selected = YES;
                    if ([dataQunZhuArr[indexPath.row][@"UserId"] isEqualToString:uid]) {
                        
                        cell.MeLab.hidden = NO;
                        cell.XuanZBtn.hidden = YES;
                    }else{
                        
                        cell.MeLab.hidden = YES;
                        cell.XuanZBtn.hidden = NO;
                    }
                    
                    if (_QunType == 2) {    //设置管理员..将管理的选择框隐藏
                        
                        cell.XuanZBtn.hidden = YES;
                    }
                }
                
                return cell;
            }else{
                
                static NSString *cellID = @"cellID";
                
                WTQunManageCell *cell = (WTQunManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
                
                if (!cell) {
                    cell = [[WTQunManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                NSString *userId = _letterArr[indexPath.section -1][@"cityS"][indexPath.row][@"UserId"];
                //传值
                objc_setAssociatedObject(cell.XuanZhongBtn, @"UserId", userId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//实际上就是KVC
                
                [cell.XuanZhongBtn addTarget:self action:@selector(XuanZhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                
                
                if (_QunType == 0) {
                    
                    cell.XuanZhongBtn.hidden = YES;
                }else{
                    
                    cell.XuanZhongBtn.hidden = NO;
                    
                }
                
                if (_QunType == 1) {
                    
                    if (dataQunX.count >0) {
                        
                        if ([dataQunX[0] isEqualToString:_letterArr[indexPath.section -1][@"cityS"][indexPath.row][@"UserId"]]) {
                            
                            cell.XuanZhongBtn.selected = YES;
                        }else{
                            
                            cell.XuanZhongBtn.selected = NO;
                        }
                        
                        
                    }
                    
                }
                
                cell.contentLab.text = [NSString NULLToString:_letterArr[indexPath.section -1][@"cityS"][indexPath.row][@"NickName"]];
                if (_letterArr[indexPath.section -1][@"cityS"][indexPath.row][@"PortraitBig"] != nil) {
                    
                    [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_letterArr[indexPath.section -1][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                }else{
                    
                    cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
                }
                
                return cell;
            }
        }

    }else{
    
        if (isManageSearch) {
            
            static NSString *cellID = @"cellID";
            
            WTQunManageCell *cell = (WTQunManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            [cell.XuanZhongBtn addTarget:self action:@selector(XuanZhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.XuanZhongBtn.selected = NO;
            
            if (_QunType == 0) {
                
                cell.XuanZhongBtn.hidden = YES;
            }else{
                
                cell.XuanZhongBtn.hidden = NO;
                
            }
            
            cell.contentLab.text = [NSString NULLToString:SearchManageResults[indexPath.section][@"cityS"][indexPath.row][@"NickName"]];
            if (_dataManageArr[indexPath.row][@"PortraitBig"] != nil) {
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:SearchManageResults[indexPath.section][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
            return cell;
            
        }else{
        
            static NSString *cellID = @"cellID";
            
            WTQunManageCell *cell = (WTQunManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTQunManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSString *userId = _letterArr[indexPath.section ][@"cityS"][indexPath.row][@"UserId"];
            //传值
            objc_setAssociatedObject(cell.XuanZhongBtn, @"UserId", userId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//实际上就是KVC
            
            [cell.XuanZhongBtn addTarget:self action:@selector(XuanZhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.XuanZhongBtn.selected = NO;
            
            if (_QunType == 0) {
                
                cell.XuanZhongBtn.hidden = YES;
            }else{
                
                cell.XuanZhongBtn.hidden = NO;
                
            }
            
            
            
            
            cell.contentLab.text = [NSString NULLToString:_letterArr[indexPath.section][@"cityS"][indexPath.row][@"NickName"]];
            NSString *Str = _letterArr[indexPath.section][@"cityS"][indexPath.row][@"PortraitBig"];
            if (Str.length > 0 ) {
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_letterArr[indexPath.section][@"cityS"][indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
}



#pragma mark - 选中事件
- (void)XuanZhongBtnClick:(UIButton *)btn{
    
    if (btn.selected) {
        
        btn.selected = NO;
        
        NSString *UserId = objc_getAssociatedObject(btn, @"UserId");
        
        if (_QunType == 3 || _QunType == 0 || _QunType == 4 || _QunType == 2) {
            //多选(取消)
            if (isManageSearch) {
                
               
            }else{
                NSArray *Tarr = [NSArray arrayWithArray:dataQunX];
                for (NSString *Str in Tarr) {
                    
                    if ([UserId isEqualToString:Str]) {
                        
                        [dataQunX removeObject:UserId];
                    }
                }
            }
        }else{
            //单选(取消)
            if (isManageSearch) {
                
                
            }else{
                
                [dataQunX removeAllObjects];
                
            }
        }
    }else{
        
        btn.selected = YES;
        
        NSString *UserId = objc_getAssociatedObject(btn, @"UserId");
        
        NSString *XuanUserId;
        
        if (_QunType == 3 || _QunType == 0 || _QunType == 4 || _QunType == 2) {
            //多选
            if (isManageSearch) {
                
                XuanUserId = UserId;
            }else{
                
                
                [dataQunX addObject:UserId];
            }
        }else{
            //单选
            if (isManageSearch) {
                
                
            }else{
                
                [dataQunX removeAllObjects];
                [dataQunX addObject:UserId];
                
                [_ManageTabV reloadData];
            }

        }
        
        
        
        
    }
    
}

#pragma mark UISearchBarDelegate

//搜索框中的内容发生改变时 回调（即要搜索的内容改变）

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(@"changed");
    
    NSString *text = _SearchManage.text;
    
    SearchManageResults = [self searchWordsWithText:text];
    
    
    if (SearchManageResults.count != 0) {
        
        isManageSearch = YES;
        [_ManageTabV reloadData];
    }else{
        
        isManageSearch = NO;
        [_ManageTabV reloadData];
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
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        
    }
    
    NSLog(@"shuould begin");
    
    
    return YES;
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    
    NSLog(@"did begin");
    
    
    SearchManageResults = nil;
    isManageSearch = NO;
    [_ManageTabV reloadData];
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
    
    _SearchManage.text = @"";
    
    [_SearchManage resignFirstResponder];
    
    SearchManageResults = nil;
    isManageSearch = NO;
    [_ManageTabV reloadData];
    
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
    
    
    return searchArray;
    
}

#pragma mark - 排序
- (NSMutableArray *)createrCSList:(NSMutableArray *)Arr {
    
    for (int i = 0; i < Arr.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:Arr[i]];
        
        NSString *CataName ;
        
        if (dict[@"NickName"] != nil) {
            
            CataName = dict[@"NickName"];
        }
        
        NSString *Char = [WKProgressHUD firstCharactor:CataName];
        
        [dict setValue:Char forKey:@"CharName"];
        
        //去重
        BOOL setBool = YES;
        for (int z = 0; z < dataJQArr.count; z++) {
            
            NSString *charEve = dataJQArr[z][@"char"];
            
            if ([charEve isEqualToString:Char]) {
                
                setBool = NO;
                
                NSMutableArray *cityArray = dataJQArr[z][@"cityS"];
                [cityArray addObject:dict];
                
                NSDictionary *charCityEveDict = @{@"char":Char,@"cityS":cityArray};
                dataJQArr[z] = charCityEveDict;
                
            }
        }
        
        if (setBool == YES) {
            
            NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:0];
            [cityArray addObject:dict];
            NSDictionary *charCityEveDict = @{@"char":Char,@"cityS":cityArray};
            [dataJQArr addObject:charCityEveDict];
            
        }
        
    }
    
    
    //  _________________________________________________________________________________________________HYC_________________________________________________________________________________
    //排序
    for (int q = 0; q < dataJQArr.count; q ++) {
        
        for (int w = 0; w < q; w++) {
            
            //比较两个字符串 大 小 相等
            NSString *str15= dataJQArr[w][@"char"];
            NSString *str16=dataJQArr[w+1][@"char"];
            NSComparisonResult ret2=[str15 compare:str16];
            
            if (ret2==1) {
                
                NSDictionary *ttt = dataJQArr[w];
                
                dataJQArr[w] = dataJQArr[w+1];
                dataJQArr[w+1] = ttt;
                q--;
                
                
            }
            
        }
        
    }
    
    return dataJQArr;
}

#pragma mark - 去重
- (NSMutableArray *)DistinctList:(NSMutableArray *)Arr {
    
    for (NSDictionary *dataDict in _dataManageArr) {
        
        for (NSDictionary *dict in Arr) {
            
            if ([dict[@"NickName"] isEqualToString:dataDict[@"NickName"]]) {
            
                [Arr removeObject:dict];
                break;
            }
        }
    }
    
    return Arr;
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

//确定按钮
- (IBAction)SureBtnClick:(id)sender {
    
    if (dataQunX.count > 0) {
        
        NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSString *GroupId = [NSString NULLToString:_dataQunDeDict[@"GroupId"]];
        
        NSDictionary *parameters;
        NSString *login_Str;
        
        if (_QunType == 1) {    //移交群主权限
            
            NSString *ToUserId = dataQunX[0];
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",ToUserId,@"ToUserId",nil];
            
            login_Str = WoTing_ChangGuoupMaster;
        }else if (_QunType == 2) {    //设置管理员(增加)
            
            NSString *AddAdminUserIds;
            NSMutableString *Mstr;
            
            if (dataQunX.count > 0) {
                Mstr = [NSMutableString stringWithString:dataQunX[0]];
                for (int i = 1; i < dataQunX.count; i++) {
                    NSString *str = dataQunX[i];
                    [Mstr appendFormat:@",%@",str];
                }
            }
            
            AddAdminUserIds = Mstr;
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",AddAdminUserIds,@"AddAdminUserIds",nil];
            
            login_Str = WoTing_SetGroupAdmin;
        }else if (_QunType == 3) {    //邀请用户成为群成员
            
            NSString *BeInvitedUserIds;
            NSMutableString *Mstr;
            
            if (dataQunX.count > 0) {
                Mstr = [NSMutableString stringWithString:dataQunX[0]];
                for (int i = 1; i < dataQunX.count; i++) {
                    NSString *str = dataQunX[i];
                    [Mstr appendFormat:@",%@",str];
                }
            }
            
            BeInvitedUserIds = Mstr;
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",BeInvitedUserIds,@"BeInvitedUserIds",nil];
            
            login_Str = WoTing_GroupInvite;
        }else if (_QunType == 4) {    //删除群成员
            
            NSString *BeInvitedUserIds;
            NSMutableString *Mstr;
            
            if (dataQunX.count > 0) {
                Mstr = [NSMutableString stringWithString:dataQunX[0]];
                for (int i = 1; i < dataQunX.count; i++) {
                    NSString *str = dataQunX[i];
                    [Mstr appendFormat:@",%@",str];
                }
            }
            
            BeInvitedUserIds = Mstr;
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",BeInvitedUserIds,@"UserIds",nil];
            
            login_Str = WoTing_KickoutGroup;
        }
        NSLog(@"%@", parameters);
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                if (_QunType == 1) {
                    
                    [WKProgressHUD popMessage:@"群主移交成功" inView:nil duration:0.5 animated:YES];
                }else if (_QunType == 2){
                    
                    [WKProgressHUD popMessage:@"设置管理成功" inView:nil duration:0.5 animated:YES];
                }else if (_QunType == 3){
                    
                    [WKProgressHUD popMessage:@"邀请发送成功" inView:nil duration:0.5 animated:YES];
                }else if (_QunType == 4){
                    
                    [WKProgressHUD popMessage:@"删除成员成功" inView:nil duration:0.5 animated:YES];
                }
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"200"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
    }else{
        
        
        
    }
}

//管理去群主
- (NSArray *)ManageArr:(NSArray *)Array andQunStrId:(NSString *)QunId{
    
    NSArray *Tarr = [NSArray arrayWithArray:Array];
    NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:0];
    [Marr addObjectsFromArray:Array];
    for (NSString *Str in Tarr) {
        
        if ([Str isEqualToString:QunId]) {
            
            [Marr removeObject:Str];
        }
    }
    
    return [NSArray arrayWithArray:Marr];
}






@end
