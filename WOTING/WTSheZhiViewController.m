//
//  WTSheZhiViewController.m
//  WOTING
//
//  Created by jq on 2016/11/24.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTSheZhiViewController.h"

#import "WTGuanYuViewController.h"
#import "WTHelpViewController.h"
#import "WTFanKuiViewController.h"

#import "WTUserNubController.h"
#import "WTBoundPhoneController.h"
#import "WTRePsdController.h"

@interface WTSheZhiViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    /** 设置ICON */
    NSArray         *iconsArray;
    /** 设置Title */
    NSArray         *titlesArray;
    
    /** 标记登录状态值 */
    NSInteger   Login; //0为未登录
    
    UIButton    *logBtn;
}

@end

@implementation WTSheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.JQSZtableView.delegate = self;
    self.JQSZtableView.dataSource = self;
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.JQSZtableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.JQSZtableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //监听登陆状态的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(LoginNotification:) name:@"LoginChangeNotification" object:nil];
    
    //监听用户号是否修改过的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserNotification:) name:@"UserNumberNotification" object:nil];
    
    NSString *Uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    if (Uid && ![Uid  isEqual: @"0"]) {
        
        Login = 1;
    }else{
        Login = 0;
    }
    
    [self createNSArray];
    [self blockLogin];
   
    NSLog(@"缓存文件大小为%@",[NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]]);
}

- (void)blockLogin {
    
    if (Login == 0) {
        
        logBtn.hidden = YES;
    }else {
        
        logBtn = [[UIButton alloc] init];
        logBtn.backgroundColor = [UIColor JQTColor];
        [logBtn setTitle:@"注销登录" forState:UIControlStateNormal];
        logBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
        logBtn.layer.cornerRadius = 5;
        logBtn.layer.masksToBounds = YES;
        [logBtn addTarget:self action:@selector(blockBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [logBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.view addSubview:logBtn];
        
        [logBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-30);
            make.height.mas_equalTo(30);
        }];
    }
}

- (void)blockBtnClick {
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid ,@"UserId",nil];
    
    NSString *login_Str = WoTing_mlogout;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"注销成功" inView:nil duration:0.5 animated:YES];
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            Login = 0;
            [self blockLogin];
            [self createNSArray];
            [_JQSZtableView reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            
        }
        
    } fail:^(NSError *error) {
        
        
        NSLog(@"%@", error);
        
    }];

}

- (void)createNSArray {
    
    if (Login == 0) {
        
        iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects: @"mine_set_icon_delete.png",  nil], [NSArray arrayWithObjects:@"mine_set_icon_preference.png", nil],[NSArray arrayWithObjects:@"mine_set_icon_help.png",@"mine_set_icon_feedback.png",@"mine_set_icon_about.png", nil], nil];
        
        titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects: @"清除缓存", nil], [NSArray arrayWithObjects:@"偏好设置",  nil],[NSArray arrayWithObjects:@"使用帮助",@"反馈建议",@"关于我听" , nil], nil];
        
    }else{
        
        iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects: @"mine_set_icon_user name.png",@"mine_set_icon_phone.png",@"mine_set_icon_password.png",  nil],[NSArray arrayWithObjects: @"mine_set_icon_delete.png",  nil], [NSArray arrayWithObjects:@"mine_set_icon_preference.png", nil],[NSArray arrayWithObjects:@"mine_set_icon_help.png",@"mine_set_icon_feedback.png",@"mine_set_icon_about.png", nil], nil];
        
        titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects: @"用户号",@"绑定手机",@"重置密码",  nil],[NSArray arrayWithObjects: @"清除缓存", nil], [NSArray arrayWithObjects:@"偏好设置",  nil],[NSArray arrayWithObjects:@"使用帮助",@"反馈建议",@"关于我听" , nil], nil];
        
        
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (Login == 0) {
        
        return 3;

    }else{
        
        return 4;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (Login == 0) {
        
        if (section == 0) {
            return 1;
        }else if (section == 1) {
            return 1;
        }else{
            return 3;
        }
    }else{
        
        if (section == 0) {
            return 3;
        }else if (section == 1) {
            return 1;
        }else if (section == 2){
            return 1;
        }else{
            return 3;
        }
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor skTitleHighBlackColor];
         cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    }
    
    cell.imageView.image = [UIImage imageNamed:[[iconsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.textLabel.text = [[titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (Login == 0) {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]];
        }
        
    }else{
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (Login == 0) {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()] error:nil];
            
            if (remove == YES) {
                
                [tableView reloadData];
                [WKProgressHUD popMessage:@"清理缓存成功" inView:nil duration:0.5 animated:YES];
            }else{
                NSLog(@"删除失败");
            }
        }
        
        if (indexPath.section == 2 && indexPath.row == 0) {
            
            WTHelpViewController *helpVC = [[WTHelpViewController alloc] init];
            helpVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        
    }else{
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            WTUserNubController *userVC = [[WTUserNubController alloc] init];
            userVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:userVC animated:YES];
        }
        
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            WTBoundPhoneController *BPhoneVC = [[WTBoundPhoneController alloc] init];
            BPhoneVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:BPhoneVC animated:YES];
        }
        
        if (indexPath.section == 0 && indexPath.row == 2) {
            
            WTRePsdController *RePsdVC = [[WTRePsdController alloc] init];
            RePsdVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:RePsdVC animated:YES];
        }
        
        if (indexPath.section == 1 && indexPath.row == 0) {
            
            BOOL remove = [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()] error:nil];
            
            if (remove == YES) {
                
                [tableView reloadData];
                [WKProgressHUD popMessage:@"清理缓存成功" inView:nil duration:0.5 animated:YES];
            }else{
                NSLog(@"删除失败");
            }
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//登录状态改变触发
- (void)LoginNotification:(NSNotification *)nt{
    
    Login = 1;
    [self createNSArray];
    [self blockLogin];
    [_JQSZtableView reloadData];
    
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)FanHuiBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
