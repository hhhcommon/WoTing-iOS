//
//  WTRePsdController.h
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTRePsdController : UIViewController
- (IBAction)blackClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;

@property (weak, nonatomic) IBOutlet UITextField *XinPwdTF;

@property (weak, nonatomic) IBOutlet UITextField *ageinPwdTF;
- (IBAction)sureBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;



@end
