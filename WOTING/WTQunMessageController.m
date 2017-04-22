//
//  WTQunMessageController.m
//  WOTING
//
//  Created by jq on 2017/4/19.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunMessageController.h"

#import "WTQunDetailsController.h" //群详情

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

@interface WTQunMessageController ()<UIImagePickerControllerDelegate, UIActionSheetDelegate,UINavigationControllerDelegate>{
    
    NSMutableDictionary *dataQunDetilDict;  //创建好的群详情
}

@end

@implementation WTQunMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataQunDetilDict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    _QunView1.layer.cornerRadius = 5;
    _QunView1.layer.masksToBounds = YES;
    
    _QunView2.layer.cornerRadius = 5;
    _QunView2.layer.masksToBounds = YES;
    
    _QunView3.layer.cornerRadius = 5;
    _QunView3.layer.masksToBounds = YES;

    _SureBtn.layer.cornerRadius = 5;
    _SureBtn.layer.masksToBounds = YES;

    if (_QunMessageType == 1 || _QunMessageType == 0) {
        
        _QunView2.hidden = YES;
        _QunView3.hidden = YES;
        [_PsdTF1 addTarget:self action:@selector(PsdChange:) forControlEvents:UIControlEventEditingChanged];
        _SureTop.constant = 112 - 80;
    }else{
        
        _QunView2.hidden = NO;
        _QunView3.hidden = NO;
        [_PsdTF1 addTarget:self action:@selector(PsdTF1Change:) forControlEvents:UIControlEventEditingChanged];
        [_PsdTF2 addTarget:self action:@selector(SurPsdChange:) forControlEvents:UIControlEventEditingChanged];
        [_PsdTF3 addTarget:self action:@selector(PsdChange:) forControlEvents:UIControlEventEditingChanged];
        _SureTop.constant = 112;
    }
    
    
    _contentImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapCon = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageHeaderImage)];
    [_contentImgV addGestureRecognizer:tapCon];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_PsdTF1 resignFirstResponder];
    [_PsdTF2 resignFirstResponder];
    [_PsdTF3 resignFirstResponder];
}

//监听
- (void)PsdChange:(UITextField *)TF{
    
    if (_QunMessageType == 1 || _QunMessageType == 0) {
        
        if (TF.text.length > 0) {
            
            _SureBtn.backgroundColor = [UIColor JQTColor];
            _SureBtn.enabled = YES;
        }else{
            
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
    }else{
        
        if (_PsdTF2.text.length >=6 && _PsdTF1.text.length > 0) {
            
            if (TF.text.length >=6) {
                
                _SureBtn.backgroundColor = [UIColor JQTColor];
                _SureBtn.enabled = YES;
            }else{
                
                _SureBtn.backgroundColor = [UIColor lightGrayColor];
                _SureBtn.enabled = NO;
            }
        }else{
            
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
        
    }
}
- (void)SurPsdChange:(UITextField *)tf{
    
    if (_PsdTF3.text.length >=6 && _PsdTF1.text.length > 0) {
        
        if (tf.text.length >=6) {
            
            _SureBtn.backgroundColor = [UIColor JQTColor];
            _SureBtn.enabled = YES;
        }else{
            
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
    }else{
        
        _SureBtn.backgroundColor = [UIColor lightGrayColor];
        _SureBtn.enabled = NO;
    }
    
}
- (void)PsdTF1Change:(UITextField *)TF1{
    
    if (_PsdTF3.text.length >=6 && _PsdTF2.text.length >= 6) {
        
        if (TF1.text.length > 0) {
            
            _SureBtn.backgroundColor = [UIColor JQTColor];
            _SureBtn.enabled = YES;
        }else{
            
            _SureBtn.backgroundColor = [UIColor lightGrayColor];
            _SureBtn.enabled = NO;
        }
        
    }else{
        
        _SureBtn.backgroundColor = [UIColor lightGrayColor];
        _SureBtn.enabled = NO;
    }
    
}

- (void)chageHeaderImage{
    
    if (IOS8) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //相机
                UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
                imagePickerC.delegate = self;
                imagePickerC.allowsEditing = YES;
                imagePickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePickerC animated:YES completion:^{
                    
                }];
            }];
            
            [alertController addAction:defaultAction];
        }
        
        UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            //相册
            UIImagePickerController *iamgePickerC = [[UIImagePickerController alloc] init];
            iamgePickerC.delegate = self;
            iamgePickerC.allowsEditing = YES;
            iamgePickerC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:iamgePickerC animated:YES completion:^{
                
            }];
            
        }];
        
        UIAlertAction *cancelA = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:cancelA];
        [alertController addAction:defaultAction1];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        
        UIActionSheet *sheet;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
        }else{
            
            sheet = [[UIActionSheet alloc] initWithTitle:@"获取图片" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
        }
        [sheet showInView:self.view];
    }

    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSInteger sourceType = 0;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 1:
                sourceType = UIImagePickerControllerSourceTypeCamera;
                break;
            case 2:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
        
    }else{
        if (buttonIndex == 1) {
            
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
        
    }
    
    //跳转
    UIImagePickerController *imagePickerC = [[UIImagePickerController alloc] init];
    imagePickerC.delegate = self;
    imagePickerC.allowsEditing = YES;
    imagePickerC.sourceType = sourceType;
    [self presentViewController:imagePickerC animated:YES completion:nil];
}

//选择照片完成之后的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //info是所选择照片的信息
    
    //    UIImagePickerControllerEditedImage//编辑过的图片
    //    UIImagePickerControllerOriginalImage//原图
    
    
    NSLog(@"%@",info);
    //刚才已经看了info中的键值对，可以从info中取出一个UIImage对象，将取出的对象赋给按钮的image
    //@"UIImagePickerControllerReferenceURL" : @"assets-library://asset/asset.JPG?id=106E99A1-4F6A-45A2-B320-B0AD4A8E8473&ext=JPG"
    UIImage *resultImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    
    _contentImgV.image = resultImage;
    
    
    
    // imageData = UIImageJPEGRepresentation(resultImage, 0.5);
    
    //上传头像
 //   [self UploadHeaderImageView:resultImage];
    
    //使用模态返回到软件界面
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//点击取消按钮所执行的方法
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)UploadHeaderImageView:(UIImage *)image{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",@"UserP",@"FType",@"jpg",@"ExtName",uid,@"UserId",nil];
    
    NSString *login_Str = WoTing_Upload4App;
    
    [ZCBNetworking uploadWithImage:image url:login_Str filename:nil name:@"liangYan" mimeType:@"image/jpg" parameters:parameters progress:^(int64_t bytesWritten, int64_t totalBytesWritten) {
    } success:^(id response) {
        
        
        
        
        
    } fail:^(NSError *error) {
        
    }];
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

//点击确定, 建群
- (IBAction)SureBtnClick:(id)sender {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupType = [NSString stringWithFormat:@"%lu", _QunMessageType];
    
    NSDictionary *parameters;
    
    NSString *login_Str = WoTing_buildGroup;
    
    if (_QunMessageType == 2) { //密码群
        
        if ([_PsdTF2.text isEqualToString:_PsdTF3.text]) {
            
            parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupType,@"GroupType",_PsdTF1.text,@"GroupName",_PsdTF3.text,@"GroupPwd",uid,@"UserId",nil];
            
            [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
                
                NSDictionary *resultDict = (NSDictionary *)response;
                
                NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
                if ([ReturnType isEqualToString:@"1001"]) {
                    
                    [dataQunDetilDict removeAllObjects];
                    [dataQunDetilDict addEntriesFromDictionary:resultDict[@"GroupInfo"]];
                    
                    WTQunDetailsController *QunDVC = [[WTQunDetailsController alloc] init];
                    QunDVC.hidesBottomBarWhenPushed = YES;
                    QunDVC.dataQunDict = dataQunDetilDict;
                    QunDVC.QunDetailsType = [dataQunDetilDict[@"GroupType"] integerValue];
                    [self.navigationController pushViewController:QunDVC animated:YES];
                    
                }else if ([ReturnType isEqualToString:@"T"]){
                    
                    [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
                }else if ([ReturnType isEqualToString:@"200"]){
                    
                    [AutomatePlist writePlistForkey:@"Uid" value:@""];
                    [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
                }
                
            } fail:^(NSError *error) {
                
                
            }];
        }else{
            
            [WKProgressHUD popMessage:@"两次密码输入不正确" inView:nil duration:0.5 animated:YES];
            
        }
    }else{      //公开或审核
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupType,@"GroupType",_PsdTF1.text,@"GroupName",uid,@"UserId",nil];
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [dataQunDetilDict removeAllObjects];
                [dataQunDetilDict addEntriesFromDictionary:resultDict[@"GroupInfo"]];
                
                [self.navigationController popViewControllerAnimated:YES];
                WTQunDetailsController *QunDVC = [[WTQunDetailsController alloc] init];
                QunDVC.hidesBottomBarWhenPushed = YES;
                QunDVC.dataQunDict = dataQunDetilDict;
                QunDVC.QunDetailsType = [dataQunDetilDict[@"GroupType"] integerValue];
                [self.navigationController pushViewController:QunDVC animated:YES];
                
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"200"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            
        }];
        
    }

    
}
@end
