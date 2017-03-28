//
//  WTBoFangViewController.h
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBoFangViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *JQtableView;
- (IBAction)NewBtnClick:(id)sender;
- (IBAction)searchBtnClick:(id)sender;


@end
