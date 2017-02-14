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
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:JQ__Plist_managerName(@"DownLoad")];
    
    dataYXZArray = [NSMutableArray arrayWithArray:array];
    _YXZTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _YXZTableView.dataSource = self;
    _YXZTableView.delegate = self;
    
    [self registerCell];
}

- (void)registerCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiDoneCell" bundle:nil];
    
    [_YXZTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

//新增下载任务完成后的通知
- (void)reloadTabVliew:(NSNotification *)not {
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithContentsOfFile:JQ__Plist_managerName(@"DownLoad")];
    NSLog(@"%@",JQ__Plist_managerName(@"DownLoad") );
    dataYXZArray = [NSMutableArray arrayWithArray:array];
    
    [_YXZTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataYXZArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
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
