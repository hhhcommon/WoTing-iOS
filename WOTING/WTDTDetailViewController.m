//
//  WTDTDetailViewController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDTDetailViewController.h"

#import "WTZhuanJiViewController.h"

#import "WTDianTaiTableViewCell.h"

#import "WTXJHeaderView.h"

@interface WTDTDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
    NSMutableArray  *dataCellArr;// 数据源数组
    NSString        *BeginCatalogId; //ID
    
    WTXJHeaderView      *XJsectionHView;
}

@end

@implementation WTDTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _NameLab.text = _nameStr;
    dataCellArr = [NSMutableArray arrayWithCapacity:0];
    
    _jqTabView.delegate = self;
    _jqTabView.dataSource = self;
    
    [self loadDataGD];
    [self createrRegisterCell];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 下拉刷新 */
    _jqTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataGD)];
    _jqTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveData)];
}

- (void)createrRegisterCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTDianTaiTableViewCell" bundle:nil];
    
    [_jqTabView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
}

- (void)loadDataGD {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    
    NSDictionary *parameters;
    
    if (_type == 0) {
        //电台详情
       parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"1",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",_contentID,@"CatalogId",nil];
    }else if (_type == 1){
        
        //网络台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",@"dtfl2002",@"CatalogId",nil];
        
        
    }else if (_type == 3){
        
        //国家台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"30",@"PageSize",@"dtfl2001",@"CatalogId",nil];
        
        
    }else {
        //地域选择
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"1",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",@"",@"BeginCatalogId",nil];
        
    }
    
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_jqTabView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataCellArr removeAllObjects];
            [dataCellArr addObjectsFromArray:ResultList[@"List"]];
            
            if (_type == 2) {
                
                BeginCatalogId = ResultList[@"BeginCatalogId"];
            }
            
            if (_type == 3) {   //国家台
                NSMutableArray *Zarray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *Garray = [NSMutableArray arrayWithCapacity:0];
                NSMutableDictionary *dictZ = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableDictionary *dictG = [NSMutableDictionary dictionaryWithCapacity:0];
                [dictZ setObject:@"中央台" forKey:@"TGP"];
                [dictG setObject:@"国际台" forKey:@"TGP"];
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"ContentPub"] isEqualToString:@"中央人民广播电台"]) {
                        
                        [Zarray addObject:dict];
                        [dictZ setObject:Zarray forKey:@"List"];
                    }else if ([dict[@"ContentPub"] isEqualToString:@"中国国际广播电台"]) {
                        
                        [Garray addObject:dict];
                        [dictG setObject:Garray forKey:@"List"];
                    }
                }
                
                [dataCellArr removeAllObjects];
                [dataCellArr addObject:dictZ];
                [dataCellArr addObject:dictG];
            }
            
            [_jqTabView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        [_jqTabView.mj_header endRefreshing];
        
    }];
    
}

//加载更多
- (void)loadMoveData {
    
    static NSInteger page = 2;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    
    NSDictionary *parameters;
    
    if (_type == 0) {
        //电台详情
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"1",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",_contentID,@"CatalogId",pageStr,@"Page",nil];
    }else if (_type == 1){
        
        //网络台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",@"dtfl2002",@"CatalogId",pageStr,@"Page",nil];
        
        
    }else if (_type == 3){
        
        //国家台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"30",@"PageSize",@"dtfl2001",@"CatalogId",pageStr,@"Page",nil];
        
        
    }else {
        //地域选择
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"1",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",BeginCatalogId,@"BeginCatalogId",pageStr,@"Page",nil];
        
    }
    
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_jqTabView.mj_footer endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            
            [dataCellArr addObjectsFromArray:ResultList[@"List"]];
            
            if (_type == 2) {
                
                BeginCatalogId = ResultList[@"BeginCatalogId"];
            }
            
            if (_type == 3) {   //国家台
                NSMutableArray *Zarray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *Garray = [NSMutableArray arrayWithCapacity:0];
                NSMutableDictionary *dictZ = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableDictionary *dictG = [NSMutableDictionary dictionaryWithCapacity:0];
                [dictZ setObject:@"中央台" forKey:@"TGP"];
                [dictG setObject:@"国际台" forKey:@"TGP"];
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"ContentPub"] isEqualToString:@"中央人民广播电台"]) {
                        
                        [Zarray addObject:dict];
                        [dictZ setObject:Zarray forKey:@"List"];
                    }else if ([dict[@"ContentPub"] isEqualToString:@"中国国际广播电台"]) {
                        
                        [Garray addObject:dict];
                        [dictG setObject:Garray forKey:@"List"];
                    }
                }
                
                [dataCellArr removeAllObjects];
                [dataCellArr addObject:dictZ];
                [dataCellArr addObject:dictG];
            }
            
            [_jqTabView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        [_jqTabView.mj_footer endRefreshing];
        
    }];
    
    page++;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_type == 3) {
        
        NSArray *array = dataCellArr[section][@"List"];
        return array.count;
    }else if (_type == 2){
        
        NSArray *array = dataCellArr[section][@"List"];
        return array.count;
    }else {
        
        return dataCellArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_type == 3) {
        
        return dataCellArr.count;
    }else if (_type == 2){
        
        return dataCellArr.count;
    }else {
        
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTDianTaiTableViewCell *cell = (WTDianTaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTDianTaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict;
    if (_type == 3) {
        
        dict = dataCellArr[indexPath.section][@"List"][indexPath.row];
    }else if (_type == 2){
        
        dict = dataCellArr[indexPath.section][@"List"][indexPath.row];
    }else {
        
        dict = dataCellArr[indexPath.row];
    }
    
    [cell setCellWithDict:dict];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_type == 3 || _type == 2) {
        
        return 35;
    }else {
        
        return 0;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_type == 3) {
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *labeltitle = [[UILabel alloc] init];
        labeltitle.text = dataCellArr[section][@"TGP"];
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
        
    }else if (_type == 2) {
        
        XJsectionHView = [[WTXJHeaderView alloc] init];
        XJsectionHView.delegate = self;
        XJsectionHView.NameLab.text = dataCellArr[section][@"CatalogName"];
        XJsectionHView.NameStr = dataCellArr[section][@"CatalogName"];
        XJsectionHView.contentId = dataCellArr[section][@"CatalogId"];
        
        return XJsectionHView;
        
    }else {
        
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.000000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([dataCellArr[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
        wtZJVC.hidesBottomBarWhenPushed = YES;
        wtZJVC.contentID = [NSString NULLToString:dataCellArr[indexPath.row][@"ContentId"]] ;
        [self.navigationController pushViewController:wtZJVC animated:YES];
        
    }else{
        
        NSDictionary *dict = dataCellArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

//返回
- (IBAction)blackBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
