//
//  WTQunDetailsController.h
//  WOTING
//
//  Created by jq on 2017/4/11.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^JQComplete)(BOOL succ);

@interface WTQunDetailsController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *QunDetailsView;

- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UIButton *JiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *XiuGaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *ContentName;
@property (weak, nonatomic) IBOutlet UILabel *QunNumber;
@property (weak, nonatomic) IBOutlet UILabel *QunName;
@property (weak, nonatomic) IBOutlet UITextField *ContentTextfield;
@property (weak, nonatomic) IBOutlet UITextField *QunNameTextfield;

- (IBAction)BianJiBtnClick:(id)sender;

@property (nonatomic, assign) NSInteger QunDetailsType;     //群样式
/*
 QunDetailsType = 0; 验证群
 QunDetailsType = 1; 公开群
 QunDetailsType = 2; 密码群
 
 */

@property (weak, nonatomic) IBOutlet UITableView *QunDetailsTabV;

@property (nonatomic, strong) NSDictionary *dataQunDict;    //群数据资料


@end
