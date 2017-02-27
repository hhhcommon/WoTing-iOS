//
//  WTDTController.m
//  WOTING
//
//  Created by jq on 2016/12/13.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDTController.h"

#import "WTDTDetailViewController.h"

@interface WTDTController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
    NSMutableArray  *dataDTArr;
    
    NSMutableArray  *CityArr;
    
    NSMutableArray *_letterArr;

}

@end

@implementation WTDTController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataDTArr = [NSMutableArray arrayWithCapacity:0];
    CityArr = [NSMutableArray arrayWithCapacity:0];
    _letterArr = [NSMutableArray arrayWithCapacity:0];
    
    _detableView.delegate = self;
    _detableView.dataSource = self;
    _detableView.showsVerticalScrollIndicator = NO;
    _detableView.showsHorizontalScrollIndicator = NO;
    
    _detableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self hideTableViewExtraLine];
    [self loadData];
}

//隐藏多余的行
-(void)hideTableViewExtraLine
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    self.detableView.tableFooterView=view;
    
    
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
            
            [self createrCSList];
            
            [_detableView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
}

- (void)createrCSList {
    
    for (int i = 0; i < dataDTArr.count; i++) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:dataDTArr[i]];
        
        NSString *CataName = dict[@"CatalogName"];
        
        NSString *Char = [WKProgressHUD firstCharactor:CataName];
        
        [dict setValue:Char forKey:@"CharName"];
        
        //去重
        BOOL setBool = YES;
        for (int z = 0; z < _letterArr.count; z++) {
            
            NSString *charEve = _letterArr[z][@"char"];
            
            if ([charEve isEqualToString:Char]) {
                
                setBool = NO;
                
                NSMutableArray *cityArray = _letterArr[z][@"cityS"];
                [cityArray addObject:dict];
                
                NSDictionary *charCityEveDict = @{@"char":Char,@"cityS":cityArray};
                _letterArr[z] = charCityEveDict;
                
            }
        }
        
        if (setBool == YES) {
            
            NSMutableArray *cityArray = [NSMutableArray arrayWithCapacity:0];
            [cityArray addObject:dict];
            NSDictionary *charCityEveDict = @{@"char":Char,@"cityS":cityArray};
            [_letterArr addObject:charCityEveDict];
            
        }
        
    }
    
    NSLog(@"%@",_letterArr);
    
    
    //  _________________________________________________________________________________________________HYC_________________________________________________________________________________
    //排序
    for (int q = 0; q < _letterArr.count; q ++) {
        
        for (int w = 0; w < q; w++) {
            
            //比较两个字符串 大 小 相等
            NSString *str15= _letterArr[w][@"char"];
            NSString *str16=_letterArr[w+1][@"char"];
            NSComparisonResult ret2=[str15 compare:str16];
            
            if (ret2==1) {
                
                NSDictionary *ttt = _letterArr[w];
                
                _letterArr[w] = _letterArr[w+1];
                _letterArr[w+1] = ttt;
                q--;
                
                
            }
            
        }
        
    }

    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    
    return _letterArr[section][@"char"];
    
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    
    if (_letterArr) {
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dict in _letterArr) {
            
            [array addObject:dict[@"char"]];
            
        }
        
        return array;
    }
    
    NSArray *rightShouZiMuArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    return rightShouZiMuArr;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _letterArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return ((dataDTArr && dataDTArr.count > 0) ? dataDTArr.count : 0);
    
    NSArray *array = _letterArr[section][@"cityS"];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"cellID";
    
    UITableViewCell * cell = [_detableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    NSArray *array = _letterArr[indexPath.section][@"cityS"];
    
    cell.textLabel.text = array[indexPath.row][@"CatalogName"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSArray *array = _letterArr[indexPath.section][@"cityS"];
    NSDictionary *dictEve = array[indexPath.row];
    
    if ([_type isEqualToString:@"1"]) {
        
        NSMutableDictionary *Mdict = [[NSMutableDictionary alloc] init];
        [Mdict setObject:dictEve[@"CatalogName"]  forKey:@"CatalogName"];
        [Mdict setObject:dictEve[@"CatalogId"] forKey:@"CatalogId"];
        NSDictionary *dict = [NSDictionary dictionaryWithDictionary:Mdict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"XZCHENGSHI" object:nil userInfo:dict];
        [self.navigationController popViewControllerAnimated:YES];
    }else {

        WTDTDetailViewController *wtddVC = [[WTDTDetailViewController alloc] init];
        wtddVC.nameStr = dictEve[@"CatalogName"];
        wtddVC.contentID = dictEve[@"CatalogId"];
        wtddVC.type = 2;
        wtddVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtddVC animated:YES];
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


- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
