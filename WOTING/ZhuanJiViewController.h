//
//  ZhuanJiViewController.h
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBaseViewController.h"

@interface ZhuanJiViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *ZJTableView;

@property (nonatomic, strong) NSMutableArray *dataZJArr;

@property (nonatomic, copy) NSString *SearchStr;
@end
