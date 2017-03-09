//
//  WTZhuanJiDownloadCell.m
//  WOTING
//
//  Created by jq on 2017/3/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTZhuanJiDownloadCell.h"

@implementation WTZhuanJiDownloadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict {
    
    //标题
    _contentName.text =[NSString NULLToString:dict[@"ContentName"]];
    
}

@end
