//
//  WTZhuanJiCell.m
//  WOTING
//
//  Created by jq on 2016/12/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZhuanJiCell.h"

@implementation WTZhuanJiCell

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
    _nameLab.text =[NSString NULLToString:dict[@"ContentName"]];
    
    //总共收听次数
    NSString *NumLabStr = [NSString stringWithFormat:@"%@",[dict[@"PlayCount"] stringValue]];
    _numLab.text = NumLabStr;
    
    //播放时长
    NSString *ContentTimes = [NSString NULLToString:dict[@"ContentTimes"]];
    NSTimeInterval time=[ContentTimes doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *currentStr = [dateFormatter stringFromDate: detaildate];
    _time2Lab.text = currentStr;
    
    //时间

    NSString *timeStr = [NSString stringWithFormat:@"%@",[dict[@"ContentPubTime"] stringValue]];
    NSTimeInterval timeT=[timeStr doubleValue];
    NSDate *detaildateT=[NSDate dateWithTimeIntervalSince1970:timeT/1000.0];
    NSDateFormatter *dateFormatterT = [[NSDateFormatter alloc] init];
    [dateFormatterT setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatterT stringFromDate: detaildateT];
    
    _timeLab.text = currentDateStr;
    
    
}

@end
