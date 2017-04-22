//
//  WTCreateQunCell.h
//  WOTING
//
//  Created by jq on 2017/4/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTCreateQunCell : UITableViewCell

@property (nonatomic, strong)UIImageView    *contentImageView;  //图片
@property (nonatomic, strong)UILabel    *contentName;       //大字
@property (nonatomic, strong)UILabel    *contentLabel;      //小字


+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
