//
//  WTZhuBoController.m
//  WOTING
//
//  Created by jq on 2017/3/23.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTZhuBoController.h"

@interface WTZhuBoController (){
    
    NSMutableDictionary *dataZBDict;    //主播所有数据
    NSMutableArray *dataZBArr;  //主播数据
}

@end

@implementation WTZhuBoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataZBDict = [NSMutableDictionary dictionaryWithCapacity:0];
    dataZBArr = [NSMutableArray arrayWithCapacity:0];
    
    [self loadZhuBoData];
}

- (void)loadZhuBoData {
    
    
    NSString *PersonId = _dataDefDict[@"ContentPersons"][0][@"PerId"];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",PersonId,@"PersonId",@"3",@"SeqMediaSize",@"10",@"MediaAssetSize",uid,@"UserId", nil];
    
    
    NSString *login_Str = WoTing_ZhuBo;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataZBDict removeAllObjects];
            [dataZBDict addEntriesFromDictionary:resultDict];
            
            [dataZBArr removeAllObjects];
            [dataZBArr addObjectsFromArray:resultDict[@"MediaAssetList"]];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
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

- (IBAction)backBtnClick:(id)sender {
}

- (IBAction)GuanZhuBtnClick:(id)sender {
}
@end
