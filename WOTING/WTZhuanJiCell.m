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
    
    //我听
    _numLab.text =[NSString NULLToString:dict[@"PlayCount"]];
    
    
    _time2Lab.text = @"0'00''";
    
    //时间
    NSString *timeStr = [NSString NULLToString:dict[@"ContentPubTimes"]];
    NSTimeInterval time=[timeStr doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    //    NSString *currentDateStr = [WKProgressHUD timeForBeiJingTimeStamp:timeStr andsetDateFormat:@"mm:ss"];
    
    _timeLab.text = currentDateStr;
    
    
}

@end
