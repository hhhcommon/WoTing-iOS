//
//  BoFangTabbarView.h
//  WOTING
//
//  Created by jq on 2017/3/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BoFangTabbarView : UIView 
+ (BoFangTabbarView *)sharedManager;
//- (BoFangTabbarView *)HYCcreateSelf:(CGRect)HYCFrame;
@property (weak, nonatomic) IBOutlet UIImageView *HYCContentImageName;

@property (weak, nonatomic) IBOutlet UIImageView *HYCKuangImageName;

@property (weak, nonatomic) IBOutlet UIImageView *LJQStopImage;



@end
