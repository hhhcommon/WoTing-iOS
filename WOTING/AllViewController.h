//
//  AllViewController.h
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBaseViewController.h"

@interface AllViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *likeTabV;

@property (nonatomic, copy) NSString *SearchStr;

@property (nonatomic, strong) NSMutableArray    *dataAllArray;  //播放历史数据

@end
