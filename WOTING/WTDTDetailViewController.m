//
//  WTDTDetailViewController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDTDetailViewController.h"

#import "WTDianTaiTableViewCell.h"

@interface WTDTDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
    NSMutableArray  *dataCellArr;// 数据源数组
}

@end

@implementation WTDTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataCellArr = [NSMutableArray arrayWithCapacity:0];
    
    _jqTabView.delegate = self;
    _jqTabView.dataSource = self;
    
    [self loadDataGD];
    [self createrRegisterCell];
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
    
    //"MediaType":"",//全部
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"1",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            dataCellArr = ResultList[@"List"];
            
            
            [_jqTabView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataCellArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTDianTaiTableViewCell *cell = (WTDianTaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTDianTaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = dataCellArr[indexPath.row];
    
    [cell setCellWithDict:dict];
    
    
    return cell;
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
