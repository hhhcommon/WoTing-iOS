//
//  WTSearchViewController.m
//  WOTING
//
//  Created by jq on 2016/12/15.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTSearchViewController.h"

#import "AllViewController.h"
#import "ZhuanJiViewController.h"
#import "ShengYinViewController.h"
#import "DianTaiViewController.h"
#import "TTSViewController.h"

#import "SKMainScrollView.h"

@interface WTSearchViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSArray     *dataSearchArr;
    NSString    *searchStr;
    UIView      *view; //热门搜索背景
    BOOL        isSearch; //是搜索, 还是热门
    
    UITableView *searchTab; //搜索推荐
    
    SKMainScrollView    *contentScrollView;
    UIView              *titleView;//标识栏
    UIImageView         *barLineImageView;//标识条
}

@end

@implementation WTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataSearchArr = [[NSArray alloc] init];
    
    [_searchTField addTarget:self action:@selector(SearchChanged:) forControlEvents:UIControlEventEditingChanged];
    _searchTField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTField.returnKeyType = UIReturnKeySearch;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scollerViewChange:) name:@"LIKELISTCHANGE" object:nil];
    
    if (_searchByText != nil) {
        
        _searchTField.text = _searchByText;
        [self loadDataSearch:_searchByText];
        [self initScrollerView];
        [self initTiteBarView];
        
    }else{
        
        [self loadDataSearch:nil];
    }
    
}

//网络请求,热门搜索
- (void)loadDataSearch:(NSString *)str {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters;
    NSString *login_Str;
    
    if (!str) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",@"1",@"FunType",@"12",@"WordSize",@"2",@"ReturnType",nil];
        
        login_Str = WoTing_HotKeys;
        
    }else {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",@"1",@"FunType",@"10",@"WordSize",@"2",@"ReturnType",_searchTField.text,@"KeyWord",nil];
        
        login_Str = WoTing_searchHotKeys;
        
    }
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSString *ResultList = resultDict[@"SysKeyList"];
            
            dataSearchArr = [ResultList componentsSeparatedByString:@","];
            
            if (isSearch || _searchByText != nil) {
                //加载搜索
                [self createSearch];
                
            }else{
                
                [self createrWithHotkey:dataSearchArr];
            }
        }
        
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
}


//得到热门搜索
- (void)createrWithHotkey:(NSArray *)array {
    //背景
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UILabel *labHot = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 100, 20)];
    if (array) {
        
        labHot.font = [UIFont systemFontOfSize:15];
        labHot.text = @"热门搜索";
        [view addSubview:labHot];
    }

    NSInteger XX = 10;
    NSInteger YY = 10;
    NSInteger width = K_Screen_Width/4 - 10;
    NSInteger height = 30;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *title = [array objectAtIndex:i];
        
        if (!(i%4)) {
            
            YY += 40;
            XX = 10;
            
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(XX, YY, width - 3, height)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"search_kuang.png"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [view addSubview:btn];
        
        XX += width +10;
        
    }
    
}
//热门搜索点击事件
- (void)btnClick:(UIButton *)btn {
    
    _searchTField.text = btn.titleLabel.text;
    [self SearchChanged:_searchTField];
}

//监测搜索内容
- (void)SearchChanged:(UITextField *)textF {
    
    searchStr = textF.text;
    
    if (![searchStr isEqualToString:@""]) {
        //清空页面
        [view removeFromSuperview];
        isSearch = YES; //有搜索内容
        [self loadDataSearch:searchStr];
    }else {
        [view removeFromSuperview];
        isSearch = NO;  //没有搜索内容
        [self loadDataSearch:nil];  //显示热门搜索
    }
    
}

//加载搜索
- (void)createSearch {
    //背景
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    searchTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height - 64) style:UITableViewStylePlain];
    searchTab.dataSource = self;
    searchTab.delegate = self;
    [view addSubview:searchTab];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSearchArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell.textLabel.text = [dataSearchArr objectAtIndex:indexPath.row];
 
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _searchTField.text = dataSearchArr[indexPath.row];
    [self initScrollerView];
    [self initTiteBarView];
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

//点击搜索
- (IBAction)searchBtnClick:(id)sender {
    
    if (_searchTField.text != nil) {
        
        FMDatabase *db = [FMDBTool createDatabaseAndTable:@"SEARCH"];
        
//        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM BFLS"];
//        // 2.遍历结果
//        while ([resultSet next]) {
//            
//            NSString *ID = [resultSet stringForColumn:@"SEARCH"];
//            
//            if ([_searchTField.text isEqualToString:ID]) {
//                
//                _SQLITE = YES;
//            }
//        }
//        
//        if (_SQLITE == YES) {
//            
//            NSString *deleteSql = [NSString stringWithFormat:@"delete from BFLS where MusicStr=%@",dict[@"ContentId"]];
//            //    NSString *deleteSql = @"delete from BFLS where MusicDict";
//            BOOL isOk = [db executeUpdate:deleteSql];
//            if (isOk) {
//                NSLog(@"删除数据成功! 😄");
//            }else{
//                NSLog(@"删除数据失败! 💔");
//            }
//        }
        NSString *sqlInsert = @"insert into BFLS values(?)";
        [db executeUpdate:sqlInsert, _searchTField];

    }
    
    [self initScrollerView];
    [self initTiteBarView];
}

- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0,  POINT_Y(90), K_Screen_Width, K_Screen_Height - POINT_Y(90) - 64)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 5, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 5; i ++) {
        
        if (i == 0) {
            
            AllViewController *wtallVC = [[AllViewController alloc] init];
            wtallVC.SearchStr = _searchTField.text;
            [self addChildViewController:wtallVC];
            [contentScrollView addSubview:wtallVC.view];
            [wtallVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 1) {
            
            ZhuanJiViewController *wtzhuanjiVC = [[ZhuanJiViewController alloc] init];
            wtzhuanjiVC.SearchStr = _searchTField.text;
            [self addChildViewController:wtzhuanjiVC];
            [contentScrollView addSubview:wtzhuanjiVC.view];
            [wtzhuanjiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 2){
            
            ShengYinViewController *wtSYVC = [[ShengYinViewController alloc] init];
            wtSYVC.SearchStr = _searchTField.text;
            [self addChildViewController:wtSYVC];
            [contentScrollView addSubview:wtSYVC.view];
            [wtSYVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 3) {
            
            DianTaiViewController *wtDTVC = [[DianTaiViewController alloc] init];
            wtDTVC.SearchStr = _searchTField.text;
            [self addChildViewController:wtDTVC];
            [contentScrollView addSubview:wtDTVC.view];
            [wtDTVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else{
            
            TTSViewController *wtttsVC = [[TTSViewController alloc] init];
            wtttsVC.SearchStr = _searchTField.text;
            [self addChildViewController:wtttsVC];
            [contentScrollView addSubview:wtttsVC.view];
            [wtttsVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }
    }
    
    
}

- (void)initTiteBarView{
    
    titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(90))];
    titleView.backgroundColor = [UIColor whiteColor];
    [view addSubview:titleView];
    
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.tag = 1221;
    [leftBtn setTitle:@"全部" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [titleView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(titleView);
        make.top.equalTo(titleView);
    }];
    leftBtn.selected = YES;
    
    UIButton *leftBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn1.tag = 1222;
    [leftBtn1 setTitle:@"专辑" forState:UIControlStateNormal];
    [leftBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    leftBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [titleView addSubview:leftBtn1];
    [leftBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(leftBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.tag = 1223;
    [centerBtn setTitle:@"声音" forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [centerBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    centerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [titleView addSubview:centerBtn];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(leftBtn1.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.tag = 1224;
    [rightBtn setTitle:@"电台" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [titleView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(centerBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    UIButton *rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.tag = 1225;
    [rightBtn1 setTitle:@"TTS" forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBtn1 setTitleColor:[UIColor JQTColor] forState:UIControlStateSelected];
    rightBtn1.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    [titleView addSubview:rightBtn1];
    [rightBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(90));
        make.left.equalTo(rightBtn.mas_right);
        make.top.equalTo(titleView);
    }];
    
    
    barLineImageView = [[UIImageView alloc] init];
    barLineImageView.backgroundColor = [UIColor JQTColor];
    barLineImageView.layer.cornerRadius = 2.0;
    [titleView addSubview:barLineImageView];
    [barLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(leftBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    [leftBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn1 addTarget:self action:@selector(barButtonSelect:) forControlEvents:UIControlEventTouchUpInside];
}

/** 菜单栏按钮被点击 */
- (void)barButtonSelect:(UIButton *)aBtn {
    
    /** 首先切换标识条 */
    [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
        make.height.mas_equalTo(POINT_Y(6));
        make.centerX.equalTo(aBtn);
        make.bottom.equalTo(titleView.mas_bottom);
    }];
    
    aBtn.selected = YES;
    
    UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
    UIButton *leftBtn1 = (UIButton *)[titleView viewWithTag:1222];
    UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1223];
    UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1225];
    UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1224];
    if (aBtn.tag == 1221) {
        
        centerBtn.selected = NO;
        rightBtn.selected = NO;
        leftBtn1.selected = NO;
        rightBtn1.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
        
    }else if (aBtn.tag == 1222) {
        
        leftBtn.selected = NO;
        rightBtn.selected = NO;
        centerBtn.selected = NO;
        rightBtn1.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
        
    }else if (aBtn.tag == 1223) {
        
        leftBtn.selected = NO;
        rightBtn.selected = NO;
        leftBtn1.selected = NO;
        rightBtn1.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
    }else if (aBtn.tag == 1224) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        rightBtn1.selected = NO;
        centerBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
    }else if (aBtn.tag == 1225) {
        
        leftBtn.selected = NO;
        leftBtn1.selected = NO;
        rightBtn.selected = NO;
        centerBtn.selected = NO;
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 4, 0);
    }
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        /** 首先切换标识条 */
        [barLineImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(titleView.mas_width).with.multipliedBy(1.0/5);
            make.height.mas_equalTo(POINT_Y(6));
            make.left.mas_equalTo((scrollView.contentOffset.x/5));
            make.bottom.equalTo(titleView.mas_bottom);
        }];
        
        UIButton *leftBtn = (UIButton *)[titleView viewWithTag:1221];
        UIButton *leftBtn1 = (UIButton *)[titleView viewWithTag:1222];
        UIButton *centerBtn = (UIButton *)[titleView viewWithTag:1223];
        UIButton *rightBtn = (UIButton *)[titleView viewWithTag:1224];
        UIButton *rightBtn1 = (UIButton *)[titleView viewWithTag:1225];
        
        if (scrollView.contentOffset.x == K_Screen_Width) {
            
            leftBtn.selected = NO;
            leftBtn1.selected = YES;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            
        }else if (scrollView.contentOffset.x == 0){
            
            leftBtn.selected = YES;
            leftBtn1.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
            rightBtn1.selected = NO;
            
        }else if (scrollView.contentOffset.x == K_Screen_Width*2){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn1.selected = NO;
            centerBtn.selected = YES;
            rightBtn.selected = NO;
        }else if (scrollView.contentOffset.x == K_Screen_Width*3){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn1.selected = NO;
            centerBtn.selected = NO;
            rightBtn.selected = YES;
            
        }else if (scrollView.contentOffset.x == K_Screen_Width*4){
            
            leftBtn.selected = NO;
            leftBtn1.selected = NO;
            rightBtn1.selected = YES;
            centerBtn.selected = NO;
            rightBtn.selected = NO;
        }
    }
}

- (void)scollerViewChange:(NSNotification *)not {
    
    NSString *str = not.userInfo[@"Str"];
    
    if ([str isEqualToString:@"声音"]) {
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 2, 0);
    }else if ([str isEqualToString:@"专辑"]) {
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
    }else if ([str isEqualToString:@"电台"]){
        
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 3, 0);
    }
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
