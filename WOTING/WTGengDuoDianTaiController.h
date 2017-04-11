//
//  WTGengDuoDianTaiController.h
//  WOTING
//
//  Created by jq on 2017/4/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTGengDuoDianTaiController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *contentName;

@property (weak, nonatomic) IBOutlet UIButton *XiHuanBtn;
@property (weak, nonatomic) IBOutlet UIButton *XiaZaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *DingYueBtn;
@property (weak, nonatomic) IBOutlet UIButton *WDXiHuan;


- (IBAction)XiHuanBtnClick:(id)sender;

- (IBAction)FenXiangBtnClick:(id)sender;
- (IBAction)PingLunBtnClick:(id)sender;
- (IBAction)JieMuBtnClick:(id)sender;
- (IBAction)ZhuanJiBtnClick:(id)sender;

- (IBAction)DingShiBtnClick:(id)sender;
- (IBAction)JuBaoBtnClick:(id)sender;

- (IBAction)BoFangHistoryBtnClick:(id)sender;
- (IBAction)DingYueBtnClick:(id)sender;
- (IBAction)WoDeXiaZaiBtnClick:(id)sender;
- (IBAction)WoDeXiHuanBtnClick:(id)sender;

- (IBAction)backBtnClick:(id)sender;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PaiXuone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PaiXutwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Paixuthere;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PaiXufour;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *PaiXufive;


@property (nonatomic, strong) NSDictionary *dataDict;   //数据源数组

@end
