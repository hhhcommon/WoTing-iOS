//
//  MediaManager.m
//  SuperProject
//
//  Created by 小震GG on 16/2/27.
//  Copyright © 2016年 Zhen. All rights reserved.
//

#import "MediaManager.h"

static MediaManager *sharedInstance = nil;

@interface  MediaManager (){
    
    AVAudioPlayer *audioPlayer;
}

@end

@implementation MediaManager

-(id)init{
    if(self = [super init]){
    }
    return self;
}
+(MediaManager *)sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[[self class] alloc] init];
        sharedInstance.player = [[AVPlayer alloc] initWithPlayerItem:nil];
    }
    return sharedInstance;
}



@end
