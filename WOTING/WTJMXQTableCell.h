//
//  WTJMXQTableCell.h
//  WOTING
//
//  Created by jq on 2017/3/21.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTJMXQTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageName;
@property (weak, nonatomic) IBOutlet UILabel *contantNameLab;
@property (weak, nonatomic) IBOutlet UILabel *FocusNumber;
@property (weak, nonatomic) IBOutlet UIButton *FocusBtnClick;
@property (weak, nonatomic) IBOutlet UILabel *BiaoQianLab;
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentHeight;

@end
