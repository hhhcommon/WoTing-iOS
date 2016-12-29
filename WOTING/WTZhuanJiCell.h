//
//  WTZhuanJiCell.h
//  WOTING
//
//  Created by jq on 2016/12/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTZhuanJiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UILabel *time2Lab;

- (void)setCellWithDict:(NSDictionary *)dict;

@end
