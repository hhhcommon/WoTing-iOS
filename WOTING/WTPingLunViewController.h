//
//  WTPingLunViewController.h
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBaseViewController.h"

@interface WTPingLunViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;
@property (weak, nonatomic) IBOutlet UITableView *PLTabV;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UIButton *FSBtn;
@property (weak, nonatomic) IBOutlet UIButton *BQBtn;
- (IBAction)BQBtnClick:(id)sender;
- (IBAction)FSBtnClick:(id)sender;//发送

- (IBAction)backClick:(id)sender;

@property (nonatomic, copy) NSString *ContentID;
@property (nonatomic, copy) NSString *Metype;

@end
