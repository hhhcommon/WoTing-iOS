//
//  WTXiaZaiCell.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiaZaiCell.h"
#import "ProgressCircleView.h"
#import "JSDownLoadManager.h"

@interface WTXiaZaiCell()
{
    NSDictionary *dataDict;
    ProgressCircleView *circleView;
}

@property (nonatomic, strong) JSDownLoadManager *manager;

@end

@implementation WTXiaZaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    circleView = [[ProgressCircleView alloc] initWithFrame:CGRectMake(0, 0, _DownloadView.width, _DownloadView.height)];
    circleView.backgroundColor = [UIColor whiteColor];
    [_DownloadView addSubview:circleView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (JSDownLoadManager *)manager{
    
    if (!_manager) {
        _manager = [[JSDownLoadManager alloc] init];
    }
    return _manager;
}


- (void)Content:(NSDictionary *)dict {
    
    dataDict = dict;
    
    //图片
    [_contentImg sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //标题
    _nameLab.text =[NSString NULLToString:dict[@"ContentName"]];
    
    //我听
    _playConLab.text =[NSString NULLToString:dict[@"ContentPub"]];
    
    //听众
    _numberLab.text = [NSString NULLToString:dict[@"PlayCount"]];
    
    _url = [NSString NULLToString:dict[@"ContentPlay"]];
}

//开始下载
- (void)changeBeginAndStop {
    
    [self.manager downloadWithURL:_url
                         progress:^(NSProgress *downloadProgress) {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSString *progressString  = [NSString stringWithFormat:@"%.2f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
                                 circleView.progress = progressString.floatValue;
                                 _JinDuLab.text = [NSString stringWithFormat:@"%.2lldKB", downloadProgress.completedUnitCount];
                             });
                             
                         }
                             path:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                 //
                                 NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                 NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
                                 return [NSURL fileURLWithPath:path];
                             }
                       completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                           //此时已在主线程
                       //    downloadView.isSuccess = YES;
                           NSString *path = [filePath path];
                           NSLog(@"************文件路径:%@",path);
                           
                           //通知代理
                           if ([self.delegate respondsToSelector:@selector(DownLoadWithPlist:)]) {
                               [self.delegate DownLoadWithPlist:_url];
                           }
                       }];
    
    
}

@end
