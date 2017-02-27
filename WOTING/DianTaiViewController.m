//
//  DianTaiViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "DianTaiViewController.h"

#import "WTBoFangTableViewCell.h"

@interface DianTaiViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray  *_dataDTArr;
}

@end

@implementation DianTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataDTArr = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _DTTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _DTTableView.delegate = self;
    _DTTableView.dataSource = self;
    
    _DTTableView.tableFooterView = [[UIView alloc] init];
    
    [self registerTabViewCell];
    
    if (_dataDTLSArr) {     //播放历史
        
        [_DTTableView reloadData];
    }else{
        [self loadDTLike];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 上拉加载更多 */
    _DTTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDTLike)];
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_DTTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

- (void)loadDTLike {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters;
    NSString *login_Str;
    
    if ( _SearchStr == nil) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",@"2",@"ResultType", nil];
        
        login_Str = WoTing_likeList;
        
    }else {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",_SearchStr,@"SearchStr",@"SEQU",@"MediaType", nil];
        
        login_Str = WoTing_searchBy;
        
    }
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_DTTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [_dataDTArr removeAllObjects];
            
            if (_SearchStr == nil) {
                
                for (NSDictionary *dict in ResultList[@"FavoriteList"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"RADIO"]) {
                        
                        [_dataDTArr addObjectsFromArray:dict[@"List"]];
                        
                    }
                }
                
            }else {
                
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"RADIO"]) {
                        
                        [_dataDTArr addObject:dict];
                    }
                }
                
            }
            
            [_DTTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [_DTTableView.mj_header endRefreshing];
        
    }];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDTLSArr) {
        
        return _dataDTLSArr.count;
    }else {
        return _dataDTArr.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataDTLSArr) {
        
        static NSString *cellID = @"cellID";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.WTBoFangImgV.hidden = YES;
        NSDictionary *dict = _dataDTLSArr[indexPath.row];
        
        [cell setCellWithDict:dict];
        
        
        return cell;
    }else {
        static NSString *cellID = @"cellID";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.WTBoFangImgV.hidden = YES;
        NSDictionary *dict = _dataDTArr[indexPath.row];
        
        [cell setCellWithDict:dict];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataDTLSArr) {
        
        NSDictionary *dict = _dataDTLSArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [self.navigationController popToRootViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
    }else{
        NSDictionary *dict = _dataDTArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
