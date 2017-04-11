//
//  WTZhuBoController.h
//  WOTING
//
//  Created by jq on 2017/3/23.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTZhuBoController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backView;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
- (IBAction)backBtnClick:(id)sender;
- (IBAction)GuanZhuBtnClick:(id)sender;

@property (nonatomic, strong) NSDictionary *dataDefDict;

@end
