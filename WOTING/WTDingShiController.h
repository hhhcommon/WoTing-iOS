//
//  WTDingShiController.h
//  WOTING
//
//  Created by jq on 2017/1/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDingShiController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UITableView *TimeTab;

@end
