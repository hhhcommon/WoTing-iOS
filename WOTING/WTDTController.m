//
//  WTDTController.m
//  WOTING
//
//  Created by jq on 2016/12/13.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDTController.h"

@interface WTDTController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
    NSMutableArray  *dataDTArr;
    
    NSMutableArray  *CityArr;
}

@end

@implementation WTDTController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataDTArr = [NSMutableArray arrayWithCapacity:0];
    CityArr = [NSMutableArray arrayWithCapacity:0];
    
    _detableView.delegate = self;
    _detableView.dataSource = self;
    _detableView.showsVerticalScrollIndicator = NO;
    _detableView.showsHorizontalScrollIndicator = NO;
    
    _detableView.sectionIndexBackgroundColor = [UIColor clearColor];
    
    [self loadData];
}

- (void)loadData {
    
    NSString *Uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters;
    
    if (Uid && ![Uid  isEqual: @"0"]) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",Uid,@"UserId",  @"2",@"CatalogType",@"1",@"ResultType",@"3",@"RelLevel",@"1",@"Page",nil];
    }else{
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",  @"2",@"CatalogType",@"1",@"ResultType",@"3",@"RelLevel",@"1",@"Page",nil];
    }

    
    
    NSString *login_Str = WoTing_getCatalogInfo;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"CatalogData"];
            
            [dataDTArr removeAllObjects];
            [dataDTArr addObjectsFromArray: ResultList[@"SubCata"]];
            
         //   [self createrCSList];
            
            [_detableView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];

    
}

- (void)createrCSList {
    
    NSDictionary *dictA = [[NSDictionary alloc] init];
    
    for (int i = 0; i < dataDTArr.count; i++) {
        
        NSDictionary *dict = dataDTArr[i];
        NSString *CataName = dict[@"CatalogName"];
        
        NSString *Char = [WKProgressHUD firstCharactor:CataName];
        NSLog(@"%@", Char);
        if ([Char isEqualToString:@"A"]) {
            
            [dictA setValue:@"CatalogName" forKey:CataName];
        }else if ([Char isEqualToString:@"B"]) {
            
            
        }
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    unichar ch = 65 + section;
    NSString * str = [NSString stringWithUTF8String:(char *)&ch];
    return str;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
  
    NSArray *rightShouZiMuArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    return rightShouZiMuArr;
    
}

//-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
//{
//    NSInteger count = 0;
//    
//    for(NSString *character in dataDTArr)
//    {
//        if([character isEqualToString:title])
//        {
//            return count;
//        }
//        count ++;
//    }
//
//    return 0;
//}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 26;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((dataDTArr && dataDTArr.count > 0) ? dataDTArr.count : 0);

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *cityDict = dataDTArr[indexPath.row];
    static NSString * cellID = @"cellID";
    UITableViewCell * cell = [_detableView dequeueReusableCellWithIdentifier:cellID];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
 
    
    cell.textLabel.text = cityDict[@"CatalogName"];
    
    
    return cell;
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


- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
