//
//  WTFLDetaliController.h
//  WOTING
//
//  Created by jq on 2016/12/14.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBaseViewController.h"

@interface WTFLDetaliController : WTBaseViewController

- (IBAction)balckBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITableView *FLDTableView;

@property (nonatomic, copy) NSString *contentID;
@property (nonatomic, copy) NSString *nameL;

@end
