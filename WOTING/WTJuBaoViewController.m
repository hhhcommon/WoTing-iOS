//
//  WTJuBaoViewController.m
//  WOTING
//
//  Created by jq on 2017/3/15.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTJuBaoViewController.h"

#import "WTJuBaoCell.h"

@interface WTJuBaoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>{
    
    NSMutableArray      *dataJuBaoArr;
    
    long    Num;
}

@end

@implementation WTJuBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataJuBaoArr = [NSMutableArray arrayWithCapacity:0];
    Num = 0;
    
    _JuBaoTextV.text = @"详细描述举报原因(选填)";
    _JuBaoTextV.delegate = self;
    
    _JuBaoTableV.delegate = self;
    _JuBaoTableV.dataSource = self;
    
    [self registerJBTableViewCell];
    [self loadDataJuBao];
}

- (void)registerJBTableViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTJuBaoCell" bundle:nil];
    
    [_JuBaoTableV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

- (void)loadDataJuBao{
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",  @"12",@"CatalogType",@"1",@"ResultType",@"3",@"RelLevel",@"1",@"Page",nil];
    
    NSString *login_Str = WoTing_getCatalogInfo;
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            NSDictionary *ResultList = resultDict[@"CatalogData"];
            
            [dataJuBaoArr addObjectsFromArray:ResultList[@"SubCata"]];
            [_JuBaoTableV reloadData];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
    
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return dataJuBaoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    WTJuBaoCell *cell = (WTJuBaoCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTJuBaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //[2]	(null)	@"CatalogName" : @"违反法律法规的内容"
    cell.cellLabName.text = dataJuBaoArr[indexPath.row][@"CatalogName"];
    cell.cellImgV.hidden = YES;
    
    if (Num == (long)indexPath.row) {
        
        cell.cellImgV.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Num = indexPath.row;
    [_JuBaoTableV reloadData];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_JuBaoTextV resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    
    if ([textView.text isEqualToString:@"详细描述举报原因(选填)"]) {
        
        textView.text = @"";
    }
    
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        
        textView.text = @"详细描述举报原因(选填)";
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

//点击返回
- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//点击提交
- (IBAction)TiJiaoBtnClick:(id)sender {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *InputReason;
    if ([_JuBaoTextV.text isEqualToString:@"详细描述举报原因(选填)"]) {
        
        InputReason = @"";
    }else{
        
        InputReason = _JuBaoTextV.text;
    }
    
    NSString *SelReasons = [NSString stringWithFormat:@"%@::%@", dataJuBaoArr[Num][@"CatalogId"], dataJuBaoArr[Num][@"CatalogName"]];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",  _MediaType,@"MediaType",InputReason,@"InputReason",_ContentId,@"ContentId",SelReasons,@"SelReasons",nil];
    
    NSString *login_Str = WoTing_JuBao;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"举报成功" inView:nil duration:0.5 animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        
        
    }];
}
@end
