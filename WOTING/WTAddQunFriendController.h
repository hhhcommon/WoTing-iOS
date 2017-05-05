//
//  WTAddQunFriendController.h
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAddQunFriendController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *SearchTextF;

@property (weak, nonatomic) IBOutlet UIButton *contentBtnImg;
@property (weak, nonatomic) IBOutlet UILabel *SaoYiSaoLab;
@property (weak, nonatomic) IBOutlet UILabel *SaoYiSaoMingLab;
@property (weak, nonatomic) IBOutlet UILabel *SearchContentLab;
@property (weak, nonatomic) IBOutlet UIView *SearView;

@property (weak, nonatomic) IBOutlet UIView *SearchResultView;

@property (weak, nonatomic) IBOutlet UIButton *ToBtn;

@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@property (nonatomic, assign) NSInteger AddQunFriendType;   //好友or群样式
/** 
 AddQunFriendType = 0;  好友
 AddQunFriendType = 1;  群样式
 */

- (IBAction)SearchBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;

@end
