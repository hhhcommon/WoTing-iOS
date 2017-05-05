//
//  WTQunQMContentCell.m
//  WOTING
//
//  Created by jq on 2017/4/12.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunQMContentCell.h"

@implementation WTQunQMContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellWithString:(NSString *)Str{
    
    if (Str.length > 0) {
        
        _contentLab.text = Str;
        
        CGFloat previewH = [_contentLab.text boundingRectWithSize:CGSizeMake(_contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
        _ContentLabHeight.constant = previewH;
        
        NSInteger contentH = (NSInteger )_ContentLabHeight.constant;
        
        if ([self.delegate respondsToSelector:@selector(ChangeQMHeight:)]) {
            
            [self.delegate ChangeQMHeight:contentH];
        }
    }else{
        
        _contentLab.text = @"暂无群签名";
    }
    
    
}

@end
