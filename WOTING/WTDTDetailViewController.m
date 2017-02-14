//
//  WTDTDetailViewController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDTDetailViewController.h"

#import "WTZhuanJiViewController.h"

#import "WTDianTaiTableViewCell.h"

@interface WTDTDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
    NSMutableArray  *dataCellArr;// 数据源数组
}

@end

@implementation WTDTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _NameLab.text = _nameStr;
    dataCellArr = [NSMutableArray arrayWithCapacity:0];
    
    _jqTabView.delegate = self;
    _jqTabView.dataSource = self;
    
    [self loadDataGD];
    [self createrRegisterCell];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 上拉加载更多 */
    _jqTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataGD)];
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
    
    NSDictionary *parameters;
    
    if (_type == 0) {
        //电台详情
       parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"1",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",_contentID,@"CatalogId",nil];
    }else if (_type == 1){
        
        //网络台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",@"dtfl2002",@"CatalogId",nil];
        
        
    }else if (_type == 3){
        
        //国家台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"30",@"PageSize",@"dtfl2001",@"CatalogId",nil];
        
        
    }else {
        //地域选择
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",_contentID,@"CatalogId",nil];
    }
    
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_jqTabView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
//                        dataCellArr = ResultList[@"List"];
            [dataCellArr addObjectsFromArray:ResultList[@"List"]];
            
            if (_type == 3) {   //国家台
                NSMutableArray *Zarray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *Garray = [NSMutableArray arrayWithCapacity:0];
                NSMutableDictionary *dictZ = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableDictionary *dictG = [NSMutableDictionary dictionaryWithCapacity:0];
                [dictZ setObject:@"中央台" forKey:@"TGP"];
                [dictG setObject:@"国际台" forKey:@"TGP"];
                for (NSDictionary *dict in ResultList[@"List"]) {
                    
                    if ([dict[@"ContentPub"] isEqualToString:@"中央人民广播电台"]) {
                        
                        [Zarray addObject:dict];
                        [dictZ setObject:Zarray forKey:@"List"];
                    }else if ([dict[@"ContentPub"] isEqualToString:@"中国国际广播电台"]) {
                        
                        [Garray addObject:dict];
                        [dictG setObject:Garray forKey:@"List"];
                    }
                }
                
                [dataCellArr removeAllObjects];
                [dataCellArr addObject:dictZ];
                [dataCellArr addObject:dictG];
            }
            
            [_jqTabView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        [_jqTabView.mj_header endRefreshing];
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_type == 3) {
        
        NSArray *array = dataCellArr[section][@"List"];
        return array.count;
    }else {
        
        return dataCellArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_type == 3) {
        
        return dataCellArr.count;
    }else {
        
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTDianTaiTableViewCell *cell = (WTDianTaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTDianTaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict;
    if (_type == 3) {
        
        dict = dataCellArr[indexPath.section][@"List"][indexPath.row];
    }else {
        
        dict = dataCellArr[indexPath.row];
    }
    
    [cell setCellWithDict:dict];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (_type == 3) {
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *labeltitle = [[UILabel alloc] init];
        labeltitle.text = dataCellArr[section][@"TGP"];
        labeltitle.font = [UIFont boldSystemFontOfSize:15];
        labeltitle.textColor = [UIColor skTitleCenterBlackColor];
        [view addSubview:labeltitle];
        
        [labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(20);
        }];
        
        return view;
        
    }else {
        
        return 0;
    }
    
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
    
    if ([dataCellArr[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
        wtZJVC.hidesBottomBarWhenPushed = YES;
        wtZJVC.contentID = [NSString NULLToString:dataCellArr[indexPath.row][@"ContentId"]] ;
        [self.navigationController pushViewController:wtZJVC animated:YES];
        
    }else{
        
        NSDictionary *dict = dataCellArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
    }
}


- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
