//
//  WTXJHeaderView.m
//  WOTING
//
//  Created by jq on 2016/11/22.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXJHeaderView.h"

#import "WTDTDetailViewController.h"

@implementation WTXJHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    __weak WTXJHeaderView *weakSelf = self;
    //标题
    _NameLab = [[UILabel alloc] init];
    _NameLab.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_NameLab];
    [_NameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(7);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    //更多按钮
    UIView *MoreView = [[UIView alloc] init];
    [self addSubview:MoreView];
    [MoreView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(weakSelf);
        make.top.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
        make.width.mas_equalTo(POINT_X(120));
    }];
    
    UIButton *JianTBtn = [[UIButton alloc] init];
    [JianTBtn setImage:[UIImage imageNamed:@"more.png"] forState:UIControlStateNormal];
    [JianTBtn addTarget:self action:@selector(MoveClick:) forControlEvents:UIControlEventTouchUpInside];
    [MoreView addSubview:JianTBtn];
    [JianTBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(MoreView.mas_right).with.offset(-POINT_X(20));
        make.top.mas_equalTo(7);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    UILabel *MoreLab = [[UILabel alloc] init];
    MoreLab.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(MoveClick:)];
    [MoreLab addGestureRecognizer:tap];
    MoreLab.text = @"更多";
    MoreLab.textAlignment = NSTextAlignmentCenter;
    MoreLab.font = [UIFont boldSystemFontOfSize:14];
    [MoreView addSubview:MoreLab];
    [MoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(JianTBtn.mas_left);
        make.top.mas_equalTo(12);
        make.width.mas_equalTo(POINT_X(80));
        make.height.mas_equalTo(POINT_Y(20));
    }];
    
}

- (void)MoveClick:(id)sened{
    
    WTDTDetailViewController *wtDDVC = [[WTDTDetailViewController alloc] init];
    wtDDVC.hidesBottomBarWhenPushed = YES;
    wtDDVC.nameStr = _NameStr;
    wtDDVC.contentID = _contentId;
    wtDDVC.type = 0;
    [self.delegate.navigationController pushViewController:wtDDVC animated:YES];
}

@end
