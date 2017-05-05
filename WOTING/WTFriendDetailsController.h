//
//  WTFriendDetailsController.h
//  WOTING
//
//  Created by jq on 2017/4/12.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JQComplete)(BOOL succ);

@interface WTFriendDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UITableView *FriendTabV;

- (IBAction)backBtnClick:(id)sender;

@property (nonatomic, strong) NSDictionary *dataFriDict;    //好友资料



@end
