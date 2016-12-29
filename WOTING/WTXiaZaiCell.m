//
//  WTXiaZaiCell.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiaZaiCell.h"
#import "JSDownloadView.h"
#import "JSDownLoadManager.h"

@interface WTXiaZaiCell()<JSDownloadAnimationDelegate>
{
    NSDictionary *dataDict;
    JSDownloadView *downloadView;
}

@property (nonatomic, strong) JSDownLoadManager *manager;

@end

@implementation WTXiaZaiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    downloadView = [[JSDownloadView alloc] init];
    downloadView.progressWidth = 4;
    downloadView.delegate = self;
    [_DownloadView addSubview:downloadView];
    
    [downloadView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_DownloadView);
        make.bottom.equalTo(_DownloadView);
        make.left.equalTo(_DownloadView);
        make.right.equalTo(_DownloadView);
    }];
    
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
    
}

- (void)setUrl:(NSString *)url {
    _url = url;
    
}

//开始下载
- (void)changeBeginAndStop {
    
    [self.manager downloadWithURL:_url
                         progress:^(NSProgress *downloadProgress) {
                             
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 NSString *progressString  = [NSString stringWithFormat:@"%.2f",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
                                 downloadView.progress = progressString.floatValue;
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
                           downloadView.isSuccess = YES;
                           NSString *path = [filePath path];
                           NSLog(@"************文件路径:%@",path);
                           
                           //通知代理
                           if ([self.delegate respondsToSelector:@selector(cell:)]) {
                               [self.delegate cell:[[WTXiaZaiCell alloc] init]];
                           }
                       }];
    
    
}

#pragma mark -  animation delegate

- (void)animationStart{
    
    [self changeBeginAndStop];
}

- (void)animationSuspend{
    
    [self.manager suspend];
}

- (void)animationEnd{
    
    
}

@end
