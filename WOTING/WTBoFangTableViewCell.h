//
//  WTBoFangTableViewCell.h
//  WOTING
//
//  Created by jq on 2016/11/29.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBoFangTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ContentImg;
@property (weak, nonatomic) IBOutlet UILabel *ContentName;
@property (weak, nonatomic) IBOutlet UILabel *WTLab;
@property (weak, nonatomic) IBOutlet UILabel *PlayCount;
@property (weak, nonatomic) IBOutlet UILabel *ContentTimes;
@property (weak, nonatomic) IBOutlet UIImageView *WTBoFangImgV;


- (void)setCellWithDict:(NSDictionary *)dict;

@end
