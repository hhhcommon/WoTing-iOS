//
//  WTQunPsdController.h
//  WOTING
//
//  Created by jq on 2017/4/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTQunPsdController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *YuanPadLab;
@property (weak, nonatomic) IBOutlet UITextField *psdTextFile;
@property (weak, nonatomic) IBOutlet UITextField *SurepsdTextFile;
@property (weak, nonatomic) IBOutlet UIButton *SureBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)SureBtnClick:(id)sender;
- (IBAction)backBtnClick:(id)sender;

@property (nonatomic , strong)void (^PsdChange)(NSString *NewPsd);
@property (nonatomic, copy) NSString *NewPsd;

@property (nonatomic, strong) NSDictionary *dataQunDict;    //当前群内容

@end
