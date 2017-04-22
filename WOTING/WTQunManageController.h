//
//  WTQunManageController.h
//  WOTING
//
//  Created by jq on 2017/4/14.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunManageController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UISearchBar *SearchManage;
@property (weak, nonatomic) IBOutlet UITableView *ManageTabV;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;

@property (nonatomic, strong) NSDictionary *dataQunDeDict;   //当前群信息
@property (nonatomic, strong) NSMutableArray *dataManageArr;    //群成员
- (IBAction)SureBtnClick:(id)sender;

@property (nonatomic, copy) NSString *contentText;  //标题
@property (nonatomic, assign) NSInteger QunType;   //详情样式;
/*
 QunType = 0; 隐藏选中框 and 查看群成员
 QunType = 1; 移交群主(只能选一个)
 QunType = 2; 设置群管理(可多选)
 
 QunType = 3; 添加群成员
 QunType = 4; 删除群成员
 */

@end
