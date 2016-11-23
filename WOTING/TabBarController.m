//
//  TabBarController.m
//  LimiteFree
//
//  Created by jq on 16/1/19.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "TabBarController.h"
#import "Factory.h"

@interface TabBarController ()

{
    //用临时变量记录高亮状态的按钮
    UILabel *_tmpLb;
    UINavigationController *_tmpNavigationController;
    UIImageView *_tmpImgV;
}

@end

@implementation TabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//隐藏系统tabbar上面的子视图
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //获得标签栏上的所有子视图
    NSArray *subViewsArray=self.tabBar.subviews;
    //遍历数组
    for (UIView *view in subViewsArray) {
        view.hidden=YES;
    }
}

//创建导航条按钮,添加到tabbar
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *array=self.viewControllers;
    for (int i=0; i<array.count ; i++) {
        
        UINavigationController *nav=[array objectAtIndex:i];
        //创建图片
        UIImageView *itemImgV=[[UIImageView alloc]initWithFrame:CGRectMake(i*K_Screen_Width/4 + POINT_X(65), POINT_Y(5), K_Screen_Width/4 - POINT_X(130), 49 - POINT_Y(5) - POINT_Y(35))];
        itemImgV.image=nav.tabBarItem.image;
        //将图片添加到标签栏
        [self.tabBar addSubview:itemImgV];
        
        //创建按钮上的文字
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 49 - POINT_Y(35), K_Screen_Width/4 - POINT_X(130), POINT_Y(30))];
        [lb setTextColor:[UIColor orangeColor]];
        lb.text=nav.tabBarItem.title;
        lb.textAlignment=NSTextAlignmentCenter;
        lb.font=[UIFont systemFontOfSize:FONT_SIZE_OF_PX(26)];
        [itemImgV addSubview:lb];
        
        
        
        //设置默认第一个按钮为高亮
        if(i==0)
        {
            itemImgV.image=nav.tabBarItem.selectedImage;
           // [lb setTextColor:[UIColor orangeColor]];
            //将当前高亮的按钮保存临时变量
            _tmpLb=lb;
            _tmpImgV=itemImgV;
            _tmpNavigationController=nav;
            
        }
        
        
        //创建点击手势
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        itemImgV.userInteractionEnabled=YES;
        //为每张图片添加tag
        itemImgV.tag=i+100;
        [itemImgV addGestureRecognizer:tap];
        
        
    }
    
}


-(void)tapClick:(UITapGestureRecognizer *)tap
{
    
    //将临时变量改为低亮
   // [_tmpLb setTextColor:[UIColor blackColor]];
    _tmpImgV.image=_tmpNavigationController.tabBarItem.image;
    
    //将点击的按钮变为高亮
    NSArray *navigationControllerArray=self.viewControllers;
    
    UINavigationController *nav=[navigationControllerArray objectAtIndex:tap.view.tag-100];
    
    UIImageView *imgV=(UIImageView *)tap.view;
    imgV.image=nav.tabBarItem.selectedImage;
    //获得图片上的label
    UILabel *lb=(UILabel *)[imgV.subviews lastObject];
   // [lb setTextColor:[UIColor orangeColor]];
    
    
    //临时变量保存高亮按钮
    _tmpNavigationController=nav;
    _tmpLb=lb;
    _tmpImgV=imgV;
    
    //实现子视图控制器页面的切换
    self.selectedIndex=tap.view.tag-100;
    
    
    
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

@end
