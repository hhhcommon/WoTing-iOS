//
//  WTMoveView.h
//  WOTING
//
//  Created by jq on 2017/1/9.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTMoveViewDelegate <NSObject>

-(void)WTMoveViewTap:(UITapGestureRecognizer *)tap;

@end

@interface WTMoveView : UIView

@property(nonatomic,weak)id<WTMoveViewDelegate> delegate;

@end
