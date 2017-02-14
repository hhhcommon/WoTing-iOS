//
//  ZhuanJiViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "ZhuanJiViewController.h"

#import "WTZhuanJiViewController.h"

#import "WTLikeCell.h"

@interface ZhuanJiViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    NSInteger   firstLoad;  //是否是第一次加载数据
}

@end

@implementation ZhuanJiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    firstLoad = 0;
    _dataZJArr = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _ZJTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _ZJTableView.delegate = self;
    _ZJTableView.dataSource = self;
    
    _ZJTableView.tableFooterView = [[UIView alloc] init];
    
    [self registerTabViewCell];
    [self loadZJLike];  //加载数据
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 上拉加载更多 */
    _ZJTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadZJLike)];
}

//注册
- (void)registerTabViewCell{
    
    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [_ZJTableView registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
}

- (void)loadZJLike {
    
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
        
        [_ZJTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [_dataZJArr removeAllObjects];
            
            if ( _SearchStr == nil) {
            
                for (NSDictionary *dict in ResultList[@"FavoriteList"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"SEQU"]) {
                        
                        [_dataZJArr addObjectsFromArray:dict[@"List"]];
                    }
                }
            }else {
                
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"SEQU"]) {
                        
                        [_dataZJArr addObject:dict];
                    }
                }
                
            }
            
            [_ZJTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [_ZJTableView.mj_header endRefreshing];
        
    }];
    
}

////加载更多
//- (void)loadMoveData {
//    
//    static NSInteger page = 2;
//    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
//    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
//    
//    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
//    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
//    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
//    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
//    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
//    
//    NSDictionary *parameters;
//    NSString *login_Str;
//    
//    if ( _SearchStr == nil) {
//        
//        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",@"2",@"ResultType",pageStr,@"Page", nil];
//        
//        login_Str = WoTing_likeList;
//        
//    }else {
//        
//        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",_SearchStr,@"SearchStr",@"SEQU",@"MediaType",pageStr,@"Page", nil];
//        
//        login_Str = WoTing_searchBy;
//        
//    }
//    
//    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
//        
//         [_ZJTableView.mj_footer endRefreshing];
//        
//        NSDictionary *resultDict = (NSDictionary *)response;
//        
//        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
//        if ([ReturnType isEqualToString:@"1001"]) {
//            
//            NSDictionary *ResultList = resultDict[@"ResultList"];
//            
//            if ( _SearchStr == nil) {
//                
//                for (NSDictionary *dict in ResultList[@"FavoriteList"]) {
//                    
//                    if ([dict[@"MediaType"] isEqualToString:@"SEQU"]) {
//                        
//                        [_dataZJArr addObject:dict[@"List"]];
//                    }
//                }
//            }else {
//                
//                for (NSDictionary *dict in ResultList[@"List"]) {
//                    
//                    if ([dict[@"MediaType"] isEqualToString:@"SEQU"]) {
//                        
//                        [_dataZJArr addObject:dict];
//                    }
//                }
//                
//            }
//            
//            [_ZJTableView reloadData];
//            
//            
//        }else if ([ReturnType isEqualToString:@"T"]){
//            
//            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
//        }else if ([ReturnType isEqualToString:@"1011"]){
//            
//            [_ZJTableView.mj_footer endRefreshingWithNoMoreData];
//        }
//        
//    } fail:^(NSError *error) {
//        
//         [_ZJTableView.mj_footer endRefreshing];
//        
//    }];
//    
//    page++;
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataZJArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellIDL";
    
    WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = _dataZJArr[indexPath.row];
    [cell setCellWithDict:dict];
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([_dataZJArr[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
        
        wtZJVC.contentID = [NSString NULLToString:_dataZJArr[indexPath.row][@"ContentId"]] ;
        [self.navigationController pushViewController:wtZJVC animated:YES];
        
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
