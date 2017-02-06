//
//  WTBoFangXQCell.m
//  WOTING
//
//  Created by jq on 2017/1/5.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTBoFangXQCell.h"

@implementation WTBoFangXQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDictWithCell:(WTBoFangModel *)model {
    
    _ZhuBoLab.text = @"暂无主播信息";
    
    
    _ZhuanJILab.text = @"暂无专辑信息";
    
    
    _fromLab.text = model.ContentPub;
    
    //简介
    if (![model.ContentDescn isKindOfClass:[NSNull class]]) {
        
        _ContentLab.text = model.ContentDescn;
        
        CGFloat previewH = [_ContentLab.text boundingRectWithSize:CGSizeMake(_ContentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size.height;
        _ContentHeight.constant = previewH;
        
        NSInteger contentH = (NSInteger )_ContentHeight.constant;
        
        if ([self.delegate respondsToSelector:@selector(ChangeHeight:)]) {
            
            [self.delegate ChangeHeight:contentH];
        }
    }else {
        
        _ContentLab.text = @"暂无简介";
    }

    
}

@end
