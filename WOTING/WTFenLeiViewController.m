//
//  WTFenLeiViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTFenLeiViewController.h"

#import "WTFenLeiTableViewCell.h"

/** 轮播图片 */
#import "SDCycleScrollView.h"

@interface WTFenLeiViewController ()<SDCycleScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    UITableView        *jqTableView;
    
    /** 数据数组 */
    NSMutableArray          *dataFenJArray;
    
    /** 轮播图 */
    SDCycleScrollView        *scrollView;
    NSArray           *imageNameArray;
}

@end

@implementation WTFenLeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataFenJArray = [NSMutableArray arrayWithCapacity:0];
    imageNameArray = [[NSArray alloc] initWithObjects:@"WTceshi1.jpg",@"WTceshi2.jpg",@"WTceshi3.jpg",@"WTceshi4.jpg", nil];
    
    jqTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height) style:UITableViewStyleGrouped];
    jqTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    jqTableView.delegate = self;
    jqTableView.dataSource = self;
    [self.view addSubview:jqTableView];
    __weak WTFenLeiViewController *Weakself = self;
    [jqTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(Weakself.view);
    }];
    jqTableView.tableFooterView = [[UIView alloc] init];
    
    scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, POINT_Y(320)) delegate:self placeholderImage:[UIImage imageNamed:@"liangYan.png"]];
    scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    jqTableView.tableHeaderView = scrollView;
    
    scrollView.imageURLStringsGroup = imageNameArray;//图片
    /** 设置轮播pageControl位置 */
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    scrollView.currentPageDotColor = [UIColor JQTColor];
    
    [self loadDataFenLei];
}

//网络请求
- (void)loadDataFenLei {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    //"RelLevel":"2"
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",nil];
    
    NSString *login_Str = WoTing_CatalogInfo;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"PrefTree"];
            dataFenJArray = ResultList[@"children"];
            
            [jqTableView reloadData];

            
        }
//        else if ([ReturnType isEqualToString:@"T"]){
//            
//            [E_HUDView showMsg:@"服务器异常" inView:nil];
//        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataFenJArray.count;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//    WTFenLeiTableViewCell *jqCell = (WTFenLeiTableViewCell *)cell;
//    
//    
//}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTFenLeiTableViewCell *cell = (WTFenLeiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell = [[WTFenLeiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    
    cell.nameLab.text = dataFenJArray[indexPath.row][@"name"];
    cell.titles = dataFenJArray[indexPath.row][@"children"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *titles = dataFenJArray[indexPath.row][@"children"];
    if (titles.count <= 4) {
        
        return POINT_Y(200);
    }else{
        
        return POINT_Y(250);
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

@end
