//
//  WTCreateQunController.m
//  WOTING
//
//  Created by jq on 2017/4/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTCreateQunController.h"

#import "WTQunMessageController.h"  //选择群类型

#import "WTCreateQunCell.h" //创建群cell

@interface WTCreateQunController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation WTCreateQunController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _CreateTabV.delegate = self;
    _CreateTabV.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return (K_Screen_Height-64)/3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WTCreateQunCell *cell = [WTCreateQunCell cellWithTableView:tableView];
    
    if (indexPath.row == 0) {
        
        cell.contentImageView.image = [UIImage imageNamed:@"OpenQun.png"];
        cell.contentName.text = @"公开群";
        cell.contentLabel.text = @"无需验证加入";
    }else if (indexPath.row == 1){
        
        cell.contentImageView.image = [UIImage imageNamed:@"PsdQun.png"];
        cell.contentName.text = @"密码群";
        cell.contentLabel.text = @"需输入群密码加入";
    }else{
        
        cell.contentImageView.image = [UIImage imageNamed:@"YanZhengQun.png"];
        cell.contentName.text = @"审核群";
        cell.contentLabel.text = @"提交验证信息加入";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        WTQunMessageController *wtMessageVC = [[WTQunMessageController alloc] init];
        wtMessageVC.QunMessageType = 1;
        wtMessageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtMessageVC animated:YES];
    }else if(indexPath.row == 1){
        
        WTQunMessageController *wtMessageVC = [[WTQunMessageController alloc] init];
        wtMessageVC.QunMessageType = 2;
        wtMessageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtMessageVC animated:YES];
        
    }else{
        
        WTQunMessageController *wtMessageVC = [[WTQunMessageController alloc] init];
        wtMessageVC.QunMessageType = 0;
        wtMessageVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtMessageVC animated:YES];
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
@end
