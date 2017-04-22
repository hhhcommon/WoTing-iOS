//
//  WTXiangTingViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiangTingViewController.h"
#import "SubLBXScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>

#import "LBXScanResult.h"
#import "LBXScanWrapper.h"

#import "SKMainScrollView.h"

#import "WTChatController.h"    //聊天
#import "WTContactsController.h"    //通讯录

#import "WTCreateQunController.h" //创建群
#import "WTAddQunFriendController.h"    //添加好友, 群

#import "MLKMenuPopover.h"  //弹出菜单

#define MENU_POPOVER_FRAME  CGRectMake(K_Screen_Width - 145, 64, 140, 176)

@interface WTXiangTingViewController ()<UIScrollViewDelegate, MLKMenuPopoverDelegate>
{
    
    NSMutableArray      *_DataArray;
    SKMainScrollView    *contentScrollView;
    
}
@property(nonatomic,strong) MLKMenuPopover *menuPopover;
@property(nonatomic,strong) NSArray *menuItemsTitle;    //菜单文字
@property(nonatomic,strong) NSArray *menuItemsImgV;     //菜单图片

@end

@implementation WTXiangTingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.menuItemsTitle = [NSArray arrayWithObjects:@"添加好友", @"加入群组", @"创建群组",@"扫 一 扫", nil];
    self.menuItemsImgV = [NSArray arrayWithObjects:@"AddFriend.png", @"JoinQun.png", @"CreatQun.png",@"SaoYiSao.png", nil];
    
    [self initScrollerView];
}

- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height - 64 - 49)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 2, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    _charBtn.selected = YES;
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 2; i ++) {
        
        if (i == 0) {
            
            WTChatController *wtBoFangVC = [[WTChatController alloc] init];
            
            [self addChildViewController:wtBoFangVC];
            [contentScrollView addSubview:wtBoFangVC.view];
            [wtBoFangVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else {
            
            WTContactsController *wtJieMuVC = [[WTContactsController alloc] init];
            
            [self addChildViewController:wtJieMuVC];
            [contentScrollView addSubview:wtJieMuVC.view];
            [wtJieMuVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(K_Screen_Width * i);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }
    }
    
    
    
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        if (scrollView.contentOffset.x == K_Screen_Width) {
            
            _charBtn.selected = NO;
            _TongXunLuBtn.selected = YES;
        }else if (scrollView.contentOffset.x == 0){
            
            _charBtn.selected = YES;
            _TongXunLuBtn.selected = NO;
        }
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

- (IBAction)MoveBtnClick:(id)sender {
    
    [self.menuPopover dismissMenuPopover];
    
    self.menuPopover = [[MLKMenuPopover alloc] initWithFrame:MENU_POPOVER_FRAME menuItems:self.menuItemsTitle AndmenuItemImgv:self.menuItemsImgV];
    
    self.menuPopover.menuPopoverDelegate = self;
    [self.menuPopover showInView:self.view];

}

- (void)openScanVCWithStyle:(LBXScanViewStyle*)style
{
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    //vc.isOpenInterestRect = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)charBtnClick:(id)sender {
    
    if (_charBtn.selected == YES) {
        
        
    }else{
        
        _charBtn.selected = YES;
        _TongXunLuBtn.selected = NO;
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
    }
}

- (IBAction)TongXunLuBtnClick:(id)sender {
    
    if (_TongXunLuBtn.selected == YES) {
        
        
    }else{
        
        _charBtn.selected = NO;
        _TongXunLuBtn.selected = YES;
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
    }
}

#pragma mark MLKMenuPopoverDelegate

- (void)menuPopover:(MLKMenuPopover *)menuPopover didSelectMenuItemAtIndex:(NSInteger)selectedIndex
{
    [self.menuPopover dismissMenuPopover];
    
    if (selectedIndex == 3) {
        
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
        //非正方形
        //        style.isScanRetangelSquare = NO;
        //        style.xScanRetangleOffset = 40;
        
        
        [self openScanVCWithStyle:style];
    }else if (selectedIndex == 2){
        
        WTCreateQunController *creatQVC = [[WTCreateQunController alloc] init];
        creatQVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:creatQVC animated:YES];
        
    }else if (selectedIndex == 1){
        

        
    }else{
        
        WTAddQunFriendController *wtaddQFVC = [[WTAddQunFriendController alloc] init];
        wtaddQFVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtaddQFVC animated:YES];
    }
    
    
}





@end
