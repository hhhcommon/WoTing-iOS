//
//  WTCreateQunCell.m
//  WOTING
//
//  Created by jq on 2017/4/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTCreateQunCell.h"

@implementation WTCreateQunCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    
    NSString *cellID = [NSString stringWithFormat:@"%@_ID",NSStringFromClass(self)];

        WTCreateQunCell *cell = (WTCreateQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            
            cell = [[WTCreateQunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
            
        }
    
    return cell;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        __weak WTCreateQunCell *WeakSelf = self;
        
        _contentImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_contentImageView];
        [_contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(WeakSelf.mas_centerY);
            make.left.mas_equalTo(30);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(80);
        }];
        
        _contentName = [[UILabel alloc] init];
        _contentName.font = [UIFont boldSystemFontOfSize:20];
        _contentName.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentName];
        [_contentName mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(WeakSelf.mas_right).with.offset(-30);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(40);
            make.centerY.equalTo(WeakSelf.mas_centerY);
        }];
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont boldSystemFontOfSize:13];
        _contentLabel.textColor = [UIColor skTextLowGrayColor];
        _contentLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(WeakSelf.mas_right).with.offset(-30);
            make.width.mas_equalTo(140);
            make.height.mas_equalTo(21);
            make.top.equalTo(_contentName.mas_bottom).with.offset(8);
        }];
        
        
    }
    
    return self;
}


@end
