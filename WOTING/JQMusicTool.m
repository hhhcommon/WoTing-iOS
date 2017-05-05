//
//  JQMusicTool.m
//  WOTING
//
//  Created by jq on 2016/12/8.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "JQMusicTool.h"

#import "WTBoFangModel.h"

#import "SUResourceLoader.h"

@interface JQMusicTool()<SULoaderDelegate>

@property (nonatomic, strong)AVPlayerItem *currentItem;
@property (nonatomic, strong)SUResourceLoader * resourceLoader;

@end

@implementation JQMusicTool
singleton_implementation(JQMusicTool)

-(void)prepareToPlayWithMusic:(WTBoFangModel *)music{
    //创建播放器
    
    _musicStr = music.ContentPlay;

    
    if ([_musicStr hasSuffix:@"flv"] || [_musicStr hasSuffix:@"flv:fm"]) {
        
        UIView *view = [[UIView alloc] init];
        self.mediaPlayer = [UCloudMediaPlayer ucloudMediaPlayer];
        [self.mediaPlayer showMediaPlayer:_musicStr urltype:UrlTypeLive frame:CGRectNull view:view completion:^(NSInteger defaultNum, NSArray *data) {
            if (self.mediaPlayer) {
                
                view.frame = CGRectMake(0, 0, 100, 100);
            }
        }];
        
        
    }else {
        
        if (self.mediaPlayer) {
            
            [self.mediaPlayer.player shutdown];
            self.mediaPlayer = nil;
        }
        
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

            //有缓存播放缓存文件
            NSString * cacheFilePath = [SUFileHandle cacheFileExistsWithURL:musicURL];
            if (cacheFilePath) {
                
                NSURL * url = [NSURL fileURLWithPath:cacheFilePath];
                self.currentItem = [AVPlayerItem playerItemWithURL:url];
                NSLog(@"有缓存，播放缓存文件");
            }else {
                
                if ([_musicStr containsString:@"m3u8"]) { //电台
                    
                    self.currentItem = [AVPlayerItem playerItemWithURL:musicURL];
                    
                }else{  //节目
                
                    self.resourceLoader = [[SUResourceLoader alloc] init];
                    self.resourceLoader.delegate = self;
                    
                    AVURLAsset * asset = [AVURLAsset URLAssetWithURL:musicURL options:nil];
                    [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
                    self.currentItem = [AVPlayerItem playerItemWithAsset:asset];
                }
            }

        }else {  //播本地
            //遍历文件夹
            NSString *appDocDir = [[[[NSFileManager defaultManager] URLsForDirectory: NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
            NSString *appDocDir1 = [NSString stringWithFormat:@"%@/MCDownloadCache",appDocDir];
            NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir1 error:NULL];
            for (NSString *aPath in contentOfFolder) {
                NSString * fullPath = [appDocDir1 stringByAppendingPathComponent:aPath];
                BOOL isDir = NO;
                if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
                {
                    
                    if ([_musicStr hasSuffix:aPath]) {
                        
                      self.currentItem = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:fullPath]];
                    }
                    
                }
            }
        }
        
        

        if (self.player==nil) {
            
            
            self.player = [[AVPlayer alloc] initWithPlayerItem:self.currentItem];
        } else{
            
                
            [self.player replaceCurrentItemWithPlayerItem:self.currentItem];
            
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
