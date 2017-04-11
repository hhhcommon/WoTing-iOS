//
//  MainViewController.m
//  KitchenProject
//
//  Created by jq on 16/1/25.
//  Copyright © 2016年 KK. All rights reserved.
//

#import "MainViewController.h"
#import "BoFangTabbarView.h"
#import "AppDelegate.h"
#import "WTFLDetaliController.h"
@interface MainViewController ()
{
    //用临时变量记录高亮状态的按钮
    UILabel *_tmpLb;
    
    BoFangTabbarView *firstBarV;    
//    BOOL    isTransForm;
    int  count; //旋转角度
    
    BOOL   isPret;  //判断是否第一次加载
}

@property (nonatomic,assign)CGAffineTransform startTransform; //记录最开始contentImg的旋转位置
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)NSTimer *HYCOFFAPPtimer;
//定时器属性


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPret = NO;
    count = 0;
    _TabBarNumber = @"0";
    
    self.tabBar.backgroundImage = [UIImage imageNamed:@"tab_bg.png"];
    
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(firstVCClick) name:@"TABBARSELECATE" object:nil];
    
     _HYCOFFAPPtimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionHYC) userInfo:nil repeats:YES];
}

#define mark --timer
- (void)actionHYC {
    
    
    
    
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    
    dateFormatter.dateFormat=@"dd:HH:mm:ss";//指定转date得日期格式化形式
    
    
    
    
    
    NSArray *arrayHYCTime = [
                             
                             [self dateTimeDifferenceWithStartTime:[dateFormatter stringFromDate:[NSDate date]] endTime:[udf objectForKey:KEYHYC_______HYCKEY]]
                             
                             componentsSeparatedByString:@":"];
    
    
    
    if ([[arrayHYCTime lastObject]intValue] <= 0 && [[arrayHYCTime firstObject]intValue] <= 0 ) {
        
        if (self.cellSelectedBlock) {
            self.cellSelectedBlock(@"00:00");
        }
        
        [_HYCOFFAPPtimer setFireDate:[NSDate distantFuture]];
        [[NSUserDefaults standardUserDefaults] setInteger:6 forKey:KEYHYCBOOL_______HYCKEY];
        
        if ([udf objectForKey:KEYHYC_______HYCKEY]) {
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:KEYHYC_______HYCKEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            exit(1);
            
        }
        
    }else{
        
        
        if (self.cellSelectedBlock) {
            self.cellSelectedBlock([self dateTimeDifferenceWithStartTime:[dateFormatter stringFromDate:[NSDate date]] endTime:[udf objectForKey:KEYHYC_______HYCKEY]]);
        }
    }
}

- (void)startTimer{
    
    [_HYCOFFAPPtimer setFireDate:[NSDate distantPast]];
    
}


- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"dd:HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970];
    NSTimeInterval end = [endD timeIntervalSince1970];
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60;
    //int house = (int)value /60/60%60;
    
    
    
    NSString *str;
    
    str = [NSString stringWithFormat:@"%02d:%02d",minute,second];
    NSLog(@"%@",str);
    return str;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f,0.0f, 1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (MainViewController *)sharedManager
{
    static MainViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}


//隐藏系统tabbar上面的子视图
-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:animated];
    if (isPret) {
        
        
    }else{
        //获得标签栏上的所有子视图
        NSArray *subViewsArray=self.tabBar.subviews;
        //遍历数组
        for (UIView *view in subViewsArray) {
            view.hidden=YES;
        }
        
        [self createTabBarView];
    }
}

//创建导航条按钮,添加到tabbar
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
 
    
}

- (void)createTabBarView{
    
    isPret = YES;   //创建过就设为yes
    
    NSArray *array=self.viewControllers;
    
    for (int i=0; i<array.count ; i++) {

        
        if (i == 0) {
            
            
            firstBarV = [BoFangTabbarView sharedManager];

            //记录一开始的旋转位置
            _startTransform = firstBarV.HYCContentImageName.transform;
            
            if (_timer) {
                
                
            }else{
                _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(runTimeXUANZHUAN) userInfo:nil repeats:YES];
            }
            [_timer setFireDate:[NSDate distantFuture]];    //暂停
            
            
            UITapGestureRecognizer *tapFirst=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(firstVCClick)];
            
            [firstBarV.HYCKuangImageName addGestureRecognizer:
             
             tapFirst];
            
            //改变图片
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changecontentImageView:) name:@"CHANGEIMAGEVIEW" object:nil];
            
            //还原动画
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreTransform) name:@"RESTORETIME" object:nil];
            
            //启动定时器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(benginTimetrasnfor) name:@"BENGINTIME" object:nil];
            
            //暂停定时器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimetrasnfor) name:@"STOPTIME" object:nil];
            
            [self.tabBar addSubview:firstBarV];

            
        }else{
            
            UINavigationController *nav=[array objectAtIndex:i];
            UIImageView *itemImgV;
            UILabel *lb;
            //创建图片
            
            
            
            itemImgV=[[UIImageView alloc]initWithFrame:CGRectMake
                      (i*(K_Screen_Width/4.00)+(K_Screen_Width/14),0,49,49)];
            itemImgV.image=nav.tabBarItem.image;
            //将图片添加到标签栏
            [self.tabBar addSubview:itemImgV];
            
            
            
            
            //创建点击手势
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            itemImgV.userInteractionEnabled=YES;
            //为每张图片添加tag
            itemImgV.tag=i+100;
            [itemImgV addGestureRecognizer:tap];
            
            UITapGestureRecognizer *tapLabel=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
            lb.userInteractionEnabled=YES;
            //为每Label添加tag
            lb.tag=i+200;
            [lb addGestureRecognizer:tapLabel];
            
        }

        
        
    }
    
}


-(void)tapClick:(UITapGestureRecognizer *)tap
{
    long itemNumber = 0;
    if (tap.view.tag <199) {
        //这点击的是imageView
        itemNumber = tap.view.tag - 100;
        
    }else{
        //点击的是lable
        itemNumber = tap.view.tag - 200;
    }
    
    //将临时变量改为低亮
//    [_tmpLb setTextColor:[UIColor blackColor]];
    _tmpImgV.image=_tmpNavigationController.tabBarItem.image;
    
    
    
    //将点击的按钮变为高亮
    NSArray *navigationControllerArray=self.viewControllers;
    
    UINavigationController *nav=[navigationControllerArray objectAtIndex:itemNumber];
    
    UIImageView *imgV= [self.tabBar viewWithTag:itemNumber + 100];
    imgV.image=nav.tabBarItem.selectedImage;
    //获得图片上的label
    UILabel *lb=[self.tabBar viewWithTag:itemNumber + 200];
    [lb setTextColor:[UIColor orangeColor]];
    
    
    //临时变量保存高亮按钮
    _tmpNavigationController=nav;
    _tmpLb=lb;
    _tmpImgV=imgV;
    
    //实现子视图控制器页面的切换
    self.selectedIndex=itemNumber;
    
    
    
}

//改变图片
- (void)changecontentImageView:(NSNotification *)not{
    
    NSDictionary *dataDict = not.userInfo;
    
    [firstBarV.HYCContentImageName sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    
    //存图片到用户偏好
    if (![[NSString NULLToString:dataDict[@"ContentImg"]] isEqualToString:@""]) {
        
        [AutomatePlist writePlistForkey:@"ImgV" value:dataDict[@"ContentImg"]];
    }else{
        
        [AutomatePlist writePlistForkey:@"ImgV" value:@"img_radio_default"];
    }
    
}

//暂停旋转
- (void)stopTimetrasnfor{
    
    [_timer setFireDate:[NSDate distantFuture]];
    firstBarV.LJQStopImage.hidden = NO;
    
    //记录暂停
    [AutomatePlist writePlistForkey:@"transformbegin" value:@"0"];
}

//启动旋转
- (void)benginTimetrasnfor{
    
    [_timer setFireDate:[NSDate distantPast]];
    firstBarV.LJQStopImage.hidden = YES;
    
    //记录启动
    [AutomatePlist writePlistForkey:@"transformbegin" value:@"1"];
}
//开始旋转
- (void)runTimeXUANZHUAN{

    count+=1;
    
    if (count == 360) {
        
        count = 0;
    }
    
//    firstBarV.HYCContentImageName.transform = CGAffineTransformRotate(_startTransform, (M_PI / 800)*count);
    firstBarV.HYCContentImageName.transform = CGAffineTransformMakeRotation((M_PI / 180.0f)*count);
    //记录当前正在旋转角度
    [AutomatePlist writePlistForkey:@"transform" value:[NSString stringWithFormat:@"%d", count]];
}

//还原旋转(切换歌曲时调用)
- (void)restoreTransform{

    count = 0;
    //记录当前正在旋转角度
    [AutomatePlist writePlistForkey:@"transform" value:[NSString stringWithFormat:@"%d", count]];
}

- (void)firstVCClick{
    
    _tmpImgV.image=_tmpNavigationController.tabBarItem.image;
    
    //实现子视图控制器页面的切换
    self.selectedIndex=0;
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
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

@end
