//
//  WTXiaZaiZhongController.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiaZaiZhongController.h"

#import "WTXiaZaiCell.h"


@interface WTXiaZaiZhongController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *_urls;
    
    BOOL    isDownLoad;     //判断当前是否有下载
}

@end

@implementation WTXiaZaiZhongController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"XIAZAIWEIWANCHENG" object:nil];
    
//    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _urls = [NSMutableArray arrayWithCapacity:0];
    
    _XZZTableView.delegate = self;
    _XZZTableView.dataSource = self;
    
    _XZZTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _XZZTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XiaZaiDict:) name:@"XIAZAIDICT" object:nil];
    
    [self registerTableCell];
    
    [self loadData];
    
//    if (_urls.count == 0||_urls == nil) {
//        
//        UIImageView *ImgV = [[UIImageView alloc] init];
//        ImgV.image = [UIImage imageNamed:@"WuShuJu.png"];
//        ImgV.userInteractionEnabled = YES;
//        [self.view addSubview:ImgV];
//        __weak WTXiaZaiZhongController *weakSelf = self;
//        [ImgV mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.centerX.equalTo(weakSelf.view);
//            make.centerY.equalTo(weakSelf.view);
//            make.width.mas_equalTo(K_Screen_Width/2);
//            make.height.mas_equalTo(K_Screen_Width/2);
//        }];
//    }
}


- (void)loadData {
    
    [_urls removeAllObjects];
    
    FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];

    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];

    while ([resultSet next]) {
        
        BOOL isXIAZAI = [resultSet boolForColumn:@"XIAZAIBOOL"];
        
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        if (!isXIAZAI) {
            
            [_urls addObject:jsonDict];
          
        }
    }
   
    [_XZZTableView reloadData];
}


//接受到下载到的数据
//- (void)XiaZaiDict:(NSNotification *)not{
//    
//    NSDictionary *dict = not.userInfo;
//    
//    if (dict[@"DownLoad"]) {
//        
//        for (NSDictionary *JQdict in dict[@"DownLoad"]) {
//            
//            FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
//            
//            
//            BOOL isRept = NO;
//            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
//            // 遍历结果，如果重复就删除数据
//            while ([resultSet next]) {
//                
//                NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
//                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
//                if ([JQdict[@"ContentId"] isEqualToString:jsonDict[@"ContentId"]]) {
//                    
//                    isRept = YES;
//                }
//            }
//            if (!isRept) {
//                
//                [_urls addObject:dict];
//                
//                [_XZZTableView reloadData];
//            }
//        }
//        
//    }else{
//    
//        FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
//        
//            
//        BOOL isRept = NO;
//        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
//        // 遍历结果，如果重复就删除数据
//        while ([resultSet next]) {
//            
//            NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
//            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
//            if ([dict[@"ContentId"] isEqualToString:jsonDict[@"ContentId"]]) {
//                
//                isRept = YES;
//            }
//        }
//        if (!isRept) {
//            
//            [_urls addObject:dict];
//            
//            [_XZZTableView reloadData];
//        }
//    }
//    
//}

- (void)registerTableCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiCell" bundle:nil];
    
    [_XZZTableView registerNib:cellNib forCellReuseIdentifier:@"cellIDL"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _urls.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellIDL";
    
    WTXiaZaiCell *cell = (WTXiaZaiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTXiaZaiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [cell Content:_urls[indexPath.row]];
    
//    [cell changeBeginAndStop];  //开始下载任务...
//    cell.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//下载完成 ， 移除下载任务
- (void)DownLoadWithPlist:(NSString *)str {

//    for (NSDictionary *dict in _urls) {
//        
//        if ([str isEqualToString:dict[@"ContentPlay"]]) {
//            
//            FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
//            
//            NSLog( @"%@",dict);
//            
//            BOOL isRept = NO;
//            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
//            // 遍历结果，如果重复就删除数据
//            while ([resultSet next]) {
//                
//                NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
//                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
//                if ([dict[@"ContentId"] isEqualToString:jsonDict[@"ContentId"]]){
//                    
//                    isRept = YES;
//                }
//            }
//            if (!isRept) {
//                
//                NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//                NSString *sqlInsert = @"insert into XIAZAI values(?,?)";
//                BOOL isOk = [db executeUpdate:sqlInsert, data, dict[@"ContentId"]];
//                if (isOk) {
//                    NSLog(@"添加数据成功");
//                    [_urls removeObject:dict];
//                    [_XZZTableView reloadData];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"YIXIAZAI" object:nil];
//                }
//                
//            }
//            
//            
//        }
//    }

    [self loadData];
    
}

//- (NSDictionary *)PlistDictChange:(NSDictionary *)dict {
//    
//    NSMutableDictionary *Changedict = [[NSMutableDictionary alloc] init];
//    
//    [Changedict setValue: [NSString NULLToString:dict[@"ContentTimes"]] forKey:@"ContentTimes"];
//    [Changedict setValue:[NSString NULLToString:dict[@"ContentPub"]] forKey:@"ContentPub"];
//    [Changedict setValue:[NSString NULLToString:dict[@"ContentShareURL"]] forKey:@"ContentShareURL"];
//    [Changedict setValue:[NSString NULLToString:dict[@"MediaType"]] forKey:@"MediaType"];
//    [Changedict setValue:[NSString NULLToString:dict[@"ContentName"]] forKey:@"ContentName"];
//    [Changedict setValue:[NSString NULLToString:dict[@"ContentImg"]] forKey:@"ContentImg"];
//    [Changedict setValue:[NSString NULLToString:dict[@"ContentId"]] forKey:@"ContentId"];
//    [Changedict setValue:[NSString NULLToString:dict[@"PlayCount"]] forKey:@"PlayCount"];
//    
//    [Changedict setValue:[NSString NULLToString:dict[@"SeqInfo"][@"ContentId"]] forKey:@"SeqContentId"];
//    [Changedict setValue:[NSString NULLToString:dict[@"SeqInfo"][@"ContentImg"]] forKey:@"SeqContentImg"];
//    [Changedict setValue:[NSString NULLToString:dict[@"SeqInfo"][@"ContentName"]] forKey:@"SeqContentName"];
//    [Changedict setValue:[NSString NULLToString:dict[@"SeqInfo"][@"ContentPub"]] forKey:@"SeqContentPub"];
//    
//    
//    
//    return Changedict;
//}


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
