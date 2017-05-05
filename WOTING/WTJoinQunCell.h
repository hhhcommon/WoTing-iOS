//
//  WTJoinQunCell.h
//  WOTING
//
//  Created by jq on 2017/4/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTJoinQunCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;

@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *ShenQLab;

@property (weak, nonatomic) IBOutlet UILabel *auditLab;
@property (weak, nonatomic) IBOutlet UIButton *JuJueBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;



@end
