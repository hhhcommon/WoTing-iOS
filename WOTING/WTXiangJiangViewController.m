//
//  WTXiangJiangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiangJiangViewController.h"

#import "WTNewsViewController.h"
#import "WTSearchViewController.h"

#import "WTBoFangViewController.h"
#import "WTJieMuViewController.h"


#import "SKMainScrollView.h"

@interface WTXiangJiangViewController ()<UIScrollViewDelegate>
{
    
    NSMutableArray      *_DataArray;
    SKMainScrollView    *contentScrollView;
}

@end

@implementation WTXiangJiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _DataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ScrollerViewChange) name:@"TABLEVIEWCLICK" object:nil];
    
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
    _BoFangBtn.selected = YES;
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 2; i ++) {
        
        if (i == 0) {
            
            WTBoFangViewController *wtBoFangVC = [[WTBoFangViewController alloc] init];
          
            [self addChildViewController:wtBoFangVC];
            [contentScrollView addSubview:wtBoFangVC.view];
            [wtBoFangVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else {
            
            WTJieMuViewController *wtJieMuVC = [[WTJieMuViewController alloc] init];
           
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图左右切换
/** scrollView左右滑动 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 如果滑动的ScrollView是contentScrollView，则通过判断偏移量，设置当前菜单选中状态 */
    if (scrollView == contentScrollView) {
        
        if (scrollView.contentOffset.x == K_Screen_Width) {
            
            _BoFangBtn.selected = NO;
            _JieMuBtn.selected = YES;
        }else if (scrollView.contentOffset.x == 0){
            
            _BoFangBtn.selected = YES;
            _JieMuBtn.selected = NO;
        }
    }
}

//点击事件, 切换到播放页
- (void)ScrollerViewChange {
    
    contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)XiaoXibtnClick:(id)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    WTNewsViewController *wtnewVC = [[WTNewsViewController alloc] init];
    
    [self.navigationController pushViewController:wtnewVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}

- (IBAction)SearchBtnClick:(id)sender {
    
    self.hidesBottomBarWhenPushed=YES;
    WTSearchViewController *wtSearVC = [[WTSearchViewController alloc] init];
    
    [self.navigationController pushViewController:wtSearVC animated:YES];
    self.hidesBottomBarWhenPushed=NO;
}
- (IBAction)BoFangBtnClick:(id)sender {
    
    if (_BoFangBtn.selected == YES) {
        
        
    }else{
        
        _BoFangBtn.selected = YES;
        _JieMuBtn.selected = NO;
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
    }
}

- (IBAction)JieMuBtnClick:(id)sender {
    
    if (_JieMuBtn.selected == YES) {
        
        
    }else{
        
        _BoFangBtn.selected = NO;
        _JieMuBtn.selected = YES;
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
    }
    
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
