//
//  WTMoveView.m
//  WOTING
//
//  Created by jq on 2017/1/9.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTMoveView.h"

@interface WTMoveView () <UITableViewDelegate, UITableViewDataSource>{
    
    /** 设置ICON */
    NSArray         *iconsArray;
    /** 设置Title */
    NSArray         *titlesArray;
    
    UITableView     *MoveTab;
}

@end

@implementation WTMoveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self creatArr];
        [self initSubviews];
    }
    return self;
}

- (void)creatArr {
    
    iconsArray = [[NSArray alloc] initWithObjects:@"mine_set_icon_about.png",@"mine_icon_app share.png",@"mine_icon_play history.png",@"mine_icon_subscribe.png", nil];
    
    titlesArray = [[NSArray alloc] initWithObjects:@"查看专集",@"查看主播",@"播放历史",@"定时关闭",  nil];
}

- (void)initSubviews{
    
    __weak WTMoveView *weakSelf = self;
    
    UILabel *labName = [[UILabel alloc] init];
    labName.text = @"更多";
    labName.font = [UIFont boldSystemFontOfSize:15];
    labName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.centerX.equalTo(weakSelf.mas_centerX);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];
    
    UIImageView *bagImgV = [[UIImageView alloc] init];
    bagImgV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self addSubview:bagImgV];
    [bagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(labName.mas_bottom).with.offset(10);
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.height.mas_equalTo(1);
    }];
    
    MoveTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 38, K_Screen_Width, 390 - 38 - 40)];
    MoveTab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:MoveTab];
    MoveTab.delegate = self;
    MoveTab.dataSource = self;
    
    //----------------------------------chedan线---------------------------
    UIButton *backBtn = [[UIButton alloc] init];
    backBtn.backgroundColor = [UIColor lightGrayColor];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(MoveTab.mas_bottom).with.offset(10);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(30);
    }];
}

#pragma mark - delegate
- (void)cellTap:(UITapGestureRecognizer *)tap {
    
    if ([self.delegate respondsToSelector:@selector(WTMoveViewTap:)]) {
        
        [self.delegate WTMoveViewTap:tap];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
     //   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor skTitleHighBlackColor];
    }
    
    cell.imageView.image = [UIImage imageNamed:[iconsArray objectAtIndex:indexPath.row]];
    cell.textLabel.text = [titlesArray objectAtIndex:indexPath.row];
    
    cell.userInteractionEnabled = YES;
    cell.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSLog(@"%ld", indexPath.row);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
