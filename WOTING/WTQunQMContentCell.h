//
//  WTQunQMContentCell.h
//  WOTING
//
//  Created by jq on 2017/4/12.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTQunQMContentCellDelegate <NSObject>

-(void)ChangeQMHeight:(NSInteger )integer;

@end

@interface WTQunQMContentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContentLabHeight;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property(nonatomic,weak)id<WTQunQMContentCellDelegate> delegate;

- (void)cellWithString:(NSString *)Str;

@end
