//
//  WTDianTaiViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//


#import "WTDianTaiViewController.h"

#import <CoreLocation/CoreLocation.h>

#import "WTDTController.h"      //国家, 地方, 网络台

#import "WTDTDetailViewController.h"

#import "WTDianTaiTableViewCell.h"

#import "WTXJHeaderView.h"

@interface WTDianTaiViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView        *jqTableView;
    
    /** 数据数组 */
    NSMutableArray          *dataDianTArray;
    NSMutableArray          *dataListArr;
    
    //sectio视图
    WTXJHeaderView      *XJsectionHView;
    
    NSString           *BeginCatalogId;
}

@end

@implementation WTDianTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataDianTArray = [NSMutableArray arrayWithCapacity:0];
    dataListArr = [NSMutableArray arrayWithCapacity:0];
    
    NSString *City = [AutomatePlist readPlistForKey:@"City"];
        
    jqTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height) style:UITableViewStyleGrouped];
    jqTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    jqTableView.delegate = self;
    jqTableView.dataSource = self;
    [self.view addSubview:jqTableView];
    __weak WTDianTaiViewController *Weakself = self;
    [jqTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(Weakself.view);
    }];
    jqTableView.tableFooterView = [[UIView alloc] init];
    
    [self initHeaderView];
    [self registerTabViewCell];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 增加下拉刷新事件 */
    jqTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    /** 上拉加载更多 */
    jqTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveData)];
}

//创建头视图
- (void)initHeaderView{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(260))];
    headerView.backgroundColor = [UIColor whiteColor];
    jqTableView.tableHeaderView = headerView;
    
    //国家台
    UIButton *GJTaiBtn = [[UIButton alloc] init];
    [GJTaiBtn setImage:[UIImage imageNamed:@"icon_central_station.png"] forState:UIControlStateNormal];
    [GJTaiBtn addTarget:self action:@selector(DTGJBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:GJTaiBtn];
    [GJTaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(40));
        make.top.mas_equalTo(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(140));
        make.height.mas_equalTo(POINT_X(140));
    }];
    UILabel *GJLab = [[UILabel alloc] init];
    GJLab.text = @"国家台";
    GJLab.font = [UIFont boldSystemFontOfSize:14];
    GJLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:GJLab];
    [GJLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(40));
        make.top.equalTo(GJTaiBtn.mas_bottom).with.offset(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(140));
        make.height.mas_equalTo(POINT_X(30));
    }];
    
    //地方台
    UIButton *DFTaiBtn = [[UIButton alloc] init];
    [DFTaiBtn setBackgroundImage:[UIImage imageNamed:@"icon_local_station.png"] forState:UIControlStateNormal];
    [DFTaiBtn addTarget:self action:@selector(DTBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:DFTaiBtn];
    [DFTaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(headerView.mas_centerX);
        make.top.mas_equalTo(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(140));
        make.height.mas_equalTo(POINT_X(140));
    }];
    UILabel *DFLab = [[UILabel alloc] init];
    DFLab.text = @"地方台";
    DFLab.font = [UIFont boldSystemFontOfSize:14];
    DFLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:DFLab];
    [DFLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(headerView.mas_centerX);
        make.top.equalTo(DFTaiBtn.mas_bottom).with.offset(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(140));
        make.height.mas_equalTo(POINT_X(30));
    }];
    
    //网络台
    UIButton *WLTaiBtn = [[UIButton alloc] init];
    [WLTaiBtn setImage:[UIImage imageNamed:@"icon_network_station.png"] forState:UIControlStateNormal];
    [WLTaiBtn addTarget:self action:@selector(DTWLBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:WLTaiBtn];
    [WLTaiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(40));
        make.top.mas_equalTo(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(140));
        make.height.mas_equalTo(POINT_X(140));
    }];
    UILabel *WLLab = [[UILabel alloc] init];
    WLLab.text = @"网络台";
    WLLab.font = [UIFont boldSystemFontOfSize:14];
    WLLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:WLLab];
    [WLLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(40));
        make.top.equalTo(WLTaiBtn.mas_bottom).with.offset(POINT_Y(30));
        make.width.mas_equalTo(POINT_X(140));
        make.height.mas_equalTo(POINT_X(30));
    }];
}

//地方按钮点击事件
- (void)DTBtnClick:(UIButton *)btn {
    
    WTDTController *wtDC = [[WTDTController alloc] init];
    wtDC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtDC animated:YES];
}

//国家台
- (void)DTGJBtnClick:(UIButton *)btn {
    
    WTDTDetailViewController *wtDtDVC = [[WTDTDetailViewController alloc] init];
    wtDtDVC.hidesBottomBarWhenPushed = YES;
    wtDtDVC.type = 3;
    wtDtDVC.nameStr = @"国家台";
    [self.navigationController pushViewController:wtDtDVC animated:YES];
}

//网络台
- (void)DTWLBtnClick:(UIButton *)btn {
    
    WTDTDetailViewController *wtDtDVC = [[WTDTDetailViewController alloc] init];
    wtDtDVC.hidesBottomBarWhenPushed = YES;
    wtDtDVC.type = 1;
    wtDtDVC.nameStr = @"网络台";
    [self.navigationController pushViewController:wtDtDVC animated:YES];
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTDianTaiTableViewCell" bundle:nil];
    
    [jqTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

//数据请求
- (void)loadData {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    //"MediaType":"",//全部
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"1",@"CatalogType",@"1",@"ResultType",@"3",@"PerSize",nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [jqTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataListArr removeAllObjects];
            [dataListArr addObjectsFromArray: ResultList[@"List"]];
            BeginCatalogId = ResultList[@"BeginCatalogId"];
            
            [jqTableView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [jqTableView.mj_header endRefreshing];
        
    }];
    
    
}

- (void)loadMoveData {
    
    static NSInteger page = 2;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",@"RADIO",@"MediaType", @"1",@"CatalogType",@"1",@"ResultType",@"3",@"PerSize",BeginCatalogId,@"BeginCatalogId", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [jqTableView.mj_footer endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            
            [dataListArr addObjectsFromArray: ResultList[@"List"]];
            
            BeginCatalogId = ResultList[@"BeginCatalogId"];
            
            [jqTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [jqTableView.mj_footer endRefreshing];

        
    }];
    
    page++;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return dataListArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arrayD = dataListArr[section][@"List"];
    return arrayD.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTDianTaiTableViewCell *cell = (WTDianTaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTDianTaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = dataListArr[indexPath.section][@"List"][indexPath.row];
    
    [cell setCellWithDict:dict];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.000000000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    XJsectionHView = [[WTXJHeaderView alloc] init];
    XJsectionHView.delegate = self;
    XJsectionHView.NameLab.text = dataListArr[section][@"CatalogName"];
    XJsectionHView.NameStr = dataListArr[section][@"CatalogName"];
    XJsectionHView.contentId = dataListArr[section][@"CatalogId"];
    
    return XJsectionHView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = dataListArr[indexPath.section][@"List"][indexPath.row];
    NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
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

@end
