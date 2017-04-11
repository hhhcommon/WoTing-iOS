//
//  WTFLDetailTitleController.h
//  WOTING
//
//  Created by jq on 2017/3/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YPTabBarController.h"

@interface WTFLDetailTitleController : YPTabBarController
- (IBAction)backBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *contentName;



@property (nonatomic, copy) NSString *contentID;
@property (nonatomic, copy) NSString *nameL;

@end
