//
//  JQMusicTool.h
//  WOTING
//
//  Created by jq on 2016/12/8.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Singleton.h"
#import "UCloudMediaPlayer.h"

@class WTBoFangModel;
@interface JQMusicTool : NSObject
singleton_interface(JQMusicTool)
@property(nonatomic,strong)AVPlayer *player;//播放器
@property(strong, nonatomic) UCloudMediaPlayer *mediaPlayer;//flv播放器
@property (nonatomic, copy) NSString *musicStr;//存路径
/*
 *音乐播放前的准备工作
 */
-(void)prepareToPlayWithMusic:(WTBoFangModel *)music;

/*
 *播放
 */
-(void)play;
/*
 *暂停
 */
-(void)pause;



@end
