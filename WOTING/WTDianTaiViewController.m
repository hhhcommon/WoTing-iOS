//
//  WTDianTaiViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDianTaiViewController.h"

#import "WTDianTaiTableViewCell.h"

@interface WTDianTaiViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    UITableView        *jqTableView;
    
    /** 数据数组 */
    NSMutableArray          *dataDianTArray;
    
}

@end

@implementation WTDianTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataDianTArray = [NSMutableArray arrayWithCapacity:0];
    
    jqTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height) style:UITableViewStyleGrouped];
    jqTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    jqTableView.delegate = self;
    jqTableView.dataSource = self;
    [self.view addSubview:jqTableView];
    __weak WTDianTaiViewController *Weakself = self;
    [jqTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(Weakself.view);
    }];
    jqTableView.tableFooterView = [[UIView alloc] init];
    
    [self initHeaderView];
    [self registerTabViewCell];
    [self loadData];
}

//创建头视图
- (void)initHeaderView{

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(260))];
    headerView.backgroundColor = [UIColor whiteColor];
    jqTableView.tableHeaderView = headerView;
   
    UIButton *DFTaiBtn = [[UIButton alloc] init];
//    DFTaiBtn
    
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTDianTaiTableViewCell" bundle:nil];
    
    [jqTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

//数据请求
- (void)loadData {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    //"MediaType":"",//全部
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", @"RADIO",@"MediaType", nil];
    
    NSString *login_Str = WoTing_GetContents;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"ResultList"];
            dataDianTArray = ResultList[@"List"];
            
            [jqTableView reloadData];
            NSLog(@"%@", dataDianTArray);
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [E_HUDView showMsg:@"服务器异常" inView:nil];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataDianTArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTDianTaiTableViewCell *cell = (WTDianTaiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTDianTaiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = dataDianTArray[indexPath.row];
    [cell setCellWithDict:dict];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
//    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    
//    UILabel *labeltitle = [[UILabel alloc] init];
//    labeltitle.text = @"猜你喜欢";
//    labeltitle.font = [UIFont boldSystemFontOfSize:15];
//    labeltitle.textColor = [UIColor skTitleCenterBlackColor];
//    [view addSubview:labeltitle];
//    
//    [labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(20);
//        make.top.mas_equalTo(10);
//        make.width.mas_equalTo(120);
//        make.height.mas_equalTo(20);
//    }];
//    
//    return view;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

@end
