//
//  WTQunSignChangeController.m
//  WOTING
//
//  Created by jq on 2017/4/27.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunSignChangeController.h"

@interface WTQunSignChangeController ()<UITextViewDelegate>

@end

@implementation WTQunSignChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _SignTextV.delegate = self;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    _SignTextV.attributedText = [[NSAttributedString alloc] initWithString:[NSString NULLToString:_dataQunDeditc[@"GroupSignature"]] attributes:attributes];
    
    _backgroundView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapS = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(JIANPANSHOUQI)];
    [_backgroundView addGestureRecognizer:tapS];
    
    _SaveBtn.enabled = NO;
    
    NSInteger ZiNum = 140 - _SignTextV.text.length;
    
    _ZiLab.text = [NSString stringWithFormat:@"还可以输入%lu个字", ZiNum];
}

//收起键盘
- (void)JIANPANSHOUQI{
    
    [_SignTextV resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView{
    
    NSInteger ZiNum = 140 - textView.text.length;
    
    _ZiLab.text = [NSString stringWithFormat:@"还可以输入%lu个字", ZiNum];
    
    if (textView.text.length > 0) {
        
        _SaveBtn.enabled = YES;
    }
    
    //字数限制操作
    if (textView.text.length >= 140) {
        
        textView.text = [textView.text substringToIndex:140];
        _ZiLab.text = @"还可以输入0个字";
        
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)SaveBtnClick:(id)sender {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDeditc[@"GroupId"]];
    
    NSString *GroupSignature = _SignTextV.text;
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupSignature,@"GroupSignature",GroupId,@"GroupId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_UpdateGroup;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
            self.SignStrChange(GroupSignature);
            [WKProgressHUD popMessage:@"修改签名成功" inView:nil duration:0.5 animated:YES];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
            
            
        }
        
    } fail:^(NSError *error) {
        
        
    }];
    
}
@end
