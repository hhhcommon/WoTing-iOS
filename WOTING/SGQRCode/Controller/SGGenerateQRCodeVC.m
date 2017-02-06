//
//  SGGenerateQRCodeVC.m
//  SGQRCodeExample
//
//  Created by Sorgle on 16/8/25.
//  Copyright © 2016年 Sorgle. All rights reserved.


#import "SGGenerateQRCodeVC.h"
#import "SGQRCodeTool.h"

@interface SGGenerateQRCodeVC (){
    
    UIView      *view; //二维码view
    UIView      *contetnView; //内容view
}

@end

@implementation SGGenerateQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLogin:) name:@"LoginChangeNotification" object:nil];
    
    UIImageView *imageBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, K_Screen_Height)];
    imageBackgroundView.image = [UIImage imageNamed:@"erweiback.png"];
    imageBackgroundView.userInteractionEnabled = YES;
    [self.view addSubview:imageBackgroundView];
    
    //namelab
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.text = @"二维码";
    nameLab.textAlignment = NSTextAlignmentCenter;
    nameLab.textColor = [UIColor whiteColor];
    nameLab.font = [UIFont boldSystemFontOfSize:15];
    [imageBackgroundView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(imageBackgroundView.mas_centerX);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(30);
    }];
    
    //blackBtn
    UIButton *blackBtn = [[UIButton alloc] init];
    [blackBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [blackBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [imageBackgroundView addSubview:blackBtn];
    [blackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(30);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(30);
    }];
    
    contetnView = [[UIView alloc] init];
    contetnView.layer.cornerRadius = 5;
    contetnView.layer.masksToBounds = YES;
    contetnView.backgroundColor = [UIColor whiteColor];
    [imageBackgroundView addSubview:contetnView];
    [contetnView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(nameLab.mas_bottom).with.offset(70);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(70);
    }];
   
    
    view = [[UIView alloc] init];
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor whiteColor];
    [imageBackgroundView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(contetnView.mas_bottom).with.offset(2);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(K_Screen_Width);
    }];
    
     [self createContentView];   //填充个人信息
    
    // 生成二维码(中间带有图标)
 //   [self setupGenerate_Icon_QRCode];
    
    // 生成二维码(彩色)
 //   [self setupGenerate_Color_QRCode];

}

- (void)createContentView {
    
    //头像
    UIImageView *TimageView = [[UIImageView alloc] init];
    [contetnView addSubview:TimageView];
    NSString *imageStr = [NSString NULLToString:_dict[@"PortraitBig"]];
    if ([imageStr hasPrefix:@"http"]) {
        
        [TimageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"mine_default avatar_male.png"]];
    }else {
        
        NSString *imgStr = [NSString stringWithFormat:SKInterFaceServer@"%@",imageStr];
        [TimageView sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:imgStr]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
    }
    [TimageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(13);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    //头像背景
    UIImageView *BGview = [[UIImageView alloc] init];
    BGview.image = [UIImage imageNamed:@"WT_BoFang_Kuang.png"];
    [contetnView addSubview:BGview];
    [BGview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(13);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(60);
    }];
    
    //name
    UILabel *nameLab = [[UILabel alloc] init];
    nameLab.textColor = [UIColor JQTColor];
    nameLab.font = [UIFont boldSystemFontOfSize:14];
    nameLab.text = _dict[@"UserName"];
    [contetnView addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.equalTo(TimageView.mas_right).with.offset(5);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    
    // 生成二维码(Default)
    [self setupGenerateQRCode];
}

- (void)changeLogin:(NSNotification *)not {
    
    if ([[not.userInfo objectForKey:@"User"] isEqualToString:@"jq"]) {
        
        _dict = nil;
        
    }else {
        
        _dict = not.userInfo;
        [self createContentView];
    }
    
}

// 生成二维码
- (void)setupGenerateQRCode {

    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = K_Screen_Width/2;
    CGFloat imageViewH = imageViewW;
    [view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(view.mas_centerX);
        make.centerY.equalTo(view.mas_centerY);
        make.width.mas_equalTo(imageViewW);
        make.height.mas_equalTo(imageViewH);
    }];
    
    // 2、将CIImage转换成UIImage，并放大显示
    imageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:_dict imageViewWidth:imageViewW];
    
#pragma mark - - - 模仿支付宝二维码样式（添加用户头像）
    CGFloat scale = 0.22;
    CGFloat borderW = 5;
    UIView *borderView = [[UIView alloc] init];
    CGFloat borderViewW = imageViewW * scale;
    CGFloat borderViewH = imageViewH * scale;
    CGFloat borderViewX = 0.5 * (imageViewW - borderViewW);
    CGFloat borderViewY = 0.5 * (imageViewH - borderViewH);
    borderView.frame = CGRectMake(borderViewX, borderViewY, borderViewW, borderViewH);
    borderView.layer.borderWidth = borderW;
    borderView.layer.borderColor = [UIColor purpleColor].CGColor;
    borderView.layer.cornerRadius = 10;
    borderView.layer.masksToBounds = YES;
    borderView.layer.contents = (id)[UIImage imageNamed:@"icon_image"].CGImage;

    //[imageView addSubview:borderView];
    UILabel *JSlab = [[UILabel alloc] init];
    JSlab.textAlignment = NSTextAlignmentCenter;
    JSlab.text = @"扫描上面二维码图案,加我为好友";
    JSlab.font = [UIFont systemFontOfSize:13];
    JSlab.textColor = [UIColor grayColor];
    [view addSubview:JSlab];
    [JSlab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).with.offset(40);
        make.width.equalTo(imageView);
        make.height.mas_equalTo(15);
    }];
    
}

#pragma mark - - - 中间带有图标二维码生成
- (void)setupGenerate_Icon_QRCode {
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 240;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    
    CGFloat scale = 0.2;
    
    // 2、将最终合得的图片显示在UIImageView上
    imageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:@"https://github.com/kingsic" logoImageName:@"icon_image" logoScaleToSuperView:scale];
    
}

#pragma mark - - - 彩色图标二维码生成
- (void)setupGenerate_Color_QRCode {
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.view.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 400;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self.view addSubview:imageView];
    
    // 2、将二维码显示在UIImageView上
    imageView.image = [SGQRCodeTool SG_generateWithColorQRCodeData:@"https://github.com/kingsic" backgroundColor:[CIColor colorWithRed:1 green:0 blue:0.8] mainColor:[CIColor colorWithRed:0.3 green:0.2 blue:0.4]];
}

- (void)backBtnClick:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end



