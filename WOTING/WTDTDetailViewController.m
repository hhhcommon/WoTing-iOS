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

#import "WTXJHeaderView.h"

@interface WTDTDetailViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
    BoFangTabbarView *firstBarV;
    
    int  count; //旋转角度
    
    NSMutableArray  *dataCellArr;// 数据源数组
    NSString        *BeginCatalogId; //ID
    
    WTXJHeaderView      *XJsectionHView;
    
    BOOL            isDYXZ;     //判断地域选择更多数据里的样式 NO:安徽台样式 YES:北京台无分类样式
}

@property (nonatomic,assign)CGAffineTransform startTransform; //记录最开始contentImg的旋转位置
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation WTDTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _NameLab.text = _nameStr;
    dataCellArr = [NSMutableArray arrayWithCapacity:0];
    isDYXZ = NO;
    
    _jqTabView.delegate = self;
    _jqTabView.dataSource = self;
    
    
    [self loadDataGD];
    [self createrRegisterCell];
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 下拉刷新 */
    _jqTabView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataGD)];
    _jqTabView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoveData)];
    
    NSString *Imgv = [AutomatePlist readPlistForKey:@"ImgV"];
    NSString *transformbegin = [AutomatePlist readPlistForKey:@"transformbegin"];
    NSString *transform = [AutomatePlist readPlistForKey:@"transform"];
    count = [transform intValue];
    
    firstBarV = [[BoFangTabbarView alloc] init];
    
    [firstBarV.HYCContentImageName sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:Imgv]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    //记录一开始的旋转位置
    _startTransform = firstBarV.HYCContentImageName.transform;
    
    firstBarV.HYCKuangImageName.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
    [firstBarV.HYCKuangImageName addGestureRecognizer:tapGesturRecognizer];
    
    if (_timer) {
        
        
    }else{
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runTimeXUAN) userInfo:nil repeats:YES];
    }
    if ([transformbegin isEqualToString:@"0"]) {
        
        [_timer setFireDate:[NSDate distantFuture]];    //暂停
        firstBarV.LJQStopImage.hidden = NO;
    }else{
        
        [_timer setFireDate:[NSDate distantPast]];
        firstBarV.LJQStopImage.hidden = YES;
    }
    
    
    
    
    [self.view addSubview:firstBarV];
    [firstBarV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(K_Screen_Width/4.0);
        make.height.mas_equalTo(49);
    }];
}

- (void)btnClick:(UITapGestureRecognizer *)tap{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
    
    self.tabBarController.selectedIndex = 0;
    
}

- (void)runTimeXUAN{
    
    count+=1;
    
    if (count == 360) {
        
        count = 0;
    }
    firstBarV.HYCContentImageName.transform = CGAffineTransformMakeRotation((M_PI / 180.0f)*count);
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
    
    
    NSDictionary *parameters;
    
    if (_type == 0) {
        //电台详情
       parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",_contentID,@"CatalogId",nil];
    }else if (_type == 1){
        
        //网络台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",@"dtfl2002",@"CatalogId",nil];
        
        
    }else if (_type == 3){
        
        //国家台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"30",@"PageSize",@"dtfl2001",@"CatalogId",nil];
        
        
    }else if (_type == 2){
        //地域选择
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"1",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",@"",@"BeginCatalogId",nil];
        
    }
    
    
    NSString *login_Str = WoTing_GetContents;
    
    NSLog(@"%@", parameters);
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_jqTabView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataCellArr removeAllObjects];
            [dataCellArr addObjectsFromArray:ResultList[@"List"]];
            
            if (_type == 2) {
                
                BeginCatalogId = ResultList[@"BeginCatalogId"];
                if (dataCellArr.count != 0) {
                
                    if ([dataCellArr[0][@"CatalogType"] isEqualToString:@"2"]) {
                        
                        isDYXZ = NO;   //有分类样式
                    }else {
                        isDYXZ = YES;   //无分类样式
                    }
                }else{
                    
                    [self loadDataBeijingDetilWith:nil];    //地方台北京市点击 nil:初始化
                }
            }
            
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

//加载更多
- (void)loadMoveData {
    
    static NSInteger page = 2;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    
    NSDictionary *parameters;
    
    if (_type == 0) {
        //电台详情
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"1",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",_contentID,@"CatalogId",pageStr,@"Page",nil];
    }else if (_type == 1){
        
        //网络台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"10",@"PerSize",@"dtfl2002",@"CatalogId",pageStr,@"Page",nil];
        
        
    }else if (_type == 3){
        
        //国家台
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"9",@"CatalogType",@"3",@"ResultType",@"30",@"PageSize",@"dtfl2001",@"CatalogId",pageStr,@"Page",nil];
        
        
    }else {
        //地域选择
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"1",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",BeginCatalogId,@"BeginCatalogId",pageStr,@"Page",nil];
        
    }
    
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_jqTabView.mj_footer endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            NSArray *dataArr = ResultList[@"List"];
            [dataCellArr addObjectsFromArray:ResultList[@"List"]];
            
            if (_type == 2) {
                
                BeginCatalogId = ResultList[@"BeginCatalogId"];
                
                if (dataArr.count != 0) {
                    
                    if ([dataCellArr[0][@"CatalogType"] isEqualToString:@"2"]) {
                        
                        isDYXZ = NO;   //有分类样式
                    }else {
                        isDYXZ = YES;   //无分类样式
                    }
                }else{
                    
                    [self loadDataBeijingDetilWith:pageStr];    //地方台北京市点击
                }
                
            }
            
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
        
        
        [_jqTabView.mj_footer endRefreshing];
        
    }];
    
    page++;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (_type == 3) {
        
        NSArray *array = dataCellArr[section][@"List"];
        return array.count;
    }else if (_type == 2){
        
        if (isDYXZ == NO) {
            
            NSArray *array = dataCellArr[section][@"List"];
            return array.count;
        }else{
            
            return dataCellArr.count;
        }
        
    }else {
        
        return dataCellArr.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_type == 3) {
        
        return dataCellArr.count;
    }else if (_type == 2){
        
        if (isDYXZ == NO) {
            
            return dataCellArr.count;
        }else{
            
            return 1;
        }
        
    }else {
        
        return 1;
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
    }else if (_type == 2){
        
        if (isDYXZ == NO) {
            
            dict = dataCellArr[indexPath.section][@"List"][indexPath.row];
        }else{
            
            dict = dataCellArr[indexPath.row];
        }
        
    }else {
        
        dict = dataCellArr[indexPath.row];
    }
    
    [cell setCellWithDict:dict];
    cell.BoFangImgV.hidden = YES;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (_type == 3 || _type == 2) {
        
        if (isDYXZ == NO) {
            return 35;
        }else{
            
            return 0;
        }
    }else {
        
        return 0;
    }
    
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
        
    }else if (_type == 2) {
        if (isDYXZ == NO) {
            XJsectionHView = [[WTXJHeaderView alloc] init];
            XJsectionHView.delegate = self;
            XJsectionHView.NameLab.text = dataCellArr[section][@"CatalogName"];
            XJsectionHView.NameStr = dataCellArr[section][@"CatalogName"];
            XJsectionHView.contentId = dataCellArr[section][@"CatalogId"];
            
            return XJsectionHView;
        }else{
            
            return 0;
        }
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
    
    
    if (_type == 3) {
        
        NSDictionary *dict = dataCellArr[indexPath.section][@"List"][indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        
        //回首页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
        
        self.tabBarController.selectedIndex = 0;
    }else if (_type == 2){
        
        if (isDYXZ == NO) {
            
            NSDictionary *dict = dataCellArr[indexPath.section][@"List"][indexPath.row];
            NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
            
            //回首页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
            
            self.tabBarController.selectedIndex = 0;
        }else{
            
            NSDictionary *dict = dataCellArr[indexPath.row];
            NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
            //回首页
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
            
            self.tabBarController.selectedIndex = 0;
        }
        
    }else {
        
        NSDictionary *dict = dataCellArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        
        //回首页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
        
        self.tabBarController.selectedIndex = 0;
    }
}

//北京等不分类城市, 从新请求结果
- (void)loadDataBeijingDetilWith:(NSString *)pageStr{
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters;
    if (!pageStr) {
        
         parameters= [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"3",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",@"1",@"Page",nil];
    }else{
        
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", @"2",@"CatalogType",@"3",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",pageStr,@"Page",nil];
    }
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        [_jqTabView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            
            if (!pageStr) {
               [dataCellArr removeAllObjects];
            }
            
            [dataCellArr addObjectsFromArray:ResultList[@"List"]];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        isDYXZ = YES;
        [_jqTabView reloadData];
        
    } fail:^(NSError *error) {
        
        
        [_jqTabView.mj_header endRefreshing];
        
    }];

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
