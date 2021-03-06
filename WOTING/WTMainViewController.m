//
//  WTMainViewController.m
//  WOTING
//
//  Created by jq on 2016/11/21.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTMainViewController.h"

#import "WTLikeListViewController.h"
#import "WTSheZhiViewController.h"
#import "WTLoginViewController.h"
#import "WTBianJiZiLiaoController.h"    //编辑资料
#import "WTDingYueController.h"     //订阅

#import "SGGenerateQRCodeVC.h"  //二维码生成器

#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)

@interface WTMainViewController ()<UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>{
    
    /** 设置ICON */
    NSArray         *iconsArray;
    /** 设置Title */
    NSArray         *titlesArray;
    
    /** 昵称*/
    NSString        *userName;
    
    /** 地址*/
    NSString        *Region;
    
    /** 标记登录状态值 */
    NSInteger   Login; //0为未登录
    
    NSDictionary     *loginDict;
    
    //头像data
    NSData          *imageData;

}

@end

@implementation WTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   // loginDict = [[NSDictionary alloc] init];
    loginDict = [AutomatePlist readPlistForDict:@"LoginDict"];
    self.navigationController.navigationBar.hidden = YES;
    
    NSString *Uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    if (Uid && ![Uid  isEqual: @"0"] && ![Uid isEqual:@""]) {
        
        Login = 1;
        Region = [AutomatePlist readPlistForKey:@"Region"];
        userName = [AutomatePlist readPlistForKey:@"NickName"];
        
    }else{
        Login = 0;
    }
    //监听登陆状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginNotification:) name:@"LoginChangeNotification" object:nil];
    
    [self creterNSArray];
    [self initContents];
    
    self.JQMainTV.delegate = self;
    self.JQMainTV.dataSource = self;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
  //
    
    _contentImgV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(GoToLogin)];
    [_contentImgV addGestureRecognizer:tap];
   
}

- (void)creterNSArray {
    
    if (Login == 0) {
        
        iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"mine_icon_play history.png", nil], [NSArray arrayWithObjects:@"mine_icon_234G.png", nil],[NSArray arrayWithObjects:@"mine_icon_yingjian.png",@"mine_icon_app share.png", nil],[NSArray arrayWithObjects:@"mine_icon_set.png", nil], nil];
        
        titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"播放历史", nil], [NSArray arrayWithObjects:@"2/3/4G网络播放和下载提醒",  nil],[NSArray arrayWithObjects:@"智能硬件",@"应用分享",  nil], [NSArray arrayWithObjects:@"其它设置",  nil] ,nil];
    }else{
        
        iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"mine_icon_play history.png",@"mine_icon_like.png",@"mine_icon_follow.png",@"mine_icon_subscribe.png",@"mine_icon_my upload.png", nil], [NSArray arrayWithObjects:@"mine_icon_234G.png", nil],[NSArray arrayWithObjects:@"mine_icon_yingjian.png",@"mine_icon_app share.png", nil],[NSArray arrayWithObjects:@"mine_icon_set.png", nil], nil];
        
        titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"播放历史",@"我的喜欢",@"我的关注",@"我的订阅",@"我的上传", nil], [NSArray arrayWithObjects:@"2/3/4G网络播放和下载提醒",  nil],[NSArray arrayWithObjects:@"智能硬件",@"应用分享",  nil], [NSArray arrayWithObjects:@"其它设置",  nil] ,nil];
        
    }
    
    
}

- (void)initContents{
    
    if (Login == 0) {
        
        _contentName.text = @"我的";
        _IntroduceLab.text = @"点击登录";
        _erWeiMaBtn.hidden = YES;
        _BianJiBtn.hidden = YES;
        _ImgKuang.hidden = YES;
        _contentImgV.image = [UIImage imageNamed:@"main_MoRen.png"];
    }else{
        
        _contentName.text = userName;
        _IntroduceLab.text = Region;
        _erWeiMaBtn.hidden = NO;
        _BianJiBtn.hidden = NO;
        _contentImgV.hidden = NO;
        if ([[NSString NULLToString:loginDict[@"PortraitBig"]] hasPrefix:@"http"]) {
            
            [_contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:loginDict[@"PortraitBig"]]]];
        }else if(loginDict[@"PortraitBig"]){
            
            [_contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SKInterFaceServer,[NSString NULLToString:loginDict[@"PortraitBig"]]]]];
        }else{
            
           _contentImgV.image = [UIImage imageNamed:@"mine_default avatar_male.png"];
        }
        _ImgKuang.hidden = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PostHeaderImageView)];
        [_ImgKuang addGestureRecognizer:tap];
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        if (Login == 0) {
            
            return 1;
        }else{
            return 5;
        }
    }else if (section == 1) {
        return 1;
    }else if (section == 2){
        
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor skTitleHighBlackColor];
    }
    
    cell.imageView.image = [UIImage imageNamed:[[iconsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.textLabel.text = [[titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (Login == 1) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            
            WTLikeListViewController *WTlikeVC = [[WTLikeListViewController alloc] init];
            WTlikeVC.label = @"播放历史";
            WTlikeVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:WTlikeVC animated:YES];
            
        }
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            
            WTLikeListViewController *WTlikeVC = [[WTLikeListViewController alloc] init];
            WTlikeVC.label = @"我的喜欢";
            WTlikeVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:WTlikeVC animated:YES];
            
        }
        
        if (indexPath.section == 0 && indexPath.row == 3) {
            
            WTDingYueController *WTdingYeVC = [[WTDingYueController alloc] init];
            
            WTdingYeVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:WTdingYeVC animated:YES];
        }
        
    }
    
    
    if (indexPath.section == 3 && indexPath.row == 0) {
        
        WTSheZhiViewController *WTszVC = [[WTSheZhiViewController alloc] init];
        WTszVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:WTszVC animated:YES];

    }
}

//登录状态改变触发
- (void)LoginNotification:(NSNotification *)nt{
    
    if ([[nt.userInfo objectForKey:@"User"] isEqualToString:@"jq"]) {
        
        Login = 0;
        [self creterNSArray];
        [self initContents];
        [_JQMainTV reloadData];
    }else {
    
        Login = 1;
        userName = [nt.userInfo objectForKey:@"NickName"];
        Region = [nt.userInfo objectForKey:@"Region"];
        [self creterNSArray];
        [self initContents];
        [_JQMainTV reloadData];
    }
}


- (void)PostHeaderImageView{
    
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
    [self UploadHeaderImageView:resultImage];
    
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
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = resultDict[@"ful"][0][@"ReturnType"];
        
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"修改头像成功" inView:nil duration:0.5 animated:YES];
            
        }
        
        
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

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)GoToLogin{
    
    WTLoginViewController *loginVC = [[WTLoginViewController alloc] init];
    
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:YES];
}
- (IBAction)TuoerWeiMaBtnClick:(id)sender {
    
    SGGenerateQRCodeVC *VC = [[SGGenerateQRCodeVC alloc] init];
    VC.dict = loginDict;
    
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
//编辑资料
- (IBAction)BianJiBtnClick:(id)sender {
    
    WTBianJiZiLiaoController *wtBJZLVC = [[WTBianJiZiLiaoController alloc] init];
    
    wtBJZLVC.dataZLDict = loginDict;
    wtBJZLVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:wtBJZLVC animated:YES];
}
@end
