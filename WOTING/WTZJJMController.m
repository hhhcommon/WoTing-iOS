//
//  WTZJJMController.m
//  WOTING
//
//  Created by jq on 2016/12/20.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZJJMController.h"

#import "WTZhuanJiCell.h"

@interface WTZJJMController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
}

@end

@implementation WTZJJMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _ZJJieMTabV.delegate = self;
    _ZJJieMTabV.dataSource = self;
    _ZJJieMTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerTableViewCell];
}

- (void)registerTableViewCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTZhuanJiCell" bundle:nil];
    
    [_ZJJieMTabV registerNib:cellNib forCellReuseIdentifier:@"cellIDL"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataZJArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    static NSString *cellID = @"cellIDL";
    
    WTZhuanJiCell *cell = (WTZhuanJiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTZhuanJiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = _dataZJArr[indexPath.row];
    [cell setCellWithDict:dict];
    
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _dataZJArr[indexPath.row];
    NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
 
    
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
