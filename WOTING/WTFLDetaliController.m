//
//  WTFLDetaliController.m
//  WOTING
//
//  Created by jq on 2016/12/14.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTFLDetaliController.h"
#import "MainViewController.h"
#import "WTZhuanJiViewController.h"

#import "WTBoFangTableViewCell.h"
#import "WTLikeCell.h"

#import "ChildViewController.h"

#import "FullChildViewController.h"


@interface WTFLDetaliController (){
    
    /** 数据数组 */
    NSMutableArray          *dataFLDJArray;
    NSMutableArray          *dataFLTArr;    //得到分类详情列表名

    NSArray                 *imageNameArray;
    
    
    BoFangTabbarView *firstBarV;
    
    int  count; //旋转角度
}

@property (nonatomic,assign)CGAffineTransform startTransform; //记录最开始contentImg的旋转位置
@property (nonatomic,strong)NSTimer *timer;


@end

@implementation WTFLDetaliController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;

    
    _nameLab.text = _nameL;
    dataFLDJArray = [NSMutableArray arrayWithCapacity:0];
    dataFLTArr = [NSMutableArray arrayWithCapacity:0];
    
    [self loadBarTitle];        //获取到分类详情文字

    
    [self registerTabViewCell];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    /** 增加下拉刷新事件 */
    _FLDTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    /** 增加上拉加载更多 */
    _FLDTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(MoveData)];
    
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

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_FLDTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [_FLDTableView registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
}

- (void)loadData {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", @"3",@"CatalogType",@"10",@"PageSize",@"2",@"ResultType",@"3",@"PerSize",_contentID,@"CatalogId", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        [_FLDTableView.mj_header endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataFLDJArray removeAllObjects];
            [dataFLDJArray addObjectsFromArray: ResultList[@"List"]];
            
            [_FLDTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [_FLDTableView.mj_header endRefreshing];

        
    }];
    
}

- (void)MoveData {
    
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
        
        [_FLDTableView.mj_footer endRefreshing];
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataFLDJArray addObjectsFromArray: ResultList[@"List"]];
            
            [_FLDTableView reloadData];
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [_FLDTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } fail:^(NSError *error) {
        
        [_FLDTableView.mj_footer endRefreshing];
        
        
    }];
    
    page++;
    
}


// 添加所有子控制器
- (void)setUpAllViewController
{
    
    for (int i = 0; i < dataFLTArr.count+1 ; i++) {
        
        if (i == 0) {
            
            FullChildViewController *wordVc1 = [[FullChildViewController alloc] init];
            wordVc1.title = @"推荐";
            [self addChildViewController:wordVc1];
        }else{
            
            FullChildViewController *wordVc1 = [[FullChildViewController alloc] init];
            wordVc1.title = dataFLTArr[i-1][@"CatalogName"];
            [self addChildViewController:wordVc1];
        }
    }
    

}

#pragma mark - 获取bar上的文字分类
- (void)loadBarTitle{
    
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
                
                // 添加所有子控制器
            //    [self setUpAllViewController];
                
            }else {
                
                
                [self loadData];    //不带bar文字的
                
            }
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)balckBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
