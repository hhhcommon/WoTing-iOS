//
//  WTDianTaiTableViewCell.m
//  WOTING
//
//  Created by jq on 2016/12/1.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDianTaiTableViewCell.h"

@implementation WTDianTaiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    if (![dict isKindOfClass:[NSNull class]]) {
        
        //图片
        [_ContentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
        
        //标题
        _ContentName.text = dict[@"ContentName"];
        
        //我听
        _WTLab.text = dict[@"ContentPub"];
        
        //听众
        _PlayCount.text = dict[@"PlayCount"];
    }else{
        
    }

}


@end
