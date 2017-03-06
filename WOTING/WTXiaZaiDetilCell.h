//
//  WTXiaZaiDetilCell.h
//  WOTING
//
//  Created by jq on 2017/3/2.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WTXiaZaiDetilCell;
@protocol WTXiaZaiDetilCellDelegate <NSObject>

- (void)CleanClick;

@end

@interface WTXiaZaiDetilCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *contentName;
@property (weak, nonatomic) IBOutlet UILabel *contentPub;
@property (weak, nonatomic) IBOutlet UILabel *jiLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
- (IBAction)cleanBtnClick:(id)sender;

@property (nonatomic, weak) id <WTXiaZaiDetilCellDelegate> delegate;

- (void)setCellwithDict:(NSDictionary *)dict;

@end
