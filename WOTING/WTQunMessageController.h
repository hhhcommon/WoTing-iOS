//
//  WTQunMessageController.h
//  WOTING
//
//  Created by jq on 2017/4/19.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunMessageController : UIViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *SureTop;

@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UIView *QunView1;
@property (weak, nonatomic) IBOutlet UIView *QunView2;
@property (weak, nonatomic) IBOutlet UIView *QunView3;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
@property (weak, nonatomic) IBOutlet UITextField *PsdTF1;
@property (weak, nonatomic) IBOutlet UITextField *PsdTF2;
@property (weak, nonatomic) IBOutlet UITextField *PsdTF3;

@property (nonatomic, assign)NSInteger  QunMessageType;
/*
 QunMessageType = 0;    //审核群
 QunMessageType = 1;    //公开 and
 QunMessageType = 2;    //密码群
 */

- (IBAction)backBtnClick:(id)sender;
- (IBAction)SureBtnClick:(id)sender;

@end
