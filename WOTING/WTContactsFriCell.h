//
//  WTContactsFriCell.h
//  WOTING
//
//  Created by jq on 2017/4/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTContactsFriCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *FriNumLab;
@property (weak, nonatomic) IBOutlet UILabel *FriBeiZLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ConetNameHe;


@end
