//
//  ShengYinViewController.h
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBaseViewController.h"

@interface ShengYinViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *SYTableView;

@property (nonatomic, strong) NSMutableArray *dataSYArr;

@property (nonatomic, copy) NSString *SearchStr;
@property (nonatomic, strong) NSMutableArray *dataSYLSArr;

@end
