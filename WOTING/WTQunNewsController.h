//
//  WTQunNewsController.h
//  WOTING
//
//  Created by jq on 2017/4/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunNewsController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UITableView *QunNewsTabV;

@property (nonatomic, copy) NSString *contentQunName;
@property (nonatomic, strong) NSDictionary *dataQunDesDict;  //群详情

@property (nonatomic, assign) NSInteger JoinType;   //加群 or 审核
/** 
 JoinType == 0; 加群
 JoinType == 1; 审核
 */

@end
