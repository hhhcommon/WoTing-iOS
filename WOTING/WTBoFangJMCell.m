//
//  WTBoFangJMCell.m
//  WOTING
//
//  Created by jq on 2017/1/4.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTBoFangJMCell.h"

@implementation WTBoFangJMCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)XianSBtnClick:(id)sender {
    
    _XianSBtn.selected ^= 1;
    
    if ([self.delegate respondsToSelector:@selector(XianShiBtnClick:)]) {
        
        [self.delegate XianShiBtnClick:_XianSBtn];
    }
}
@end
