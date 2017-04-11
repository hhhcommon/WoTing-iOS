//
//  WTLikeListViewController.h
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBaseViewController.h"

@interface WTLikeListViewController : WTBaseViewController

@property (weak, nonatomic) IBOutlet UILabel *NameLab;

- (IBAction)backClick:(id)sender;
- (IBAction)cleanBtnClick:(id)sender;

@property (copy, nonatomic) NSString *label;

@end
