//
//  WTDownLoadViewController.h
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDownLoadViewController : UIViewController
- (IBAction)XiaoXiBtnClick:(id)sender;
- (IBAction)SearchBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *YXZBtn;
@property (weak, nonatomic) IBOutlet UIButton *XZZBtn;
- (IBAction)YXZBtnClick:(id)sender;
- (IBAction)XZZBtnClick:(id)sender;

@end
