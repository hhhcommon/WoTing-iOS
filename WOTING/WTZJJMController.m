//
//  WTZJJMController.m
//  WOTING
//
//  Created by jq on 2016/12/20.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZJJMController.h"

#import "WTZhuanJiCell.h"
#import "WTZhuanJiDownloadCell.h"

#import "JSDownLoadManager.h"   //下载器

@interface WTZJJMController ()<UITableViewDelegate, UITableViewDataSource>{
    
    BOOL isHeaderViewSelected;  //排序按钮点击状态
    
    BOOL typeDownLoad;  //判断是否是下载状态
    
    BOOL isQXuan;      //判断是否全选
    BOOL isXuanZ;      //选择了要下载节目
    NSMutableArray  *dataZJJMCellArr;   //cell的选中个数
    
    UIView          *footView;      //下载的view
    UIButton        *XuanBtn;       //全选按钮
    
    BOOL isDownLoadOK;  //判断是否下载成功
    NSInteger       PageZJ;     //第几页
}

@property (nonatomic, strong) JSDownLoadManager *manager;//下载器

@end

@implementation WTZJJMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataZJJMCellArr = [NSMutableArray arrayWithCapacity:0];
    PageZJ = 2;
    
    _ZJJieMTabV.delegate = self;
    _ZJJieMTabV.dataSource = self;
    _ZJJieMTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _ZJJieMTabV.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadDataZJMove)];
    
    isHeaderViewSelected = NO;
    [self registerTableViewCell];
    
    footView = [[UIView alloc] init];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    [footView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(49);
    }];
    
    [self createDownLoadView];
}

- (void)loadDataZJMove{
    
    NSString *pageStr = [NSString stringWithFormat:@"%ld",PageZJ];
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId", @"SEQU",@"MediaType",_contentId,@"ContentId",pageStr,@"Page",nil];
    
    NSString *login_Str = WoTing_GetContentInfo;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [_dataZJArr addObjectsFromArray:resultDict[@"ResultInfo"][@"SubList"]];
            [_ZJJieMTabV reloadData];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [WKProgressHUD popMessage:@"没有查到任何专辑" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    PageZJ++;
}

- (void)createDownLoadView {
    
    UIImageView *barImageV = [[UIImageView alloc] init];
    barImageV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [footView addSubview:barImageV];
    [barImageV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    UIButton *benginBtn = [[UIButton alloc] init];
    benginBtn.backgroundColor = [UIColor JQTColor];
    benginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    benginBtn.layer.cornerRadius = 3;
    benginBtn.layer.masksToBounds = YES;
    [benginBtn setTitle:@"开始下载" forState:UIControlStateNormal];
    [benginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [benginBtn addTarget:self action:@selector(BeginDownLoad) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:benginBtn];
    [benginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(8);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(30);
    }];
    
    XuanBtn = [[UIButton alloc] init];
    [XuanBtn setImage:[UIImage imageNamed:@"WeiXuanZhong.png"] forState:UIControlStateNormal];
    [XuanBtn setImage:[UIImage imageNamed:@"XuanZhong.png"] forState:UIControlStateSelected];
    [XuanBtn addTarget:self action:@selector(QXuanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:XuanBtn];
    [XuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(2);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
    }];
    
    UIButton *QXBtn = [[UIButton alloc] init];
    [QXBtn setTitle:@"全 选" forState:UIControlStateNormal];
    QXBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [QXBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [QXBtn addTarget:self action:@selector(QXuanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:QXBtn];
    [QXBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(XuanBtn.mas_right).with.offset(5);
        make.top.mas_equalTo(14);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(21);
    }];
}

//全选
- (void)QXuanBtnClick:(UIButton *)btn{
    
    if (btn.selected) {
        XuanBtn.selected = NO;
        btn.selected = NO;
        isQXuan = NO;
        [dataZJJMCellArr removeAllObjects];
        [_ZJJieMTabV reloadData];
    }else{
        XuanBtn.selected = YES;
        btn.selected = YES;
        isQXuan = YES;
        [dataZJJMCellArr removeAllObjects];     //先全部删除
        [dataZJJMCellArr addObjectsFromArray:_dataZJArr];   //在全部存入
        [_ZJJieMTabV reloadData];
    }
}

- (void)registerTableViewCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTZhuanJiCell" bundle:nil];
    
    [_ZJJieMTabV registerNib:cellNib forCellReuseIdentifier:@"cellIDL"];
    
    UINib *cellNibDown = [UINib nibWithNibName:@"WTZhuanJiDownloadCell" bundle:nil];
    
    [_ZJJieMTabV registerNib:cellNibDown forCellReuseIdentifier:@"cellDown"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataZJArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (typeDownLoad) {
        
        footView.hidden = NO;
        
        static NSString *cellID = @"cellDown";
        
        WTZhuanJiDownloadCell *cell = (WTZhuanJiDownloadCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTZhuanJiDownloadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        //传值
        objc_setAssociatedObject(cell.XuanZeBtn, @"ZJDict", _dataZJArr[indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);//实际上就是KVC
        
        [cell.XuanZeBtn addTarget:self action:@selector(XuanZhongDownLoadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSDictionary *dict = _dataZJArr[indexPath.row];
        
        if (isQXuan) {
            
            cell.XuanZeBtn.selected = YES;
        }else {
            
            cell.XuanZeBtn.selected = NO;
            for (NSDictionary *Tdict in dataZJJMCellArr) {
                
                if ([Tdict[@"ContentName"] isEqualToString:dict[@"ContentName"]]) {
                    
                    cell.XuanZeBtn.selected = YES;
                }
            }
        }
        
        [cell setCellWithDict:dict];
        
        
        return cell;
        
    }else {
        
        footView.hidden = YES;
        
        static NSString *cellID = @"cellIDL";
        
        WTZhuanJiCell *cell = (WTZhuanJiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTZhuanJiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        
        NSDictionary *dict = _dataZJArr[indexPath.row];
        
        [cell setCellWithDict:dict];
        
        
        return cell;
    }
}

#pragma mark - 按钮选中
- (void)XuanZhongDownLoadBtnClick:(UIButton *)btn{
    
    NSDictionary *ZJDict = objc_getAssociatedObject(btn, @"ZJDict");
    
    if (isQXuan) {
        
        if (btn.selected) {
            
            btn.selected = NO;
            isQXuan = NO;
        }
    }else{
        
        if (btn.selected) {
            
            btn.selected = NO;
            [dataZJJMCellArr removeObject:ZJDict];
            [_ZJJieMTabV reloadData];
        }else{
        
            [dataZJJMCellArr addObject:ZJDict];
            
            btn.selected = YES;
            [_ZJJieMTabV reloadData];
        }
    }
 
}

//点击开始下载
- (void)BeginDownLoad{
    
//    NSMutableArray *JQMarr = [NSMutableArray arrayWithCapacity:0];
//    
//    for (NSString *JQStr in dataZJJMCellArr) {
//        
//        NSDictionary *JQDict = _dataZJArr[[JQStr integerValue]];
//        
//        [JQMarr addObject:JQDict];
//    }
//    
//    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithCapacity:0];
//    [mdict setObject:JQMarr forKey:@"DownLoad"];
//    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:mdict];
//    //传数据
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIDICT" object:nil userInfo:dict];
    
    NSLog(@"%lu", dataZJJMCellArr.count);
    
    NSMutableArray *ljqArr;
    
    
        
    for (NSDictionary *dict in ljqArr) {
            
//        if (isDownLoadOK) {
        
            FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
            
            BOOL isRept = NO;
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
            // 遍历结果，如果重复就删除数据
            while ([resultSet next]) {
                
                NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
                if ([dict[@"ContentId"] isEqualToString:jsonDict[@"ContentId"]]){
                    
                    isRept = YES;
                }
            }
            if (!isRept) {
                
                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
                NSString *sqlInsert = @"insert into XIAZAI values(?,?,?)";
                BOOL isOk = [db executeUpdate:sqlInsert, dict[@"ContentId"],data ,@"0"];
                if (isOk) {
                    NSLog(@"添加数据成功");
                    //通知下载中
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWEIWANCHENG" object:nil];
                    
                    [self GCDdownLoad:dict[@"ContentPlay"] andDownLoad:dict]; //开始下载
                }
                
            }
            
//        }
    }

}

//懒加载下载器
- (JSDownLoadManager *)manager{
    
    if (!_manager) {
        _manager = [[JSDownLoadManager alloc] init];
    }
    return _manager;
}

//异步下载
- (void)GCDdownLoad:(NSString *)url andDownLoad:(NSDictionary *)dict{
    
    //开启异步下载线程
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.manager downloadWithURL:url
                             progress:^(NSProgress *downloadProgress) {
                                 
                                 //                                 dispatch_async(dispatch_get_main_queue(), ^{
                                 //
                                 //                                     circleView.progress = downloadProgress.fractionCompleted;
                                 //
                                 //                                     _JinDuLab.text =[NSString stringWithFormat:@"%0.2fMB/%0.2fMB", downloadProgress.completedUnitCount/1024.0/1024, downloadProgress.totalUnitCount/1024.0/1024];
                                 //
                                 //                                 });
                                 
                             }
                                 path:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                     
                                     NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                     NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
                                     return [NSURL fileURLWithPath:path];
                                 }
                           completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                               //此时已在主线程
                               
                               NSString *path = [filePath path];
                               NSLog(@"************文件路径:%@",path);
                               
                               FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
                               
                               BOOL isRept = NO;
                               FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
                               // 遍历结果，如果重复就删除数据
                               while ([resultSet next]) {
                                   
                                   NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
                                   NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
                                   if ([dict[@"ContentPlay"] isEqualToString:jsonDict[@"ContentPlay"]] && [[resultSet stringForColumn:@"XIAZAIBOOL"] isEqualToString:@"0"]){
                                       
                                       isRept = YES;
                                   }
                               }
                               if (isRept) {
                                   
                                   //       NSData *data = [NSJSONSerialization dataWithJSONObject:dataBFArray[_musicIndex] options:NSJSONWritingPrettyPrinted error:nil];
                                   BOOL isOk = [db executeUpdate:@"UPDATE XIAZAI SET XIAZAIBOOL = ? WHERE XIAZAINum =?",@"1",dict[@"ContentId"]];
                                   if (isOk) {
                                       NSLog(@"更改数据成功! 😄");
                                       
                                       [db close];  //关闭数据库
                                       
//                                       isDownLoadOK = YES;
                                       
                                       //通知下载完成
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWANCHENG" object:nil];
                                       //通知下载中刷新UI
                                       [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWEIWANCHENG" object:nil];
                                   }else{
                                       NSLog(@"更改数据失败! 💔");
                                   }
                                   
                               }
                               
                               
                           }];
    });

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (typeDownLoad) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        
        UIButton *QuXiaoBtn = [[UIButton alloc] init];
      //  QuXiaoBtn.backgroundColor = [UIColor whiteColor];
        [QuXiaoBtn setTitle:@"取 消" forState:UIControlStateNormal];
        [QuXiaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        QuXiaoBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [QuXiaoBtn addTarget:self action:@selector(QuXiaoBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:QuXiaoBtn];
        [QuXiaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(80);
        }];
        
        UILabel *JMNnm = [[UILabel alloc] init];
        JMNnm.text = [NSString stringWithFormat:@"共选择了%ld个节目", dataZJJMCellArr.count];
        JMNnm.font = [UIFont boldSystemFontOfSize:14];
        [view addSubview:JMNnm];
        [JMNnm mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(10);
            make.top.mas_equalTo(12);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(20);
        }];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [view addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-1);
            make.height.mas_equalTo(1);
        }];
        
        return view;
    }else{
    
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *labeltitle = [[UILabel alloc] init];
        labeltitle.text = [NSString stringWithFormat:@"共%lu集", _dataZJArr.count];
        labeltitle.font = [UIFont boldSystemFontOfSize:15];
        labeltitle.textColor = [UIColor skTitleCenterBlackColor];
        [view addSubview:labeltitle];
        
        [labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(24);
        }];
        
        UIButton *DownLoadBtn = [[UIButton alloc] init];
        [DownLoadBtn addTarget:self action:@selector(DownLoadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [DownLoadBtn setImage:[UIImage imageNamed:@"ZJ_DownLoad.png"] forState:UIControlStateNormal];
        [view addSubview:DownLoadBtn];
        [DownLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-30);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
        }];
        
        UIButton *PaiXuBtn = [[UIButton alloc] init];
        [PaiXuBtn addTarget:self action:@selector(PaiXuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [PaiXuBtn setImage:[UIImage imageNamed:@"PaiXu_Nol.png"] forState:UIControlStateNormal];
        [PaiXuBtn setImage:[UIImage imageNamed:@"PaiXu_Sele.png"] forState:UIControlStateSelected];
        if (isHeaderViewSelected) {
            
            PaiXuBtn.selected = YES;
        }else{
            
            PaiXuBtn.selected = NO;
        }
        [view addSubview:PaiXuBtn];
        [PaiXuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(DownLoadBtn.mas_left).with.offset(-30);
            make.top.mas_equalTo(10);
            make.width.mas_equalTo(24);
            make.height.mas_equalTo(24);
        }];
        
        return view;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (typeDownLoad) {
        
      //  UIView *view = [[UIView alloc] init];
      //  UIButton *btn = (view.tag)indexPath.row + 300;
        
    }else{
    
        NSDictionary *dict = _dataZJArr[indexPath.row];
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

//取消下载按钮
- (void)QuXiaoBtnClick{
    
    [dataZJJMCellArr removeAllObjects];
    typeDownLoad = NO;                  //取消下载状态
    isQXuan = NO;                       //取消全选状态
    [_ZJJieMTabV reloadData];
    
}

//专辑下载
- (void)DownLoadBtnClick:(UIButton *)btn{
    
    if (typeDownLoad) {
        
        typeDownLoad = NO;
        [_ZJJieMTabV reloadData];
    }else{
        
        typeDownLoad = YES;
        [_ZJJieMTabV reloadData];
    }
    
}

//专辑排序
- (void)PaiXuBtnClick:(UIButton *)btn {
    
    NSArray* reversedArray = [[_dataZJArr reverseObjectEnumerator] allObjects];
    [_dataZJArr removeAllObjects];
    [_dataZJArr addObjectsFromArray:reversedArray];
    if (isHeaderViewSelected == YES) {
        isHeaderViewSelected = NO;
    }else{
        isHeaderViewSelected = YES;
    }
    [_ZJJieMTabV reloadData];
    
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

@end
