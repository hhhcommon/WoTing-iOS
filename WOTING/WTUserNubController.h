//
//  WTUserNubController.h
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTUserNubController : UIViewController
- (IBAction)blackBtnClick:(id)sender;
- (IBAction)sureBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *numTextF;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *textFView;

@end
