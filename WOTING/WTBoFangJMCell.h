//
//  WTBoFangJMCell.h
//  WOTING
//
//  Created by jq on 2017/1/4.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTBoFangJMCellDelegate <NSObject>

-(void)XianShiBtnClick:(UIButton *)btn;


@end

@interface WTBoFangJMCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *XianSBtn;
- (IBAction)XianSBtnClick:(id)sender;

@property(nonatomic,weak)id<WTBoFangJMCellDelegate> delegate;
@end
