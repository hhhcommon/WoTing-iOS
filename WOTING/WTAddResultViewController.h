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

@property (nonatomic, assign) NSInteger AddResultType;  //搜索结果样式
/** 
 AddResultType = 0; 好友
 AddResultType = 1; 群样式
 */

@property (nonatomic, copy) NSString *SearchStr;    //搜索词

@end
