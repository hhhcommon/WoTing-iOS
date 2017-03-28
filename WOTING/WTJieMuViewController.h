//
//  WTJieMuViewController.h
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTJieMuViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *JMXQTabV;

@property (nonatomic, strong) NSDictionary   *dataDictJM;
@end
