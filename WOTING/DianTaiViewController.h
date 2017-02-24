//
//  DianTaiViewController.h
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBaseViewController.h"

@interface DianTaiViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *DTTableView;

@property (nonatomic, strong) NSMutableArray *dataDTArr;

@property (nonatomic, copy) NSString *SearchStr;
@property (nonatomic, strong) NSMutableArray *dataDTLSArr;

@end
