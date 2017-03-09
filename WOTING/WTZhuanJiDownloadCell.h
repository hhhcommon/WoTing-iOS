//
//  WTZhuanJiDownloadCell.h
//  WOTING
//
//  Created by jq on 2017/3/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTZhuanJiDownloadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UIButton *XuanZeBtn;


- (void)setCellWithDict:(NSDictionary *)dict;

@end
