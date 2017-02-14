//
//  WTBoFangCell.h
//  WOTING
//
//  Created by jq on 2017/1/3.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBoFangModel.h"

typedef enum {
    BtnTypePlay,//播放
    BtnTypePause,//暂停
    BtnTypePrevious,//上一首
    BtnTypeNext,//下一首
    BtnTypeLike,//喜欢
    BtnTypeDownLoad,//下载
    BtnTypeJMD,//节目单
    BtnTypeShare,//分享
    BtnTypeCommit,//评论
    BtnTypeMore,     //更多
    BtnTypeYuYin    //语音搜索
}BtnType;

@class WTBoFangModel,WTBoFangCell;

@protocol WTBoFangViewDelegate <NSObject>

-(void)playerToolBar:(WTBoFangCell *)toolbar btnClickWithType:(BtnType) btnType;

@end

@interface WTBoFangCell : UITableViewCell


- (IBAction)LuKBtnClick:(id)sender;
- (IBAction)YuYinBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *beginBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *beforeBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;  //播放名
@property (weak, nonatomic) IBOutlet UIImageView *ContentImgV;  //图片
- (IBAction)beforeBtnClick:(id)sender; //前一首
- (IBAction)nextBtnClick:(id)sender;    //下一首

@property (weak, nonatomic) IBOutlet UISlider *wtSlider;    //播放条
@property (weak, nonatomic) IBOutlet UILabel *timeLab1;     //当前时间
@property (weak, nonatomic) IBOutlet UILabel *timeLab2;     //总时间
- (IBAction)beginBtnClick:(id)sender;      // 播放/暂停

//喜欢, 下载, 分享, 评论, 更多
- (IBAction)likeBtnClick:(id)sender;
- (IBAction)downLoadBtn:(id)sender;
- (IBAction)shareBtnClick:(id)sender;
- (IBAction)commitBtnClick:(id)sender;
- (IBAction)moreBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *downLoadImgv;
@property (weak, nonatomic) IBOutlet UIButton *downLoadTitImgv;


@property(nonatomic,strong)WTBoFangModel *playingMusic;//当前播放的音乐


/*
 *播放状态 默认暂停状态
 */
@property(assign,nonatomic,getter=isPlaying)BOOL playing;


@property(nonatomic,weak)id<WTBoFangViewDelegate> delegate;
@end
