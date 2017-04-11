//
//  WTBianJiZiLiaoController.h
//  WOTING
//
//  Created by jq on 2017/4/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTBianJiZiLiaoController : UIViewController

@property (nonatomic, strong) NSDictionary *dataZLDict;  //个人资料

- (IBAction)backBtnClick:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *ZhangHaoTextF;
@property (weak, nonatomic) IBOutlet UITextField *NikNameTextF;
@property (weak, nonatomic) IBOutlet UIButton *BoyBtn;
@property (weak, nonatomic) IBOutlet UIButton *GirlBtn;
@property (weak, nonatomic) IBOutlet UIButton *birthDayBtn;
@property (weak, nonatomic) IBOutlet UILabel *XingZuoLab;
@property (weak, nonatomic) IBOutlet UIButton *DiQuBtn;

@property (weak, nonatomic) IBOutlet UITextField *EmailTextF;
@property (weak, nonatomic) IBOutlet UITextField *GeXingTextF;
- (IBAction)BoyBtnClick:(id)sender;
- (IBAction)GirlBtnClick:(id)sender;

- (IBAction)birthDayBtnClick:(id)sender;
- (IBAction)DiQuBtnClick:(id)sender;


@end
