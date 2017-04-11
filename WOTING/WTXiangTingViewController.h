//
//  WTXiangTingViewController.h
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTXiangTingViewController : UIViewController
- (IBAction)MoveBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *charBtn;
@property (weak, nonatomic) IBOutlet UIButton *TongXunLuBtn;
- (IBAction)charBtnClick:(id)sender;
- (IBAction)TongXunLuBtnClick:(id)sender;




@end
