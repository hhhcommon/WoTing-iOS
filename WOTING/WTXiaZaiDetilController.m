
//
//  WTXiaZaiDetilController.m
//  WOTING
//
//  Created by jq on 2017/3/2.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTXiaZaiDetilController.h"

#import "WTXiaZaiDetilCell.h"

@interface WTXiaZaiDetilController ()<UITableViewDataSource, UITableViewDelegate, WTXiaZaiDetilCellDelegate>

@property (nonatomic, strong) NSMutableArray *dataDetilArr;

@end

@implementation WTXiaZaiDetilController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataDetilArr = [NSMutableArray arrayWithCapacity:0];
    
    _XiaZaiDetilTab.dataSource = self;
    _XiaZaiDetilTab.delegate = self;
    
    if (_dataDict) {
        
        if (_dataDict[@"SeqInfo"]) {
            
           _contentName.text = _dataDict[@"SeqInfo"][@"ContentName"];
        }else {
            
            _contentName.text = _dataDict[@"ContentName"];
        }
        
        _jiLab.text = [NSString stringWithFormat:@"共%@个节目", @"1"];
        _sizeLab.text = [NSString stringWithFormat:@"共%@MB",@""];
       [_dataDetilArr addObject:_dataDict];
    }
    
    
    [self registerTableViewCell];
    
    [_XiaZaiDetilTab reloadData];
}

- (void)registerTableViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiDetilCell" bundle:nil];
    
    [_XiaZaiDetilTab registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataDetilArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    WTXiaZaiDetilCell *cell = (WTXiaZaiDetilCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTXiaZaiDetilCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.delegate = self;
    [cell setCellwithDict:_dataDetilArr[indexPath.row]];
    
    return cell;
}

//删除单个节目单体
- (void)CleanClick{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dict = _dataDetilArr[indexPath.row];
    NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
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
@end
