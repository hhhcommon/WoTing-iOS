//
//  WTSearchView.m
//  WOTING
//
//  Created by jq on 2017/1/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTSearchView.h"

#import "WTSearchViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

@interface WTSearchView()<SFSpeechRecognitionTaskDelegate>{
    
    UILabel         *labName;
    UIButton        *LuYinBtn;
    UITextField     *textFid;
    
    //标记
    NSInteger       *LabInteger;
}

//录音
@property (nonatomic, strong) AVAudioRecorder *recorder;

@end

@implementation WTSearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];

        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{
    
    __weak WTSearchView *weakSelf = self;
    
    labName = [[UILabel alloc] init];
    labName.text = @"请按住讲话";
    labName.font = [UIFont boldSystemFontOfSize:15];
    [self addSubview:labName];
    [labName mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];
    
    //录音按钮
    LuYinBtn = [[UIButton alloc] init];
    [LuYinBtn addTarget:self action:@selector(endRecord:) forControlEvents:UIControlEventTouchUpInside];
    [LuYinBtn addTarget:self action:@selector(startRecord:) forControlEvents:UIControlEventTouchDown];
    
    [LuYinBtn setImage:[UIImage imageNamed:@"Intercom.png"] forState:UIControlStateNormal];
    [LuYinBtn setImage:[UIImage imageNamed:@"Intercom_der.png"] forState:UIControlStateHighlighted];
    
    [self addSubview:LuYinBtn];
    [LuYinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(weakSelf);
        make.top.equalTo(labName.mas_bottom).with.offset(20);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
    }];
    
    //显示textfiled
    textFid = [[UITextField alloc] init];
    textFid.font = [UIFont systemFontOfSize:15];
    [self addSubview:textFid];
    [textFid mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.equalTo(labName.mas_right).with.offset(20);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(200);
    }];
}

- (AVAudioRecorder *)recorder
{
    if (!_recorder)
    {
        //录音保存路径
        NSURL *fileUrl = [NSURL fileURLWithPath:[self recordPath]];
        
        /*
         initWithURL:录音保存的地址
         settings:录音设置
         */
        _recorder = [[AVAudioRecorder alloc] initWithURL:fileUrl settings:[self recordSettringParamter] error:nil];
    }
    
    return _recorder;
}

/*
 touch up inside 手指松开会触发
 */
- (void)endRecord:(UIButton *)btn {
    
    labName.text = @"请按住讲话";
    
    //停止录音
    [self.recorder stop];
    __weak typeof(self) weakSelf = self;
    //创建语音识别操作类对象
    SFSpeechRecognizer * rec = [[SFSpeechRecognizer alloc]init];
    NSURL *url = [NSURL fileURLWithPath:[weakSelf recordPath]];
    
    //通过一个音频路径创建音频识别请求
    SFSpeechRecognitionRequest * request = [[SFSpeechURLRecognitionRequest alloc]initWithURL:url];
    [rec recognitionTaskWithRequest:request delegate:self];
    
}

/*
 touch down 手指按下会触发
 */
- (void)startRecord:(UIButton *)btn {
    
    labName.text = @"开始语音转换";
    //设置当前为录音模式
    //AVAudioSessionCategoryPlayAndRecord 录音和播放
    //AVAudioSessionCategoryRecord录音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session setActive:YES error:nil];
    
    //准备录音
    [self.recorder prepareToRecord];
    //录音
    [self.recorder record];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//录音设置
- (NSDictionary *)recordSettringParamter
{
    //录音设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    return recordSetting;
}

///录音保存路径
- (NSString *)recordPath
{
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    //    NSLog(@"%@",documentPath);
    return [documentPath stringByAppendingPathComponent:@"test.aac"];
}

#pragma mark - 语音的代理方法-
- (void)speechRecognitionDidDetectSpeech:(SFSpeechRecognitionTask *)task {
    
    NSLog(@"检测到语音");
    
}
// Called for all recognitions, including non-final hypothesis
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didHypothesizeTranscription:(SFTranscription *)transcription {
    NSLog(@"基本完成 语音转换  %@",transcription.formattedString);
    
    
}

// Called only for final recognitions of utterances. No more about the utterance will be reported
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult {
    NSLog(@"完成录音转换   %@",recognitionResult.bestTranscription);
    NSMutableString  *targetString = [[NSMutableString alloc]init];
    
    for (int i = 0 ; i < recognitionResult.bestTranscription.segments.count; i ++) {
        SFTranscriptionSegment *currentSeg = recognitionResult.bestTranscription.segments[i];
        SFTranscriptionSegment *nextSeg = nil;
        if (i != recognitionResult.bestTranscription.segments.count - 1) {
            nextSeg = recognitionResult.bestTranscription.segments[i+1];
        }
        [targetString appendString:currentSeg.substring];
        [targetString appendString:[self appendStringWithTwoTime:currentSeg andEndSegment:nextSeg]];
    }
    
    textFid.text = targetString;
    NSLog(@"%@", targetString);
}

- (NSString *)appendStringWithTwoTime:(SFTranscriptionSegment *)startSegment andEndSegment:(SFTranscriptionSegment *)endSegment {
    NSTimeInterval interval = [self durationWithTwoTime:startSegment andEndSegment:endSegment];
    if (interval > 0.6) {
        return startSegment.substring;
    }else if(interval == 0) {
        return @"";
    }else {
        return @"";
    }
    
}

- (NSTimeInterval)durationWithTwoTime:(SFTranscriptionSegment *)startSegment andEndSegment:(SFTranscriptionSegment *)endSegment {
    if (endSegment == nil) return 0;
    NSTimeInterval startTime =  startSegment.timestamp;
    NSTimeInterval endTime = endSegment.timestamp;
    return  endTime - startTime;
}

// Called when the task is no longer accepting new audio but may be finishing final processing
- (void)speechRecognitionTaskFinishedReadingAudio:(SFSpeechRecognitionTask *)task {
    NSLog(@"不再接受其他任务");
}

// Called when the task has been cancelled, either by client app, the user, or the system
- (void)speechRecognitionTaskWasCancelled:(SFSpeechRecognitionTask *)task {
    
    NSLog(@"任务被取消");
    
}

// Called when recognition of all requested utterances is finished.
// If successfully is false, the error property of the task will contain error information
- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishSuccessfully:(BOOL)successfully {
    
    NSLog(@"转换完成的时候");
    
    if (![textFid.text  isEqual: @""]) {
        
        WTSearchViewController *searchVC = [[WTSearchViewController alloc] init];
        searchVC.searchByText = textFid.text;
        searchVC.hidesBottomBarWhenPushed = YES;
        [self.delegate.navigationController pushViewController:searchVC animated:YES];
    }
    
    
}


@end