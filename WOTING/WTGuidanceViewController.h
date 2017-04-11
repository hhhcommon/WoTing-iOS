//
//  WTGuidanceViewController.h
//  WOTING
//
//  Created by jq on 2017/3/28.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GuidanceViewDelegate<NSObject>
- (void)changeRootViewController;
@end
@interface WTGuidanceViewController : UIViewController

@property (nonatomic,weak)id<GuidanceViewDelegate>delegate;

@end
