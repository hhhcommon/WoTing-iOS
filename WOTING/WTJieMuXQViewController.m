//
//  WTJieMuXQViewController.m
//  WOTING
//
//  Created by jq on 2017/2/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTJieMuXQViewController.h"

#import "WTJMDCell.h"

@interface WTJieMuXQViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataJMDArr;
}

@end

@implementation WTJieMuXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataJMDArr = [NSMutableArray arrayWithCapacity:0];
    
    _JieMuDanTab.delegate = self;
    _JieMuDanTab.dataSource = self;
    
    [self RegisterJMDCell];
    [self loadDataJMD];
}

- (void)RegisterJMDCell {
    
    UINib *nib = [UINib nibWithNibName:@"WTJMDCell" bundle:nil];
    
    [_JieMuDanTab registerNib:nib forCellReuseIdentifier:@"cellJMD"];
}

- (void)loadDataJMD {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",_bcId,@"BcId",@"",@"RequestTimes",  nil];
    
    NSString *login_Str = WoTing_JMD;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataJMDArr removeAllObjects];
            [dataJMDArr addObjectsFromArray: ResultList[@"List"]];
            
            [_JieMuDanTab reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataJMDArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *cellID = @"cellJMD";
    
    WTJMDCell *cell = (WTJMDCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTJMDCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
   // NSDictionary *dict = dataJMDArr[indexPath.row];
  
    return cell;
    
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
