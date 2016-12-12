//
//  WTBoFangView.m
//  WOTING
//
//  Created by jq on 2016/12/6.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangView.h"
#import "JQMusicTool.h"

@interface WTBoFangView()

@property(assign,nonatomic,getter=isDragging)BOOL dragging;//是否正在拖拽



@end

@implementation WTBoFangView


+(instancetype)creatXib{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"WTBoFangView" owner:nil options:nil]lastObject];
}

#pragma mark 设置当前播放的音乐，并显示数据
-(void)setPlayingMusic:(WTBoFangModel *)playingMusic{
    _playingMusic = playingMusic;
    
    
    //歌曲名
    self.nameLab.text = playingMusic.ContentName;
    
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
    //参数二：队列 dispatch_get_main_queue主队列
    //参数三：block
    //block是一个对象
    //self->player
    //player的block->self强引用
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


//前一首
- (IBAction)beforeBtnClick:(id)sender {
    
    [self notifyDelegateWithBtnType:BtnTypePrevious];
}
//下一首
- (IBAction)nextBtnClick:(id)sender {
    
    [self notifyDelegateWithBtnType:BtnTypeNext];
}
//播放.暂停
- (IBAction)beginBtnClick:(id)sender {
    
    UIButton  *button = (UIButton*)sender;
    //更改播放状态
    self.playing = !self.playing;
    if (self.playing) {//播放音乐
        NSLog(@"播放音乐");
        //1.如果是播放的状态，按钮的图片更改为暂停的状态
        
        button.selected = YES;
        [self notifyDelegateWithBtnType:BtnTypePlay];
    }else{//暂停音乐
        NSLog(@"暂停音乐");
        //2.如果当前是暂停的状态，按钮的图片更改为播放的状态

        button.selected = NO;
        [self notifyDelegateWithBtnType:BtnTypePause];
    }
}

//路况按钮点击事件
- (IBAction)LuKBtnClick:(id)sender {
}

//语音按钮点击事件
- (IBAction)YuYinBtnClick:(id)sender {
}

-(void)awakeFromNib{
    //设置slider 按钮的图片
    [super awakeFromNib];
    [self.wtSlider setThumbImage:[UIImage imageNamed:@"progressbar_circular.png"] forState:UIControlStateNormal];

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
}
//当值发生变化一直触发
-(void)valueChange:(UISlider *)slider{
    [[JQMusicTool sharedJQMusicTool].player pause];
    
    
    //    self.player.currentItem.currentTime.value
    CMTime currentTime = CMTimeMake([JQMusicTool sharedJQMusicTool].player.currentItem.duration.value * slider.value, [JQMusicTool sharedJQMusicTool].player.currentItem.duration.timescale);
    
    //seekToTime 跳到指定的播放时间
    [[JQMusicTool sharedJQMusicTool].player seekToTime:currentTime];
}

- (void)dealloc {
    
    [[JQMusicTool sharedJQMusicTool].player removeObserver:self forKeyPath:@"status"];
    
}



@end
