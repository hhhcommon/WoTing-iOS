//
//  ShengYinViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "ShengYinViewController.h"

#import "WTBoFangTableViewCell.h"

@interface ShengYinViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ShengYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataSYArr = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _SYTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _SYTableView.delegate = self;
    _SYTableView.dataSource = self;
    
    _SYTableView.tableFooterView = [[UIView alloc] init];
    
    [self registerTabViewCell];
    
    if (_dataSYLSArr) {     //播放历史
        
        [_SYTableView reloadData];
    }else {
        [self loadSYLike];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 上拉加载更多 */
    _SYTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadSYLike)];
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_SYTableView registerNib:cellNib forCellReuseIdentifier:@"cellIDSY"];
    
}

- (void)loadSYLike {
    
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
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",_SearchStr,@"SearchStr",@"AUDIO",@"MediaType", nil];
        
        login_Str = WoTing_searchBy;
        
    }
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_SYTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [_dataSYArr removeAllObjects];
            
            if (_SearchStr == nil) {
                
                for (NSDictionary *dict in ResultList[@"FavoriteList"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"AUDIO"]) {
                        
                        [_dataSYArr addObjectsFromArray:dict[@"List"]];
                        
                    }
                }

                
            }else {
                
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"AUDIO"]) {
                        
                        
                        [_dataSYArr addObject:dict];
                    }
                }
                
            }
            
            [_SYTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [_SYTableView.mj_header endRefreshing];
        
    }];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataSYLSArr) {
        
        return _dataSYLSArr.count;
    }else {
        return _dataSYArr.count;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataSYLSArr) {
        
        static NSString *cellID = @"cellIDSY";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.WTBoFangImgV.hidden = YES;
        NSDictionary *dict = _dataSYLSArr[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
        
    }else{
    
        static NSString *cellID = @"cellIDSY";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.WTBoFangImgV.hidden = YES;
        NSDictionary *dict = _dataSYArr[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataSYLSArr) {
        
        NSDictionary *dict = _dataSYLSArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        
        //回首页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
        
        self.tabBarController.selectedIndex = 0;
    }else{
        NSDictionary *dict = _dataSYArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        
        //回首页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
        
        self.tabBarController.selectedIndex = 0;
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
