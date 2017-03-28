//
//  WTXiaZaiShengYinController.m
//  WOTING
//
//  Created by jq on 2017/3/21.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTXiaZaiShengYinController.h"

#import "WTXiaZaiDoneCell.h"

@interface WTXiaZaiShengYinController ()<UITableViewDelegate, UITableViewDataSource>{
    
        NSMutableArray *dataArr;     //未处理前的数据
}

@end

@implementation WTXiaZaiShengYinController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataArr = [NSMutableArray arrayWithCapacity:0];
    
    _XiaZaiSYTabV.delegate = self;
    _XiaZaiSYTabV.dataSource = self;
    
    _XiaZaiSYTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerXIAZAICell];
    [self loadData];
}

- (void)registerXIAZAICell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiDoneCell" bundle:nil];
    
    [_XiaZaiSYTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

- (void)loadData{

    FMDatabase *fm = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
    // 1.执行查询语句
    FMResultSet *resultSet = [fm executeQuery:@"SELECT * FROM XIAZAI"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSString *isXIAZAI = [resultSet stringForColumn:@"XIAZAIBOOL"];
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        
        if ([isXIAZAI isEqualToString:@"1"]) {
            
            [dataArr addObject:jsonDict];
            
        }
        
    }
    
    
    [_XiaZaiSYTabV reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArr.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *cellID = @"cellID";
    
    WTXiaZaiDoneCell *cell = (WTXiaZaiDoneCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTXiaZaiDoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
        
    [cell setCellWithDict:dataArr[indexPath.row]];
    
    return cell;
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = dataArr[indexPath.row];
    
    NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
    
    self.tabBarController.selectedIndex = 0;
    //回首页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
    
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
