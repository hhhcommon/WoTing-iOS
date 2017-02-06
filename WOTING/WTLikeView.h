//
//  WTLikeView.h
//  WOTING
//
//  Created by jq on 2017/1/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WTLikeViewDelegate <NSObject>

-(void)likeNSNotification:(NSString *)str;

@end

@interface WTLikeView : UIView

@property (nonatomic, strong) UILabel *NameLab;
@property (nonatomic, copy) NSString *contentId;
@property (nonatomic, copy) NSString *NameStr;

@property(nonatomic,weak)id<WTLikeViewDelegate> delegate;

@end
