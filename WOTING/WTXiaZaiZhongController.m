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

    
    [self registerTableCell];
    
    [self loadData];
    

}


- (void)loadData {
    
    FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];

    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];

    while ([resultSet next]) {
        
        NSString *isXIAZAI = [resultSet stringForColumn:@"XIAZAIBOOL"];
        
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        if ([isXIAZAI isEqualToString:@"0"]) {
            
            [_urls addObject:jsonDict];
          
        }
    }
   
    [_XZZTableView reloadData];
}


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

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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
