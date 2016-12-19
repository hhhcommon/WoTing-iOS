//
//  WTDTDetailViewController.h
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDTDetailViewController : UIViewController
- (IBAction)blackBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *NameLab;
@property (weak, nonatomic) IBOutlet UITableView *jqTabView;

@end
