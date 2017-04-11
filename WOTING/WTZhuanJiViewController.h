//
//  WTZhuanJiViewController.h
//  WOTING
//
//  Created by jq on 2016/12/19.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTZhuanJiViewController : UIViewController

- (IBAction)backClick:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
- (IBAction)likeBtnClick:(id)sender;
- (IBAction)commitBtnClick:(id)sender;
- (IBAction)shareBtnClick:(id)sender;
- (IBAction)dingYueBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ZJlikeBtn;
@property (weak, nonatomic) IBOutlet UIButton *ZJDingYueBtn;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (nonatomic, copy) NSString *contentID;

- (IBAction)JuBaoBtnClick:(id)sender;

@end
