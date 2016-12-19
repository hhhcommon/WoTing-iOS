//
//  WTSearchViewController.h
//  WOTING
//
//  Created by jq on 2016/12/15.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBaseViewController.h"

@interface WTSearchViewController : WTBaseViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTField;
- (IBAction)searchBtnClick:(id)sender;

@end
