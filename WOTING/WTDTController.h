//
//  WTDTController.h
//  WOTING
//
//  Created by jq on 2016/12/13.
//  Copyright © 2016年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTDTController : UIViewController

- (IBAction)backClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *detableView;

@property (nonatomic, copy) NSString *type;     //判断是否为城市切换, 传1位城市切换

@end
