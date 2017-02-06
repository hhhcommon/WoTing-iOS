//
//  WTXiaZaiDoneCell.h
//  WOTING
//
//  Created by jq on 2016/12/30.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTXiaZaiDoneCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *playConLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;

- (void)setCellWithDict:(NSDictionary *)dict;

@end
