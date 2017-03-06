//
//  WTXiaZaiXuanZhongCell.m
//  WOTING
//
//  Created by jq on 2017/3/2.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTXiaZaiXuanZhongCell.h"

@implementation WTXiaZaiXuanZhongCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //标题
    _contentName.text =[NSString NULLToString:dict[@"ContentName"]];
    //来源
    _contentPub.text =[NSString NULLToString:dict[@"ContentPub"]];
    
    //多少集
    _JiLab.text = [NSString stringWithFormat:@"%@集", @"1"];
    
    //站内存大小
    _sizeLab.text = [NSString stringWithFormat:@"%@MB", @""];
}



- (IBAction)xuanzhongBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(XuanZhongBtnClick:)]) {
        
        [self.delegate XuanZhongBtnClick:_XuanZhongBtn];
    }
}
@end
