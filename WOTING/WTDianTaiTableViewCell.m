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
    
//    if (![dict isKindOfClass:[NSNull class]]) {
        
        //图片
        [_ContentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
        
        //标题
        _ContentName.text = [NSString NULLToString:dict[@"ContentName"]];
        
        //我听[4]	(null)	@"IsPlaying" : @"体育新世界——金戈铁马"
        if ([[NSString NULLToString:dict[@"IsPlaying"]] isEqualToString:@""]) {
            
            _WTLab.text = @"暂无节目单";
        }else {
            
            _WTLab.text = [NSString NULLToString:dict[@"IsPlaying"]];
        }
        //听众
        _PlayCount.text = [NSString stringWithFormat:@"%@",[dict[@"PlayCount"] stringValue]];
//    }else{
//        
//    }

}


@end
