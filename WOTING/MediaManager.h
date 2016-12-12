//
//  MediaManager.h
//  SuperProject
//
//  Created by 小震GG on 16/2/27.
//  Copyright © 2016年 Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface MediaManager : NSObject

@property (nonatomic, strong) AVPlayer *player;

+ (MediaManager *)sharedInstance;

@end
