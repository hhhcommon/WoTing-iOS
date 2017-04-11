//
//  WTBianJiZiLiaoController.m
//  WOTING
//
//  Created by jq on 2017/4/6.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTBianJiZiLiaoController.h"
#import "KSDatePicker.h"
#import "SGPicker.h"

@interface WTBianJiZiLiaoController ()

@end

@implementation WTBianJiZiLiaoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"%@", _dataZLDict);
    
    NSString *phoneNum = [NSString NULLToString:_dataZLDict[@"PhoneNum"]];
    if (phoneNum.length) {
        
       _ZhangHaoTextF.text = [phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        
        _ZhangHaoTextF.text = @"";
    }
    
    
    _NikNameTextF.text = [NSString NULLToString:_dataZLDict[@"NickName"]];
    
    if ([[NSString NULLToString:_dataZLDict[@"Sex"]] isEqualToString:@"男"]) {
        
        _BoyBtn.selected = YES;
        _GirlBtn.selected = NO;
    }else{
        
        _BoyBtn.selected = NO;
        _GirlBtn.selected = YES;
    }
    
    [_birthDayBtn setTitle:@"请输入日期" forState:UIControlStateNormal];
    [_birthDayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _birthDayBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [_DiQuBtn setTitle:@"请输入地区" forState:UIControlStateNormal];
    _DiQuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    if (_dataZLDict[@"UserSign"]) {
        
        _GeXingTextF.text = [NSString NULLToString:_dataZLDict[@"UserSign"]];
    }else if([_dataZLDict[@"UserSign"] isEqualToString:@""]){
        
        _GeXingTextF.text = @"请输入个性签名";
    }else{
        
        _GeXingTextF.text = @"请输入个性签名";
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

- (IBAction)BoyBtnClick:(id)sender {
    
    if (_BoyBtn.selected) {
        
        _BoyBtn.selected = NO;
        _GirlBtn.selected = YES;
    }else{
        
        _BoyBtn.selected = YES;
        _GirlBtn.selected = NO;
    }
}

- (IBAction)GirlBtnClick:(id)sender {
    
    if (_GirlBtn.selected) {
        
        _BoyBtn.selected = YES;
        _GirlBtn.selected = NO;

    }else{
        
        _BoyBtn.selected = NO;
        _GirlBtn.selected = YES;
    }
}

//生日
- (IBAction)birthDayBtnClick:(id)sender {
    
    // 日期
    SGDatePicker *datePicker = [[SGDatePicker alloc] init];
    datePicker.isBeforeTime = YES; // 日期一定要设置
    datePicker.datePickerMode = UIDatePickerModeDate; // 日期一定要设置
    
    [datePicker didFinishSelectedDate:^(NSDate *selectedDate) {
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        
        [sender setTitle:[formatter stringFromDate:selectedDate] forState:UIControlStateNormal];
        
        NSDateFormatter* formatterMM = [[NSDateFormatter alloc] init];
        [formatterMM setDateFormat:@"MM"];
        int m = [[formatterMM stringFromDate:selectedDate] intValue];
        
        NSDateFormatter* formatterdd = [[NSDateFormatter alloc] init];
        [formatterdd setDateFormat:@"dd"];
        int d = [[formatterdd stringFromDate:selectedDate] intValue];
        
        _XingZuoLab.text = [NSString stringWithFormat:@"%@座", [self getAstroWithMonth:m day:d]];
    }];
    [datePicker show];
    
//    //x,y 值无效，默认是居中的
//    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
//    
//    //配置中心，详情见KSDatePikcerApperance
//    
//    picker.appearance.radius = 5;
//    
//    //设置回调
//    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
//        
//        if (buttonType == KSDatePickerButtonCommit) {
//            
//            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//            [formatter setDateFormat:@"yyyy年MM月dd日"];
//            
//            [sender setTitle:[formatter stringFromDate:currentDate] forState:UIControlStateNormal];
//            
//            NSDateFormatter* formatterMM = [[NSDateFormatter alloc] init];
//            [formatterMM setDateFormat:@"MM"];
//            int m = [[formatterMM stringFromDate:currentDate] intValue];
//            
//            NSDateFormatter* formatterdd = [[NSDateFormatter alloc] init];
//            [formatterdd setDateFormat:@"dd"];
//            int d = [[formatterdd stringFromDate:currentDate] intValue];
//            
//            _XingZuoLab.text = [NSString stringWithFormat:@"%@座", [self getAstroWithMonth:m day:d]];
//        }
//    };
//    // 显示
//    [picker show];
}

//地区
- (IBAction)DiQuBtnClick:(id)sender {
    
    SGPickerView *pickerView = [[SGPickerView alloc] init];
    [pickerView show];
    pickerView.locationMessage = ^(NSString *str){
        
        [sender setTitle:str forState:UIControlStateNormal];
    };
}

-(NSString *)getAstroWithMonth:(int)m day:(int)d{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
    
}

- (IBAction)backBtnClick:(id)sender {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    if ([_GeXingTextF.text  isEqual: @"请输入个性签名"]) {
        _GeXingTextF.text = @"";
    }
    
    NSString *SexDictId;
    if (_BoyBtn.selected) {
        
        SexDictId = @"xb001";
    }else{
        
        SexDictId = @"xb002";
    }
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",_NikNameTextF.text,@"NickName",_GeXingTextF.text,@"UserSign",SexDictId,@"SexDictId",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_UserInfo;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];
    
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
