//
//  WTDingYueController.m
//  WOTING
//
//  Created by jq on 2017/3/22.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTDingYueController.h"


#import "WTBoFangTableViewCell.h"
#import "WTDingYueCell.h"

@interface WTDingYueController ()<UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *dataDingYueArr;
}

@end

@implementation WTDingYueController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataDingYueArr = [NSMutableArray arrayWithCapacity:0];
    
    _DingYueTabV.delegate = self;
    _DingYueTabV.dataSource = self;
    
    _DingYueTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerDingYueTabCell];
    [self loadDataDingYue];
}

- (void)registerDingYueTabCell{
    
    UINib *nib = [UINib nibWithNibName:@"WTDingYueCell" bundle:nil];
    [_DingYueTabV registerNib:nib forCellReuseIdentifier:@"CellIDDY"];
    
}

//请求数据
- (void)loadDataDingYue{
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    if ([uid isEqualToString:@"0"]||[uid isEqualToString:@""]) {
        
        [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
    }else {
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",nil];
        
        NSString *login_Str = WoTing_DingYueList;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                NSDictionary *ResultList = resultDict[@"ResultList"];
                
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1011"] && [resultDict[@"Message"] isEqualToString:@"无数据"]){
                
                [WKProgressHUD popMessage:@"无数据" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataDingYueArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

        
    static NSString *cellID = @"CellIDDY";
    
    WTDingYueCell *cell = (WTDingYueCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    [cell.contentImage sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataDingYueArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@""]];
    
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
