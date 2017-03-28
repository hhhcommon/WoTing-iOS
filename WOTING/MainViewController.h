//
//  MainViewController.h
//  KitchenProject
//
//  Created by 赵英奎 on 16/1/25.
//  Copyright © 2016年 KK. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MainViewController : UITabBarController

+ (MainViewController *)sharedManager;

- (void)firstVCClick;
@property (nonatomic ,strong)NSString *TabBarNumber;


@property (nonatomic,strong)UINavigationController *tmpNavigationController;
@property (nonatomic,strong)UIImageView *tmpImgV;



@end
