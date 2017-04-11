//
//  WTBoFangCell.m
//  WOTING
//
//  Created by jq on 2017/1/3.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTBoFangCell.h"
#import "JQMusicTool.h"
#import "CBAutoScrollLabel.h"

#import "UCloudMediaPlayer.h"

@interface WTBoFangCell(){
    
    CBAutoScrollLabel *labelName;   //滚动lab
}

@property(assign,nonatomic,getter=isDragging)BOOL dragging;//是否正在拖拽

@property(strong, nonatomic) UCloudMediaPlayer *mediaPlayer;

@property (nonatomic, assign) int FIRSTBFANG;  //是否是第一次播放


@end

@implementation WTBoFangCell


#pragma mark 设置当前播放的音乐，并显示数据
-(void)setPlayingMusic:(WTBoFangModel *)playingMusic{
    _playingMusic = playingMusic;
    BOOL isXIAZAI = NO;
//    _downLoadImgv.enabled = YES;
//    _downLoadTitImgv.enabled = YES;
    
    //判断本地数据库里是否下载该节目
    FMDatabase *fm = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
    // 1.执行查询语句
    FMResultSet *resultSet = [fm executeQuery:@"SELECT * FROM XIAZAI"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        
        if ([playingMusic.ContentId isEqualToString:jsonDict[@"ContentId"]]) {
            
            isXIAZAI = YES;
        }
    }
    
    //判断是节目单还是去下载界面
    NSString *MediaType = playingMusic.MediaType;
    if ([MediaType isEqualToString:@"AUDIO"]) {
        
//        _downLoadImgv.selected = NO;
//        _downLoadTitImgv.selected = NO;
        self.wtSlider.userInteractionEnabled = YES;
        if (isXIAZAI) {
            
//            _downLoadImgv.enabled = NO;
//            _downLoadTitImgv.enabled = NO;
        }
    }else if ([MediaType isEqualToString:@"RADIO"]) {
        
//        _downLoadImgv.selected = YES;
//        _downLoadTitImgv.selected = YES;
        self.wtSlider.userInteractionEnabled = NO;
        
    }
    
    //判断当前播放是否添加过喜欢
    NSString *ContentFavorite = playingMusic.ContentFavorite;
    if ([ContentFavorite isEqualToString:@"0"]) {
        
//        _likeImgv.selected = NO;
//        _likeTitImgv.selected = NO;
    }else{
        
//        _likeImgv.selected = YES;
//        _likeTitImgv.selected = YES;
    }
    
    //歌曲名
    self.nameLab.text = playingMusic.ContentName;
    self.nameLab.hidden = YES;
    __weak WTBoFangCell *weakSelf = self;
    if (!labelName) {
        
        labelName = [[CBAutoScrollLabel alloc] init];
        //19 14 8 26
        [self addSubview:labelName];
        [labelName mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(_LuKuangBtn.mas_right).with.offset(19);
            make.top.equalTo(weakSelf.mas_top).with.offset(14);
            make.right.equalTo(_YuYinBtn.mas_left).with.offset(-8);
            make.height.mas_equalTo(26);
        }];
    }
    
    labelName.text = playingMusic.ContentName;
    
    labelName.textColor = [UIColor blackColor];
    labelName.labelSpacing = 35; // distance between start and end labels
    labelName.pauseInterval = 2; // seconds of pause before scrolling starts again
    labelName.scrollSpeed = 30; // pixels per second
    labelName.textAlignment = NSTextAlignmentCenter; // centers text when no auto-scrolling is applied
    labelName.fadeLength = 12.f;
    
    
    //歌曲图片
    [self.ContentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:playingMusic.ContentImg]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //设置总时间
    NSTimeInterval time=[playingMusic.ContentTimes doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    self.timeLab2.text = currentDateStr;
    
    
    [self setProgressSlider];
    
    [self createPlayer];
    
    
}

- (void)createPlayer{
    
    __weak __typeof(self) weakSelf = self;
    
    //每隔 30/30在主线程 调用一次block
    //参数一：表示时间的结构体，（30，30） 代表1s ,(60,30) 2s
    //强强引用造成了 循环引用，内存泄露
    [[JQMusicTool sharedJQMusicTool].player addPeriodicTimeObserverForInterval:CMTimeMake(30, 30) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        //获得总的播放时间
        CGFloat totalValue = [JQMusicTool sharedJQMusicTool].player.currentItem.duration.value*1.0/[JQMusicTool sharedJQMusicTool].player.currentItem.duration.timescale;
        //获得当前的播放时间
        CGFloat currentValue = [JQMusicTool sharedJQMusicTool].player.currentItem.currentTime.value*1.0/[JQMusicTool sharedJQMusicTool].player.currentItem.currentTime.timescale+0.5;
        
        //更改slider滑块的值
        weakSelf.wtSlider.value = currentValue*1.0/totalValue;
        //更改timlabel的值
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"mm:ss"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:currentValue];
        
        NSString *str = [df stringFromDate:date];
        
        weakSelf.timeLab1.text = str;
        
        
    }];
    //self.player增加观察者，让self观察status的状态
    [[JQMusicTool sharedJQMusicTool].player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    // 注册打断通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:session];
    
}

#pragma mark -- 监听事件
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //观察到了player.status值的变化
    if ([keyPath isEqualToString:@"status"]) {
        switch ([JQMusicTool sharedJQMusicTool].player.status) {
                //资源准备好播放
            case AVPlayerStatusReadyToPlay:
            {
                self.beginBtn.enabled = YES;
                
            }
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -- 打断事件

- (void)AVAudioSessionInterruptionNotification: (NSNotification *)notificaiton {
    NSLog(@"%@", notificaiton.userInfo);
    
    AVAudioSessionInterruptionType type = [notificaiton.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        
        [[JQMusicTool sharedJQMusicTool].player pause];
        _beginBtn.selected = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZANTINGDONGHUA" object:nil];   //暂停动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPTIME" object:nil];     //旋转动画暂停
    } else {
        [[JQMusicTool sharedJQMusicTool].player play];
        _beginBtn.selected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];     //旋转动画开始
    }
}


//前一首
- (IBAction)beforeBtnClick:(id)sender {
    
    [self notifyDelegateWithBtnType:BtnTypePrevious];
    //还原动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESTORETIME" object:nil];
    _beginBtn.selected = YES;
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRGINBTNYES" object:nil];  //入库
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];     //旋转动画开始
    
}
//下一首
- (IBAction)nextBtnClick:(id)sender {
    
    //切换之前, 存当前播放时间
    
    
    [self notifyDelegateWithBtnType:BtnTypeNext];
    //还原动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESTORETIME" object:nil];
    _beginBtn.selected = YES;
        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRGINBTNYES" object:nil];  //入库
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];     //旋转动画开始
    
}
//播放.暂停
- (IBAction)beginBtnClick:(id)sender {
    
 //   UIButton  *button = (UIButton*)sender;
    
    
    if (_beginBtn.selected == NO) {//播放音乐
        NSLog(@"播放音乐");
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        
        _beginBtn.selected = YES;
//        [self notifyDelegateWithBtnType:BtnTypePlay];
        [[JQMusicTool sharedJQMusicTool].player play];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BRGINBTNYES" object:nil];      //入库
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];     //旋转动画开始
    }else{//暂停音乐
        NSLog(@"暂停音乐");
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态
        
        _beginBtn.selected = NO;
//        [self notifyDelegateWithBtnType:BtnTypePause];
        [[JQMusicTool sharedJQMusicTool].player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ZANTINGDONGHUA" object:nil];   //暂停动画
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPTIME" object:nil];     //旋转动画暂停
    }
}

//路况按钮点击事件
- (IBAction)LuKBtnClick:(id)sender {
}

//语音按钮点击事件
- (IBAction)YuYinBtnClick:(id)sender {
    
    [self notifyDelegateWithBtnType:BtnTypeYuYin];
}

-(void)awakeFromNib{
    //设置slider 按钮的图片
    [super awakeFromNib];
    [self.wtSlider setThumbImage:[UIImage imageNamed:@"progressLJQ.png"] forState:UIControlStateNormal];
    [self.wtSlider setThumbImage:[UIImage imageNamed:@"progressLJQ.png"] forState:UIControlStateHighlighted];
    
    
}





//通知代理
-(void)notifyDelegateWithBtnType:(BtnType)btnType{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(playerToolBar:btnClickWithType:)]) {
        [self.delegate playerToolBar:self btnClickWithType:btnType];
    }
    
}

#pragma mark -- 设置进度条
- (void)setProgressSlider{
    
    [self.wtSlider addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wtSlider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark -- progress事件
//当手指弹起的时候触发
-(void)touchUp:(UISlider *)slider{
    [[JQMusicTool sharedJQMusicTool].player play];
    _beginBtn.selected = YES;
}
//当值发生变化一直触发
-(void)valueChange:(UISlider *)slider{
    [[JQMusicTool sharedJQMusicTool].player pause];
    
    
    //    self.player.currentItem.currentTime.value
    CMTime currentTime = CMTimeMake([JQMusicTool sharedJQMusicTool].player.currentItem.duration.value * slider.value, [JQMusicTool sharedJQMusicTool].player.currentItem.duration.timescale);
    
    //seekToTime 跳到指定的播放时间
    [[JQMusicTool sharedJQMusicTool].player seekToTime:currentTime];
    
    _beginBtn.selected = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BRGINBTNYES" object:nil];      //入库
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BOFANGDONGHUA" object:nil];    //播放动画
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BENGINTIME" object:nil];     //旋转动画开始
}

- (void)dealloc {
    
    [[JQMusicTool sharedJQMusicTool].player removeObserver:self forKeyPath:@"status"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (IBAction)GengDuoBtnClick:(id)sender {
    
    [self notifyDelegateWithBtnType:BtnTypeMore];
}
@end
