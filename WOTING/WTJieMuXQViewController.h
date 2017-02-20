//
//  WTJieMuXQViewController.h
//  WOTING
//
//  Created by jq on 2017/2/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTJieMuXQViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *JieMuDanTab;

@property (nonatomic, copy) NSString *bcId; //节目ID
@property (nonatomic, copy) NSString *timeSp;
@property (nonatomic, strong) NSMutableArray  *dataJMDArr;

@end
