//
//  WTQunSetManageController.h
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunSetManageController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BianJiBtn;
- (IBAction)BianjiBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *SetManTabV;

@property (nonatomic, strong) NSMutableArray *dataQunManageArr;

@end
