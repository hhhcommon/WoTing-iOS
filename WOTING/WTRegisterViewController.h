//
//  WTRegisterViewController.h
//  WOTING
//
//  Created by jq on 2016/11/26.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBaseViewController.h"

@interface WTRegisterViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet UIView *RegisterView;
@property (weak, nonatomic) IBOutlet UIView *YanZView;

@property (weak, nonatomic) IBOutlet UIButton *QueDBtn;

- (IBAction)blackBtnClick:(id)sender;


- (IBAction)QueDBtnClick:(id)sender;

- (IBAction)YanZBtnClick:(id)sender;




@end
