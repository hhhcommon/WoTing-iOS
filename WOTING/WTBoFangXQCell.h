//
//  WTBoFangXQCell.h
//  WOTING
//
//  Created by jq on 2017/1/5.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBoFangModel.h"

@protocol WTBoFangXQCellDelegate <NSObject>

-(void)ChangeHeight:(NSInteger )integer;

@end

@interface WTBoFangXQCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ZhuBoLab;
@property (weak, nonatomic) IBOutlet UILabel *ZhuanJILab;
@property (weak, nonatomic) IBOutlet UILabel *fromLab;
@property (weak, nonatomic) IBOutlet UILabel *ContentLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentHeight;

@property(nonatomic,weak)id<WTBoFangXQCellDelegate> delegate;

- (void)setDictWithCell:(WTBoFangModel *)model;

@end
