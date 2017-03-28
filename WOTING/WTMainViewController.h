//
//  WTMainViewController.h
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *JQMainTV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ImgVHeight;
@property (weak, nonatomic) IBOutlet UIImageView *ImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
- (IBAction)TuoLoginBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *IntroduceLab;
@property (weak, nonatomic) IBOutlet UIButton *erWeiMaBtn;
- (IBAction)TuoerWeiMaBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BianJiBtn;
- (IBAction)BianJiBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UIImageView *ImgKuang;


@end
