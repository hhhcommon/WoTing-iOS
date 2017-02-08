//
//  WTXiaZaiDoneCell.m
//  WOTING
//
//  Created by jq on 2016/12/30.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiaZaiDoneCell.h"

@implementation WTXiaZaiDoneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict {
    
    NSLog(@"%@",dict);
    //图片
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //标题
    _nameLab.text =[NSString NULLToString:dict[@"ContentName"]];
    
    //我听
    _playConLab.text =[NSString NULLToString:dict[@"ContentPub"]];
    
    //听众
    _numberLab.text = [NSString NULLToString:dict[@"PlayCount"]];

    
  //  _ContentTimes.text = currentDateStr;
    
}

@end
