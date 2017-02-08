//
//  ProgressCircleView.m
//  circle
//
//  Created by user on 16/12/30.
//  Copyright © 2016年 user. All rights reserved.
//

#import "ProgressCircleView.h"

@implementation ProgressCircleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setProgress:(float)progress{
    _progress = progress;
    if (_progress>1.0) {
        _progress = 1.0;
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    float r = rect.size.height >= rect.size.width ? rect.size.width/2.0 : rect.size.height/2.0;
    CGPoint center = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ref, 2);
    CGContextSetFillColorWithColor(ref, [UIColor orangeColor].CGColor);
    CGContextAddArc(ref, center.x, center.y, r, - M_PI_2, - M_PI_2 + M_PI * 2, 0);
    CGContextStrokePath(ref);
    
    CGContextMoveToPoint(ref, center.x, center.y);
    CGContextSetFillColorWithColor(ref, [UIColor orangeColor].CGColor);
    CGContextAddArc(ref, center.x, center.y, r, - M_PI_2, - M_PI_2 + M_PI * 2 * self.progress, 0);
    
    CGContextFillPath(ref);
    
}



@end
