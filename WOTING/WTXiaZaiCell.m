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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadProgress:) name:@"RELOADCELLPROGRESS" object:nil];
    
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

- (void)reloadProgress:(NSNotification *)not {
    
    NSDictionary *jqdict = not.userInfo;
    
    if ([dataDict[@"ContentPlay"] isEqualToString:jqdict[@"url"]]) {
        
        _JinDuLab.text = jqdict[@"JinDuLab"];
        circleView.progress = [jqdict[@"Progress"] floatValue];
    }
    
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
                                 
                                 circleView.progress = downloadProgress.fractionCompleted;
                                 
                                 _JinDuLab.text =[NSString stringWithFormat:@"%0.2fMB/%0.2fMB", downloadProgress.completedUnitCount/1024.0/1024, downloadProgress.totalUnitCount/1024.0/1024];
                                 
                             });
                             
                         }
                             path:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                 //
                                 _sizeLab.text = [NSString stringWithFormat:@"%0.2lldMB", response.expectedContentLength];
                                 
                                 NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                                 NSString *path = [cachesPath stringByAppendingPathComponent:response.suggestedFilename];
                                 return [NSURL fileURLWithPath:path];
                             }
                       completion:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                           //此时已在主线程
                       //    downloadView.isSuccess = YES;
                           NSString *path = [filePath path];
                           NSLog(@"************文件路径:%@",path);
                           
                           FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
                           
                           BOOL isRept = NO;
                           FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
                           // 遍历结果，如果重复就删除数据
                           while ([resultSet next]) {
                               
                               NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
                               NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
                               if ([_url isEqualToString:jsonDict[@"ContentPlay"]] && ![resultSet boolForColumn:@"XIAZAIBOOL"]){
                                   
                                   isRept = YES;
                               }
                           }
                           if (isRept) {
                               
                               //先删除, 后添加
                               NSString *deleteSql = [NSString stringWithFormat:@"delete from XIAZAI where XIAZAINum='%@'",dataDict[@"ContentId"]];
                               
                               BOOL isOk = [db executeUpdate:deleteSql];
                               
                               if (isOk) {
                                   NSLog(@"删除数据成功");
                                   
                                       
                                       //通知代理
//                                       if ([self.delegate respondsToSelector:@selector(DownLoadWithPlist:)]) {
//                                           [self.delegate DownLoadWithPlist:_url];
//                                       }
                                 //   [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWEIWANCHENG" object:nil]; //刷新下载中的界面
                                       
                                   
                               }
                               
//                               NSData *data = [NSJSONSerialization dataWithJSONObject:dataDict options:NSJSONWritingPrettyPrinted error:nil];
//                               NSString *sqlInsert = @"insert into XIAZAI values(?,?,?)";
//                               BOOL isYES = [db executeUpdate:sqlInsert, data, dataDict[@"ContentId"], YES];
//                               if (isYES) {
//                                   NSLog(@"添加数据成功");
//                               
//                               
//                               [[NSNotificationCenter defaultCenter] postNotificationName:@"XIAZAIWANCHENG" object:nil];//刷新已下载的界面
//                               }else{
//                                   
//                                   NSLog(@"添加数据失败");
//                               }
                           }
 
                       }];
    
    
}

@end
