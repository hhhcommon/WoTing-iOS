//
//  WTAddQunFriendController.m
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTAddQunFriendController.h"

#import "SubLBXScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>

#import "LBXScanResult.h"
#import "LBXScanWrapper.h"

#import "WTAddResultViewController.h"   //搜索结果集

@interface WTAddQunFriendController ()

@end

@implementation WTAddQunFriendController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _SearView.layer.cornerRadius = 3;
    _SearView.layer.masksToBounds = YES;

    _contentBtnImg.selected = NO;
    _ToBtn.hidden = NO;
    _SaoYiSaoLab.hidden = NO;
    _SaoYiSaoMingLab.hidden = NO;
    _SearchContentLab.hidden = YES;
    _SearchContentLab.text = @"";
    
    [_SearchTextF addTarget:self action:@selector(SearchChange:) forControlEvents:UIControlEventEditingChanged];
    
    if (_AddQunFriendType == 0) {
        
        _SearchTextF.placeholder = @"昵称/手机号/用户号";
    }else{
        
        _SearchTextF.placeholder = @"群名称/群号";
    }
    
    _SearchResultView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ResultTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToResult)];
    [_SearchResultView addGestureRecognizer:ResultTap];
}

- (void)SearchChange:(UITextField *)textF{
    
    if (textF.text.length > 0) {
        
        _SaoYiSaoLab.hidden = YES;
        _SaoYiSaoMingLab.hidden = YES;
        _SearchContentLab.hidden = NO;
        _SearchContentLab.text = [NSString stringWithFormat:@"搜索: %@", textF.text];
        _ToBtn.hidden = YES;
        _contentBtnImg.selected = YES;
    }else{
        
        _contentBtnImg.selected = NO;
        _ToBtn.hidden = NO;
        _SaoYiSaoLab.hidden = NO;
        _SaoYiSaoMingLab.hidden = NO;
        _SearchContentLab.hidden = YES;
        _SearchContentLab.text = @"";
    }
    
}

- (void)GoToResult{
    
    if (_SearchTextF.text.length > 0) {
        
        WTAddResultViewController *wtAResultVC = [[WTAddResultViewController alloc] init];
        wtAResultVC.SearchStr = _SearchTextF.text;
        if (_AddQunFriendType == 0) {
            
            wtAResultVC.AddResultType = 0;
        }else{
            
            wtAResultVC.AddResultType = 1;
        }
        wtAResultVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtAResultVC animated:YES];
    }else{
        
        //设置扫码区域参数
        LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
        style.photoframeLineW = 3;
        style.photoframeAngleW = 18;
        style.photoframeAngleH = 18;
        style.isNeedShowRetangle = NO;
        
        style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
        
        //qq里面的线条图片
        UIImage *imgLine = [UIImage imageNamed:@"qrcode_scan_light_green.png"];
        
        style.animationImage = imgLine;
        
        
        [self openScanVCWithStyle:style];
   
    }
}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//语音搜索
- (IBAction)SearchBtnClick:(id)sender {
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
