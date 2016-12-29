//
//  WTZJTuijianController.h
//  WOTING
//
//  Created by jq on 2016/12/20.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTZJTuijianController : UIViewController

@property (nonatomic, strong) NSMutableDictionary *dataXQDict;

@property (weak, nonatomic) IBOutlet UIImageView *contentimgXQ;
@property (weak, nonatomic) IBOutlet UILabel *nameLabXQ;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *BQLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ContLabHeight;



@end
