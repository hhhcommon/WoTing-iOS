//
//  WTZhuanJiView.m
//  WOTING
//
//  Created by jq on 2016/12/26.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZhuanJiView.h"

@implementation WTZhuanJiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self ContentView];
    }
    return self;
}

- (void)ContentView {
    
    _NumLab = [[UILabel alloc] init];
    [self addSubview:_NumLab];
    _NumLab.font = [UIFont systemFontOfSize:13];
    [_NumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(25));
        make.top.mas_equalTo(POINT_Y(10));
        make.width.mas_equalTo(POINT_X(120));
        make.height.mas_equalTo(POINT_Y(20));
    }];
    
    _DownLoadBtn = [[UIButton alloc] init];
    [_DownLoadBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:_DownLoadBtn];
    [_DownLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(40));
        make.top.mas_equalTo(POINT_Y(10));
        make.width.mas_equalTo(POINT_X(25));
        make.height.mas_equalTo(POINT_X(25));
    }];
    
    _PaiXuBtn = [[UIButton alloc] init];
    [_PaiXuBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [self addSubview:_PaiXuBtn];
    [_PaiXuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_DownLoadBtn.mas_left).with.offset(-POINT_X(30));
        make.top.mas_equalTo(POINT_Y(10));
        make.width.mas_equalTo(POINT_X(25));
        make.height.mas_equalTo(POINT_X(25));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
