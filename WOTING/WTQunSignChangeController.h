//
//  WTQunSignChangeController.h
//  WOTING
//
//  Created by jq on 2017/4/27.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunSignChangeController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *SaveBtn;

- (IBAction)SaveBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextView *SignTextV;

@property (weak, nonatomic) IBOutlet UILabel *ZiLab;

@property (nonatomic, strong) NSDictionary *dataQunDeditc;  //群资料或好友资料

@property (nonatomic, assign) NSInteger SignType;   //样式
/**
 SignType = 0; 群
 SignType = 1; 好友
 */

@property (nonatomic , strong)void (^SignStrChange)(NSString *SignStr);

@end
