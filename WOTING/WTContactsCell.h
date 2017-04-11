//
//  WTContactsCell.h
//  WOTING
//
//  Created by jq on 2017/4/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTContactsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImgv;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *QunNumber;
@property (weak, nonatomic) IBOutlet UILabel *QunBeiZhu;
@property (weak, nonatomic) IBOutlet UIButton *HuJiaobtn;

- (void)setCellWithDict:(NSDictionary *)dict;

@end
