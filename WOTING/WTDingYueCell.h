//
//  WTDingYueCell.h
//  WOTING
//
//  Created by jq on 2017/3/23.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDingYueCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImage;
@property (weak, nonatomic) IBOutlet UILabel *contentName;

@property (weak, nonatomic) IBOutlet UILabel *contentNameLab;
@property (weak, nonatomic) IBOutlet UILabel *contentTime;

@end