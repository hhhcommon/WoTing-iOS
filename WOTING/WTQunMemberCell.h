//
//  WTQunMemberCell.h
//  WOTING
//
//  Created by jq on 2017/4/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *QunMemberContectionV;

@property (nonatomic, strong) NSMutableArray *dataQunMemArr;
@property (nonatomic, strong) NSDictionary   *dataQunDedict;
@property (nonatomic, weak) UIViewController *delegateQunMem;

@end
