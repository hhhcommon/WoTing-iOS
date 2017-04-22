//
//  WTQuitQunCell.m
//  WOTING
//
//  Created by jq on 2017/4/12.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQuitQunCell.h"

@implementation WTQuitQunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _QuitBtn.layer.cornerRadius = 10;
    _QuitBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
