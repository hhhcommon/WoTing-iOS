//
//  WTDownLoadViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTDownLoadViewController.h"
#import "WTYiXiaZaiController.h"
#import "WTXiaZaiZhongController.h"

#import "SKMainScrollView.h"

@interface WTDownLoadViewController ()<UIScrollViewDelegate> {
    
    SKMainScrollView    *contentScrollView;
    NSMutableArray      *dataDownArr;
}

@end

@implementation WTDownLoadViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        dataDownArr = [NSMutableArray arrayWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JiaZaiArray:) name:@"XIAZAIDICT" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;

   
    
    [self initScrollerView];
}

- (void)JiaZaiArray:(NSNotification *)not {
    
    NSDictionary *dict = not.userInfo;
    
    
    [dataDownArr addObject:dict];
    
    [self initScrollerView];
}


- (void)initScrollerView{
    
    //  __weak WTXiangJiangViewController *weakSelf = self;
    contentScrollView = [[SKMainScrollView alloc] initWithFrame:CGRectMake(0, 64, K_Screen_Width, K_Screen_Height -49 - 64)];
    contentScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentScrollView];
    
    // 防止scroll上下拖动
    contentScrollView.contentSize = CGSizeMake(K_Screen_Width * 2, 0);
    contentScrollView.pagingEnabled = YES;
    contentScrollView.bounces = NO;
    contentScrollView.contentOffset = CGPointMake(0, 0);
    _YXZBtn.selected = YES;
    contentScrollView.delegate = self;
    
    for (int i = 0; i < 2; i ++) {
        
        if (i == 0) {
            
            WTYiXiaZaiController *wtTuiJianVC = [[WTYiXiaZaiController alloc] init];
            //  skDongTaiVC.tagArr = sktagArr;
            [self addChildViewController:wtTuiJianVC];
            [contentScrollView addSubview:wtTuiJianVC.view];
            [wtTuiJianVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.width.equalTo(contentScrollView);
                make.height.equalTo(contentScrollView);
                make.left.mas_equalTo(@0);
                make.centerY.equalTo(contentScrollView);
            }];
            
        }else if (i == 1) {
            
            WTXiaZaiZhongController *wtDianTaiVC = [[WTXiaZaiZhongController alloc] init];
            wtDianTaiVC.urls = dataDownArr;
            
            [self addChildViewController:wtDianTaiVC];
            [contentScrollView addSubview:wtDianTaiVC.view];
            [wtDianTaiVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                
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
            
            _YXZBtn.selected = NO;
            _XZZBtn.selected = YES;
        }else if (scrollView.contentOffset.x == 0){
            
            _YXZBtn.selected = YES;
            _XZZBtn.selected = NO;
        }
  
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)XiaoXiBtnClick:(id)sender {
}

- (IBAction)SearchBtnClick:(id)sender {
}
- (IBAction)YXZBtnClick:(id)sender {
    
    if (_YXZBtn.selected == YES) {
        
        
    }else{
        
        _YXZBtn.selected = YES;
        _XZZBtn.selected = NO;
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 0, 0);
    }
}

- (IBAction)XZZBtnClick:(id)sender {
    
    if (_XZZBtn.selected == YES) {
        
        
    }else{
        
        _YXZBtn.selected = NO;
        _XZZBtn.selected = YES;
        contentScrollView.contentOffset = CGPointMake(self.view.bounds.size.width * 1, 0);
    }
}
@end
