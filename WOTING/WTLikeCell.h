//
//  WTLikeCell.h
//  WOTING
//
//  Created by jq on 2016/12/19.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTLikeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *WTLab;
@property (weak, nonatomic) IBOutlet UILabel *PlayCount;

@property (weak, nonatomic) IBOutlet UILabel *contentZJ;



- (void)setCellWithDict:(NSDictionary *)dict;

@end
