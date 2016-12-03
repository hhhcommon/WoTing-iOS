//
//  WTDianTaiTableViewCell.h
//  WOTING
//
//  Created by jq on 2016/12/1.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDianTaiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ContentImg;

@property (weak, nonatomic) IBOutlet UILabel *ContentName;
@property (weak, nonatomic) IBOutlet UILabel *WTLab;
@property (weak, nonatomic) IBOutlet UILabel *PlayCount;

- (void)setCellWithDict:(NSDictionary *)dict;

@end
