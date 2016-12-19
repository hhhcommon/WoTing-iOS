//
//  WTPingLunCell.h
//  WOTING
//
//  Created by jq on 2016/12/17.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTPingLunCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;


- (void)setCellWithDict:(NSDictionary *)dict;

@end
