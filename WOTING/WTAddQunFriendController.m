//
//  WTAddQunFriendController.m
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTAddQunFriendController.h"

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
        wtAResultVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtAResultVC animated:YES];
    }else{
    
   
    }
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
