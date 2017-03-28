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
    
 //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProgress:) name:@"RELOADCELLPROGRESS" object:nil];
    
    circleView = [[ProgressCircleView alloc] initWithFrame:CGRectMake(0, 0, _DownloadView.width, _DownloadView.height)];
    circleView.backgroundColor = [UIColor whiteColor];
    [_DownloadView addSubview:circleView];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (JSDownLoadManager *)manager{
//    
//    if (!_manager) {
//        _manager = [[JSDownLoadManager alloc] init];
//    }
//    return _manager;
//}

//- (void)reloadProgress:(NSNotification *)not {
//    
//    NSDictionary *jqdict = not.userInfo;
//    
//    if ([dataDict[@"ContentPlay"] isEqualToString:jqdict[@"url"]]) {
//        
//        _JinDuLab.text = jqdict[@"JinDuLab"];
//        circleView.progress = [jqdict[@"Progress"] floatValue];
//    }
//    
//}

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
    
    MCDownloadReceipt *receipt = [[MCDownloadManager defaultInstance] downloadReceiptForURL:[NSString NULLToString:dict[@"ContentPlay"]]];
    
    receipt.progressBlock = ^(NSProgress * _Nonnull downloadProgress,MCDownloadReceipt *receipt) {
        
        if ([receipt.url isEqualToString:self.url]) {
            circleView.progress = downloadProgress.fractionCompleted ;
            _JinDuLab.text = [NSString stringWithFormat:@"%0.2fm/%0.2fm", downloadProgress.completedUnitCount/1024.0/1024, downloadProgress.totalUnitCount/1024.0/1024];
        }
        
    };
    
}

//开始下载
- (void)changeBeginAndStop {
    
//    if (receipt.state == MCDownloadStateDownloading) {
//        //下载中, 点击暂停
//        [[MCDownloadManager defaultInstance] suspendWithDownloadReceipt:receipt];
//        
//    }else if (receipt.state == MCDownloadStateCompleted) {
//        
//        //下载完成
//    }else {
//        
//        //开始下载
//    }
    
}

@end
