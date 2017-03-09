//
//  WTXiaZaiCell.h
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class WTXiaZaiCell;
//@protocol WTXiaZaiCellDelegate <NSObject>
//
//- (void)DownLoadWithPlist:(NSString *)str;
//
//@end

@interface WTXiaZaiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *playConLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UILabel *JinDuLab;
@property (weak, nonatomic) IBOutlet UIView *DownloadView;

//@property (nonatomic, weak) id <WTXiaZaiCellDelegate> delegate;
@property (nonatomic,copy)NSString *url;

- (void)Content:(NSDictionary *)dict;
- (void)changeBeginAndStop;
@end
