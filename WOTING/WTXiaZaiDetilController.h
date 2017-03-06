//
//  WTXiaZaiDetilController.h
//  WOTING
//
//  Created by jq on 2017/3/2.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTXiaZaiDetilController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *contentName;
- (IBAction)backBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *jiLab;
@property (weak, nonatomic) IBOutlet UILabel *sizeLab;
@property (weak, nonatomic) IBOutlet UITableView *XiaZaiDetilTab;

@property (nonatomic, strong) NSDictionary   *dataDict;  //接受过来

@end
