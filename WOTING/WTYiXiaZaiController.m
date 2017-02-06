//
//  WTYiXiaZaiController.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTYiXiaZaiController.h"

#import "WTXiaZaiDoneCell.h"

@interface WTYiXiaZaiController ()<UITableViewDelegate, UITableViewDataSource>{
 
    NSMutableArray *dataYXZArray;
}

@end

@implementation WTYiXiaZaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataYXZArray = [NSMutableArray arrayWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTabVliew:) name:@"YIXIAZAI" object:nil];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DownLoad" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [dataYXZArray addObject:data];
    
    _YXZTableView.dataSource = self;
    _YXZTableView.delegate = self;
}

//新增下载任务完成后的通知
- (void)reloadTabVliew:(NSNotification *)not {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DownLoad" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    [dataYXZArray addObject:data];
    
    [_YXZTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataYXZArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellIDL";
    
    WTXiaZaiDoneCell *cell = (WTXiaZaiDoneCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTXiaZaiDoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    [cell setCellWithDict:dataYXZArray[indexPath.row]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
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

@end
