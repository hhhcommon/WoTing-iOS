//
//  WTBoundPhoneController.h
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBoundPhoneController : UIViewController
- (IBAction)blackBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextF;
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UIButton *YZMBtn;
- (IBAction)YZMBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *YZMView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
- (IBAction)sureBtnClick:(id)sender;

@end
