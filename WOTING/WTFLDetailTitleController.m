//
//  WTFLDetailTitleController.m
//  WOTING
//
//  Created by jq on 2017/3/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTFLDetailTitleController.h"

#import "WTFLDetailTabViewController.h"

#import "WTZhuanJiViewController.h"

#import "WTBoFangTableViewCell.h"
#import "WTLikeCell.h"

@interface WTFLDetailTitleController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataFLTArr;    //title个数数组
    NSMutableArray  *dataController;    //控制器个数
    
    NSMutableArray  *dataFlConArr;  //单个页面的情况下,数据信息
    
    BoFangTabbarView *firstBarV;
    
    int  count; //旋转角度
    
    UITableView     *FLTableView;   //判断单个节目
}


@property (nonatomic,assign)CGAffineTransform startTransform; //记录最开始contentImg的旋转位置
@property (nonatomic,strong)NSTimer *timer;

@end

@implementation WTFLDetailTitleController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    _contentName.text = _nameL;
    dataFLTArr = [NSMutableArray arrayWithCapacity:0];
    dataController = [NSMutableArray arrayWithCapacity:0];
    dataFlConArr = [NSMutableArray arrayWithCapacity:0];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 64, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 64 + 44, screenSize.width, screenSize.height - 64 - 44)];
    
    self.tabBar.itemTitleColor = [UIColor lightGrayColor];
    self.tabBar.itemTitleSelectedColor = [UIColor JQTColor];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:17];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:18];
    self.tabBar.leftAndRightSpacing = 20;
    
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.itemSelectedBgScrollFollowContent = YES;
    self.tabBar.itemSelectedBgColor = [UIColor JQTColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 15, 0, 15) tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:40];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    self.loadViewOfChildContollerWhileAppear = YES;
    
    
    [self loadbarTitle];    //获取title个数
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
   
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

- (void)loadbarTitle {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",@"1",@"ResultType",_contentID,@"CatalogId", @"0",@"RelLevel",nil];
    
    NSString *login_Str = WoTing_getCatalogInfo;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"CatalogData"];
            
            if (ResultList[@"SubCata"]) {
                
                [dataFLTArr removeAllObjects];
                [dataFLTArr addObjectsFromArray: ResultList[@"SubCata"]];
      
                
                [self initViewControllers];
            }else{
                
                
                [self createTableView]; //显示单条页面的信息
                
            }
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
}

- (void)initViewControllers{
    
    for (int i = 0; i < dataFLTArr.count+1; i++) {
        
        if (i == 0) {
            
            WTFLDetailTabViewController *wtFLTabVC = [[WTFLDetailTabViewController alloc] init];
           
            wtFLTabVC.yp_tabItemTitle = @"推荐";
            [dataController addObject:wtFLTabVC];
            
        }else{
            //[1]	(null)	@"CatalogType" : @"-1"
            WTFLDetailTabViewController *wtFLTabVC = [[WTFLDetailTabViewController alloc] init];
            wtFLTabVC.contentID = dataFLTArr[i - 1][@"CatalogId"];
            wtFLTabVC.MediaType = dataFLTArr[i - 1][@"CatalogType"];
            wtFLTabVC.yp_tabItemTitle = dataFLTArr[i - 1][@"CatalogName"];
            [dataController addObject:wtFLTabVC];
            
        }
    }
    
    self.viewControllers = dataController;
}


- (void)createTableView{
    
    FLTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64)];
    [self.view addSubview:FLTableView];
    
    FLTableView.delegate = self;
    FLTableView.dataSource = self;
    
    /** 增加下拉刷新事件 */
    FLTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataFLController)];
    /** 增加上拉加载更多 */
    FLTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MoveData)];

    [self registerFLTabVCell];
    [self loadDataFLController];
}

- (void)registerFLTabVCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [FLTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [FLTableView registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
}

//网络请求
- (void)loadDataFLController{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", @"3",@"CatalogType",@"10",@"PageSize",@"2",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [FLTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataFlConArr removeAllObjects];
            [dataFlConArr addObjectsFromArray: ResultList[@"List"]];
            
            [FLTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [FLTableView.mj_header endRefreshing];
        
        
    }];
    
    
}

- (void)MoveData{
    
    static NSInteger page = 2;
    NSString *pageStr = [NSString stringWithFormat:@"%ld",page];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", @"3",@"CatalogType",@"10",@"PageSize",@"2",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId",pageStr,@"Page", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [FLTableView.mj_footer endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataFlConArr addObjectsFromArray: ResultList[@"List"]];
            
            [FLTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [FLTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSError *error) {
        
        [FLTableView.mj_footer endRefreshing];
        
        
    }];
    
    page++;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataFlConArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([dataFlConArr[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        static NSString *cellID = @"cellIDL";
        
        WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        NSDictionary *dict = dataFlConArr[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
    }else {
        
        static NSString *cellID = @"cellID";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.WTBoFangImgV.hidden = YES;
        NSDictionary *dict = dataFlConArr[indexPath.row];
        [cell setCellWithDict:dict];
        
        
        return cell;
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
    
    if ([dataFlConArr[indexPath.row][@"MediaType"] isEqualToString:@"SEQU"]) {
        
        WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
        wtZJVC.hidesBottomBarWhenPushed = YES;
        wtZJVC.contentID = [NSString NULLToString:dataFlConArr[indexPath.row][@"ContentId"]] ;
        [self.navigationController pushViewController:wtZJVC animated:YES];
        
    }else{
        
        NSDictionary *dict = dataFlConArr[indexPath.row];
        NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        
        //回首页
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
        
        self.tabBarController.selectedIndex = 0;
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
