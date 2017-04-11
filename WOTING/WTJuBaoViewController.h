//
//  WTJuBaoViewController.h
//  WOTING
//
//  Created by jq on 2017/3/15.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTJuBaoViewController : UIViewController
- (IBAction)backBtnClick:(id)sender;
- (IBAction)TiJiaoBtnClick:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *JuBaoTableV;
@property (weak, nonatomic) IBOutlet UITextView *JuBaoTextV;

@property (nonatomic, copy) NSString *MediaType;
@property (nonatomic, copy) NSString *ContentId;

@end
