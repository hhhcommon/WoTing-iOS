//
//  WTPingLunCell.m
//  WOTING
//
//  Created by jq on 2016/12/17.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTPingLunCell.h"

@implementation WTPingLunCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    //头像
    if ([dict[@"UserInfo"][@"PortraitMini"] hasPrefix:@"http"]) {
        
        [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"UserInfo"][@"PortraitMini"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
    }else{
        
        NSString *imgStr = [NSString stringWithFormat:SKInterFaceServer@"%@",dict[@"UserInfo"][@"PortraitMini"]];
        [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:imgStr]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
    }
    
    //昵称
    _nameLab.text = dict[@"UserInfo"][@"NickName"];
    
    //时间
    
    NSTimeInterval time=[dict[@"Time"] doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    _timeLab.text = currentDateStr;
    
    //内容
    _contentLab.text = dict[@"Discuss"];

}

@end
