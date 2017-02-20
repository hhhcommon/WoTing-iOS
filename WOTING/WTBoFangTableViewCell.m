//
//  WTBoFangTableViewCell.m
//  WOTING
//
//  Created by jq on 2016/11/29.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangTableViewCell.h"

@implementation WTBoFangTableViewCell

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
    [_ContentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //标题
    _ContentName.text =[NSString NULLToString:dict[@"ContentName"]];
    
    //我听
    _WTLab.text =[NSString NULLToString:dict[@"ContentPub"]];
    
    //听众
    _PlayCount.text = [NSString stringWithFormat:@"%@",dict[@"PlayCount"] ];
    
    //时间
    NSString *ContentTimes = [NSString NULLToString:dict[@"ContentTimes"]];
    NSTimeInterval time=[ContentTimes doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *currentStr = [dateFormatter stringFromDate: detaildate];
    
    _ContentTimes.text = currentStr;
    
}

@end
