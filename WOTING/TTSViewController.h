//
//  TTSViewController.h
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBaseViewController.h"

@interface TTSViewController : WTBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *TTSTableView;

@property (nonatomic, strong) NSMutableArray *dataTTSArr;

@property (nonatomic, copy) NSString *SearchStr;

@end
