//
//  JQMusicTool.m
//  WOTING
//
//  Created by jq on 2016/12/8.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "JQMusicTool.h"

#import "WTBoFangModel.h"

@interface WTBoFangModel()



@end

@implementation JQMusicTool
singleton_implementation(JQMusicTool)

-(void)prepareToPlayWithMusic:(WTBoFangModel *)music{
    //创建播放器
    
    NSURL *musicURL = [NSURL URLWithString:music.ContentPlay];
    
    AVPlayerItem *songItem = [[AVPlayerItem alloc] initWithURL:musicURL];
    
    if (self.player==nil) {
        self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
    } else{
        [self.player replaceCurrentItemWithPlayerItem:songItem];
    }
    
    
}


-(void)play{
    [self.player play];
}


-(void)pause{
    [self.player pause];
}




@end
