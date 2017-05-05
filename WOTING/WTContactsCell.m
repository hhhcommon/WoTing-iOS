//
//  WTContactsCell.m
//  WOTING
//
//  Created by jq on 2017/4/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTContactsCell.h"

@implementation WTContactsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithDict:(NSDictionary *)dict{
    
    _contentName.text = [NSString NULLToString:dict[@"GroupName"]];
    
    _QunNumber.text = [NSString stringWithFormat:@"ID: %@" , [NSString NULLToString:dict[@"GroupNum"]]];
    
    _QunBeiZhu.text = [NSString NULLToString:dict[@"GroupMyAlias"]];
    
    if ([[NSString NULLToString:dict[@"PortraitBig"]] hasPrefix:@"http"]) {
        [_contentImgv sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
    }else if ([NSString NULLToString:dict[@"PortraitBig"]].length){
        
        [_contentImgv sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,dict[@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
        
    }else{
        
        _contentImgv.image = [UIImage imageNamed:@"Friend_header.png"];
    }
}

@end
