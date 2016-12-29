//
//  WTTuiJianViewController.m
//  WOTING
//
//  Created by jq on 2016/12/1.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTTuiJianViewController.h"

#import "WTZhuanJiViewController.h"

#import "WTBoFangTableViewCell.h"
#import "WTLikeCell.h"

/** 轮播图片 */
#import "SDCycleScrollView.h"

@interface WTTuiJianViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    UITableView        *skTableView;
    
    /** 数据数组 */
    NSMutableArray          *dataTuiJArray;
    
    /** 轮播图 */
    SDCycleScrollView        *scrollView;
    NSArray           *imageNameArray;
}

@end

@implementation WTTuiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataTuiJArray = [NSMutableArray arrayWithCapacity:0];
    
    imageNameArray = [[NSArray alloc] initWithObjects:@"WTceshi1.jpg",@"WTceshi2.jpg",@"WTceshi3.jpg",@"WTceshi4.jpg", nil];
    
    skTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height) style:UITableViewStyleGrouped];
    skTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    skTableView.delegate = self;
    skTableView.dataSource = self;
    [self.view addSubview:skTableView];
    __weak WTTuiJianViewController *Weakself = self;
    [skTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(Weakself.view);
    }];
    skTableView.tableFooterView = [[UIView alloc] init];
    
    scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, POINT_Y(320)) delegate:self placeholderImage:[UIImage imageNamed:@"liangYan.png"]];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    skTableView.tableHeaderView = scrollView;
    
    scrollView.imageURLStringsGroup = imageNameArray;//图片
    /** 设置轮播pageControl位置 */
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.currentPageDotColor = [UIColor JQTColor];
    
    [self registerTabViewCell];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 增加下拉刷新事件 */
    skTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    /** 上拉加载更多 */
    skTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveData)];
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [skTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [skTableView registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
}


- (void)loadData {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [skTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataTuiJArray removeAllObjects];
            [dataTuiJArray addObjectsFromArray: ResultList[@"List"]];
            
            [skTableView reloadData];
   
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
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
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",pageStr,@"Page",  nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [skTableView.mj_footer endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            
            [dataTuiJArray addObjectsFromArray: ResultList[@"List"]];
          
            [skTableView reloadData];
   
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [skTableView.mj_header endRefreshing];
        NSLog(@"%@", error);
        
    }];
    
    page++;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataTuiJArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([dataTuiJArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        static NSString *cellID = @"cellIDL";
        
        WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataTuiJArray[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
    }else {
        
        static NSString *cellID = @"cellID";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataTuiJArray[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *labeltitle = [[UILabel alloc] init];
    labeltitle.text = @"猜你喜欢";
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
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([dataTuiJArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
        wtZJVC.hidesBottomBarWhenPushed = YES;
        wtZJVC.contentID = [NSString NULLToString:dataTuiJArray[indexPath.row][@"ContentId"]] ;
        [self.navigationController pushViewController:wtZJVC animated:YES];
        
    }else{
        
        NSDictionary *dict = dataTuiJArray[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
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
