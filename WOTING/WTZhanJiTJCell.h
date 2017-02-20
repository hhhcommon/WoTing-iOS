//
//  WTZhanJiTJCell.h
//  WOTING
//
//  Created by jq on 2017/2/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTZhanJiTJCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
- (IBAction)GuanZhuBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *LabHeight;
@property (weak, nonatomic) IBOutlet UILabel *BiaoQianLab;


@end
