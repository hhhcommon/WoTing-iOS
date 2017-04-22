//
//  WTJoinQunCell.m
//  WOTING
//
//  Created by jq on 2017/4/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTJoinQunCell.h"

@implementation WTJoinQunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_JuJueBtn.layer setBorderWidth:1.0];
    _JuJueBtn.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
