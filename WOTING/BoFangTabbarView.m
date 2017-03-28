//
//  BoFangTabbarView.m
//  WOTING
//
//  Created by jq on 2017/3/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "BoFangTabbarView.h"

#import "MainViewController.h"
#define WWWWW [UIScreen mainScreen].bounds.size.width
#define HHHHH [UIScreen mainScreen].bounds.size.height
@implementation BoFangTabbarView

+ (BoFangTabbarView *)sharedManager
{
    static BoFangTabbarView *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        sharedAccountManagerInstance = [[[NSBundle mainBundle] loadNibNamed:@"BoFangTabbarView" owner:self options:nil] lastObject];
        
//        sharedAccountManagerInstance = [[self alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width/4.00, 49)];
        sharedAccountManagerInstance.HYCContentImageName.layer.masksToBounds = YES;
        
        sharedAccountManagerInstance.HYCContentImageName.layer.cornerRadius = sharedAccountManagerInstance.HYCContentImageName.frame.size.width/2.00;
        
        
    });

    return sharedAccountManagerInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
       
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"BoFangTabbarView" owner:self options:nil] lastObject];
         self.frame = CGRectMake(0, HHHHH - POINT_Y(49), POINT_X(103.5), POINT_Y(49));
        
        self.HYCContentImageName.layer.masksToBounds = YES;
        
        self.HYCContentImageName.layer.cornerRadius = self.HYCContentImageName.frame.size.width/2.00;
        
    }
    return self;
}
//
//- (instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        
//        
//        
//        self = [[[NSBundle mainBundle] loadNibNamed:@"BoFangTabbarView" owner:self options:nil] lastObject];
//        
//        [self viewDidLoadSSSS];
//    }
//    return self;
//}
//
//- (instancetype)HYCcreateSelf:(CGRect)HYCFrame{
//    
//    self.frame = HYCFrame;
//    
//    return self;
//}
//
//- (void)viewDidLoadSSSS{
//    
//    _HYCKuangImageName.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(btnClick:)];
//    [self.HYCKuangImageName addGestureRecognizer:tapGesturRecognizer];
//    
//}
//- (void)btnClick:(UITapGestureRecognizer *)tap{
//    
//    MainViewController *mainTab = [MainViewController sharedManager];
//    [mainTab firstVCClick];
//}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
