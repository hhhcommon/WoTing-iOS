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
    [_ContentImg sd_setImageWithURL:[NSURL URLWithString:dict[@"ContentImg"]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //标题
    _ContentName.text = dict[@"ContentName"];
    
    //我听
    _WTLab.text = @"我听科技";
    
    //听众
    _PlayCount.text = dict[@"PlayCount"];
    
    //时间
    NSString *timeStr = dict[@"ContentTimes"];
    NSTimeInterval time=[timeStr doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
//    NSString *currentDateStr = [WKProgressHUD timeForBeiJingTimeStamp:timeStr andsetDateFormat:@"mm:ss"];
    
    _ContentTimes.text = currentDateStr;
    
}

@end
