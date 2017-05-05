//
//  WTAddResultViewController.m
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTAddResultViewController.h"

#import "WTFriendDetailsController.h"   //好友详情
#import "WTQunDetailsController.h"      //群详情


#import "WTAddResultCell.h" //数据源cell

@interface WTAddResultViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataAddResultArr;  //搜索结果数据源
}

@end

@implementation WTAddResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataAddResultArr = [NSMutableArray arrayWithCapacity:0];
    
    _AddResultTabV.delegate = self;
    _AddResultTabV.dataSource = self;
    
    _AddResultTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _AddResultTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    
    [self loadDataAddResult];    //获取数据
    
    
    [self reigterAddReultTabCell];
}

- (void)reigterAddReultTabCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTAddResultCell" bundle:nil];
    
    [_AddResultTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
}

- (void)loadDataAddResult{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",_SearchStr,@"SearchStr",uid,@"UserId",nil];
    
    NSString *login_Str;
    
    if (_AddResultType == 0) {
        
        login_Str = WoTing_SearchStranger;
    }else{
        
        login_Str = WoTing_SearchGroup;
    }
    
    NSLog(@"%@", parameters);
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [dataAddResultArr removeAllObjects];
            
            if (_AddResultType == 0) {
                
                [dataAddResultArr addObjectsFromArray:resultDict[@"UserList"]];
            }else{
            
                [dataAddResultArr addObjectsFromArray:resultDict[@"GroupList"]];
            }
            
            [_AddResultTabV reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataAddResultArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cellID";
    
    WTAddResultCell *cell = (WTAddResultCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTAddResultCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (_AddResultType == 0) {
        
        cell.contentLab.text = [NSString NULLToString:dataAddResultArr[indexPath.row][@"NickName"]];
        NSString *PhoneNum = [NSString NULLToString:dataAddResultArr[indexPath.row][@"PhoneNum"]];
        
        if (PhoneNum.length > 0) {
            
            cell.DeiltLab.text =[NSString stringWithFormat:@"用户号: %@",PhoneNum];
        }else{
            
            cell.DeiltLab.hidden = YES;
        }
        
        
        if ([[NSString NULLToString:dataAddResultArr[indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataAddResultArr[indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
        }else if ([NSString NULLToString:dataAddResultArr[indexPath.row][@"PortraitBig"]].length){
            
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,dataAddResultArr[indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            
        }else{
            
            cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
        }
    }else{
    
        cell.contentLab.text = [NSString NULLToString:dataAddResultArr[indexPath.row][@"GroupName"]];
        cell.DeiltLab.text =[NSString stringWithFormat:@"群号: %@",[NSString NULLToString:dataAddResultArr[indexPath.row][@"GroupNum"]]];
        
        if ([[NSString NULLToString:dataAddResultArr[indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:dataAddResultArr[indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
        }else if ([NSString NULLToString:dataAddResultArr[indexPath.row][@"PortraitBig"]].length){
            
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,dataAddResultArr[indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Qun_header.png"]];
            
        }else{
            
            cell.contentImgV.image = [UIImage imageNamed:@"Qun_header.png"];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (_AddResultType == 0) {
        
        WTFriendDetailsController *wtFriDVC = [[WTFriendDetailsController alloc] init];
        wtFriDVC.dataFriDict = dataAddResultArr[indexPath.row];
        wtFriDVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtFriDVC animated:YES];
    }else{
        
        WTQunDetailsController *wtQunDVC = [[WTQunDetailsController alloc] init];
        wtQunDVC.hidesBottomBarWhenPushed = YES;
        wtQunDVC.dataQunDict = dataAddResultArr[indexPath.row];
        wtQunDVC.QunDetailsType = [dataAddResultArr[indexPath.row][@"GroupType"] integerValue];
        [self.navigationController pushViewController:wtQunDVC animated:YES];
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
@end
