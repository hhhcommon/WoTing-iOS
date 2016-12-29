//
//  WTLikeCell.m
//  WOTING
//
//  Created by jq on 2016/12/19.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTLikeCell.h"

@implementation WTLikeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    //图片
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //标题
    _nameLab.text =[NSString NULLToString:dict[@"ContentName"]];
    
    //我听
    _WTLab.text =[NSString NULLToString:dict[@"ContentPub"]];
    
    //听众
    _PlayCount.text = [NSString NULLToString:dict[@"PlayCount"]];
    
    
    //专辑数
    _contentZJ.text = [NSString stringWithFormat:@"%@集",[NSString NULLToString:dict[@"ContentSubCount"]]];
    
}

@end
