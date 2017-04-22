//
//  WTAddResultViewController.h
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTAddResultViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *AddResultTabV;

@property (nonatomic, copy) NSString *SearchStr;    //搜索词

@end
