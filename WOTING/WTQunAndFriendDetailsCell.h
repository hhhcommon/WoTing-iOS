//
//  WTQunAndFriendDetailsCell.h
//  WOTING
//
//  Created by jq on 2017/4/22.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunAndFriendDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImgV;
@property (weak, nonatomic) IBOutlet UIButton *DuiJiangBtn;
@property (weak, nonatomic) IBOutlet UIButton *BianjiBtn;

@property (weak, nonatomic) IBOutlet UILabel *BeiZhuLab;

@property (weak, nonatomic) IBOutlet UILabel *DetailsLab;
@property (weak, nonatomic) IBOutlet UILabel *NickLab;
@property (weak, nonatomic) IBOutlet UITextField *BeiZhuTextF;
@property (weak, nonatomic) IBOutlet UITextField *NickTextF;



@end
