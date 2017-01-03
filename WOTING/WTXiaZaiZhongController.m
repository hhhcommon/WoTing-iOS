//
//  WTXiaZaiZhongController.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiaZaiZhongController.h"

#import "WTXiaZaiCell.h"


@interface WTXiaZaiZhongController ()<WTXiaZaiCellDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    
}

@end

@implementation WTXiaZaiZhongController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _XZZTableView.delegate = self;
    _XZZTableView.dataSource = self;
    
    _XZZTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _XZZTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerTableCell];
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
    [cell changeBeginAndStop];
    cell.delegate = self;
    
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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"DownLoad" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary *dict in _urls) {
        
        if ([str isEqualToString:dict[@"ContentPlay"]]) {
            
            [data setDictionary:dict];
            [_urls removeObject:dict];
            [_XZZTableView reloadData];
        }
    }
    NSLog(@"%@", data);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YIXIAZAI" object:nil];
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
