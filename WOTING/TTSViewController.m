//
//  TTSViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "TTSViewController.h"

#import "WTBoFangTableViewCell.h"

@interface TTSViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray  *_dataTTSArr;
}

@end

@implementation TTSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataTTSArr = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TTSTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TTSTableView.delegate = self;
    _TTSTableView.dataSource = self;
    
    _TTSTableView.tableFooterView = [[UIView alloc] init];
    
    [self registerTabViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_TTSTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

- (void)loadTTSLike {
    
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
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            
            if (_SearchStr == nil) {
                
                for (NSDictionary *dict in ResultList[@"FavoriteList"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"TTS"]) {
                        
                        [_dataTTSArr addObjectsFromArray:dict[@"List"]];
                        
                    }
                }
                
            }else {
                
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString:@"TTS"]) {
                        
                        [_dataTTSArr addObject:dict];
                    }
                }
                
            }
            [_TTSTableView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataTTSArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = _dataTTSArr[indexPath.row];
    [cell setCellWithDict:dict];
    
    
    return cell;
    
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
