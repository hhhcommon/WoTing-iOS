//
//  WTNewFriendController.h
//  WOTING
//
//  Created by jq on 2017/4/11.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTNewFriendController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *NewFriendLab;
@property (weak, nonatomic) IBOutlet UITableView *NewFriendTabV;

@property (nonatomic, copy) NSString *ConText;

@end
