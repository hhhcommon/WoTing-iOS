//
//  WTFanKuiViewController.h
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTFanKuiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *TiJiaoBtn;
- (IBAction)TiJiaoBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)hotBtnClick:(id)sender;

@end
