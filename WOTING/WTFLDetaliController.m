//
//  WTFLDetaliController.m
//  WOTING
//
//  Created by jq on 2016/12/14.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTFLDetaliController.h"

#import "WTZhuanJiViewController.h"

#import "WTBoFangTableViewCell.h"
#import "WTLikeCell.h"

/** 轮播图片 */
#import "SDCycleScrollView.h"

@interface WTFLDetaliController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    /** 数据数组 */
    NSMutableArray          *dataFLDJArray;
    
    /** 轮播图 */
    SDCycleScrollView        *scrollView;
    NSArray                 *imageNameArray;
}

@end

@implementation WTFLDetaliController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _nameLab.text = _nameL;
    dataFLDJArray = [NSMutableArray arrayWithCapacity:0];
    
    imageNameArray = [[NSArray alloc] initWithObjects:@"WTceshi1.jpg",@"WTceshi2.jpg",@"WTceshi3.jpg",@"WTceshi4.jpg", nil];
    

    _FLDTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _FLDTableView.delegate = self;
    _FLDTableView.dataSource = self;

    _FLDTableView.tableFooterView = [[UIView alloc] init];
    
    scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, POINT_Y(320)) delegate:self placeholderImage:[UIImage imageNamed:@"liangYan.png"]];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _FLDTableView.tableHeaderView = scrollView;
    
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
    _FLDTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_FLDTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    
}

- (void)loadData {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    //"MediaType":"","CatalogType":"3","CatalogId":"cn10","Page":"1","PerSize":"3","ResultType":"2","PageSize":"10"
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", @"3",@"CatalogType",@"10",@"PageSize",@"2",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [_FLDTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataFLDJArray removeAllObjects];
            [dataFLDJArray addObjectsFromArray: ResultList[@"List"]];
            
            [_FLDTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [_FLDTableView.mj_header endRefreshing];

        
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataFLDJArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([dataFLDJArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        static NSString *cellID = @"cellIDL";
        
        WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataFLDJArray[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
    }else {
        
        static NSString *cellID = @"cellID";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataFLDJArray[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
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
    
    if ([dataFLDJArray[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
        wtZJVC.hidesBottomBarWhenPushed = YES;
        wtZJVC.contentID = [NSString NULLToString:dataFLDJArray[indexPath.row][@"ContentId"]] ;
        [self.navigationController pushViewController:wtZJVC animated:YES];
        
    }else{
        
        NSDictionary *dict = dataFLDJArray[indexPath.row];
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

- (IBAction)balckBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
