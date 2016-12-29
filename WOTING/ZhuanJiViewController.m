//
//  ZhuanJiViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "ZhuanJiViewController.h"

#import "WTLikeCell.h"

@interface ZhuanJiViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ZhuanJiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _ZJTableView.delegate = self;
    _ZJTableView.dataSource = self;
    
    [self registerTabViewCell];
}

//注册
- (void)registerTabViewCell{
    
    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [_ZJTableView registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataZJArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellIDL";
    
    WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = _dataZJArr[indexPath.row];
    [cell setCellWithDict:dict];
    
    
    return cell;
    
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
