//
//  WTQunSetManageController.m
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunSetManageController.h"

#import "WTQunManageController.h" //选择群管理

#import "WTQunManageCell.h" //cell样式
#import "WTSetManTabCell.h"

@interface WTQunSetManageController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataSetManArr;  //设置管理数据源
}

@end

@implementation WTQunSetManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _SetManTabV.delegate = self;
    _SetManTabV.dataSource = self;

    [_BianJiBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_BianJiBtn setTitle:@"删除" forState:UIControlStateSelected];
    
    [self registerSetManTabCell];
}

- (void)registerSetManTabCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTQunManageCell" bundle:nil];
    
    [_SetManTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *cellSetNib = [UINib nibWithNibName:@"WTSetManTabCell" bundle:nil];
    
    [_SetManTabV registerNib:cellSetNib forCellReuseIdentifier:@"cellST"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else{
        
        return dataSetManArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }else{
        
        return [NSString stringWithFormat:@"管理员(%lu)", dataSetManArr.count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"cellST";
        
        WTSetManTabCell *cell = (WTSetManTabCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTSetManTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        return cell;
        
    }else{
    
        static NSString *cellID = @"cellID";
        
        WTQunManageCell *cell = (WTQunManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        if (_BianJiBtn.selected) {
            
            cell.XuanZhongBtn.hidden = NO;
        }else{
            
            cell.XuanZhongBtn.hidden = YES;
        }
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
        wtQunMVC.dataManageArr = _dataQunManageArr;
        wtQunMVC.contentText = @"设置群管理";
        wtQunMVC.QunType = 2;
        wtQunMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtQunMVC animated:YES];
    }
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
- (IBAction)BianjiBtnClick:(id)sender {
    
    if (_BianJiBtn.selected){
        
        _BianJiBtn.selected = NO;
        [_SetManTabV reloadData];
        
    }else{
        
        _BianJiBtn.selected = YES;
        [_SetManTabV reloadData];
    }
}
@end
