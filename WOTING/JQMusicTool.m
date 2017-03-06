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
    //[12]	(null)	@"ContentPlay" :
    /**
     上海故事广播	http://live-cdn.kksmg.com/channels/tvie/audio_gsgb/flv:fm
     流行音乐广播101.7FM	http://live-cdn.kksmg.com/channels/tvie/audio_101/flv:fm
     东方都市广播-889驾车调频 http://live-cdn.kksmg.com/channels/tvie/audio_dfdt/flv:fm
     流行音乐广播103.7FM    http://live-cdn.kksmg.com/channels/tvie/audio_loveradio/flv:fm
     
     */
    _musicStr = music.ContentPlay;
  //  _musicStr = @"http://live-cdn.kksmg.com/channels/tvie/audio_101/flv:fm";
    
    if ([_musicStr hasSuffix:@"flv"] || [_musicStr hasSuffix:@"flv:fm"]) {
        
        UIView *view = [[UIView alloc] init];
        self.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
        [self.mediaPlayer showMediaPlayer:_musicStr urltype:UrlTypeLive frame:CGRectNull view:view completion:^(NSInteger defaultNum, NSArray *data) {
            if (self.mediaPlayer) {
                
                view.frame = CGRectMake(0, 0, 100, 100);
            }
        }];
//      [self.mediaPlayer.player play];
        
    }else {
        
        if (self.mediaPlayer) {
            
            [self.mediaPlayer.player shutdown];
            self.mediaPlayer = nil;
        }
    
        AVPlayerItem *songItem;
        
        FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
        
        BOOL isRept = NO;
        FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
        // 遍历结果，如果重复就删除数据
        while ([resultSet next]) {
            
            NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
            if ([_musicStr isEqualToString:jsonDict[@"ContentPlay"]]){
                
                isRept = YES;
            }
        }
        if (!isRept) {  //播网络
            
            NSURL *musicURL = [NSURL URLWithString:_musicStr];
            songItem = [[AVPlayerItem alloc] initWithURL:musicURL];
        }else {         //播本地
            //遍历文件夹
            NSString *appDocDir = [[[[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
            
            NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
            for (NSString *aPath in contentOfFolder) {
                NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
                BOOL isDir = NO;
                if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
                {
                    
                    if ([_musicStr hasSuffix:aPath]) {
                        
                      songItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:fullPath]];
                    }
                    
                }
            }
        }
        
        

        if (self.player==nil) {
            
            
            self.player = [[AVPlayer alloc] initWithPlayerItem:songItem];
        } else{
            
            [self.player replaceCurrentItemWithPlayerItem:songItem];
            
        }
    }
    
    
}


-(void)play{
    
    if ([_musicStr hasSuffix:@"flv"] || [_musicStr hasSuffix:@"flv:fm"]) {
    
        [self.mediaPlayer.player play];
        
    }else {
    
        [self.player play];
    }
}


-(void)pause{
    
    if ([_musicStr hasSuffix:@"flv"] || [_musicStr hasSuffix:@"flv:fm"]) {
        
        [self.mediaPlayer.player pause];
        
    }else {
    
        [self.player pause];
    }
}




@end
