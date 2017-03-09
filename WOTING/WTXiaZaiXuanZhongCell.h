//
//  WTXiaZaiXuanZhongCell.h
//  WOTING
//
//  Created by jq on 2017/3/2.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTXiaZaiXuanZhongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *contentPub;
@property (weak, nonatomic) IBOutlet UILabel *JiLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UIButton *XuanZhongBtn;

@property (nonatomic, strong) NSNumber *CellNumber;


- (void)setCellWithDict:(NSDictionary *)dict;

@end
