//
//  WTPingLunViewController.m
//  WOTING
//
//  Created by jq on 2016/12/12.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTPingLunViewController.h"

#import "WTPingLunCell.h"

@interface WTPingLunViewController ()<UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray      *dataPLArr;
    NSInteger       PLCellInteger;  //cell高度
}

@end

@implementation WTPingLunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataPLArr = [NSMutableArray arrayWithCapacity:0];
    PLCellInteger = 0;
    
    _PLTabV.dataSource = self;
    _PLTabV.delegate = self;
    
    _PLTabV.tableFooterView = [[UIView alloc] init];
    _PLTabV.separatorStyle = UITableViewCellSelectionStyleNone;
    
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self registerTabViewCell];
    [self loadDataPL];
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTPingLunCell" bundle:nil];
    
    [_PLTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

//请求评论列表
- (void)loadDataPL {
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", _ContentID,@"ContentId",_Metype,@"MediaType", @"10",@"PageSize",nil];
    
    NSString *login_Str = WoTing_PLgetList;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
           // NSDictionary *ResultList = resultDict[@"ResultList"];
            [dataPLArr removeAllObjects];
            [dataPLArr addObjectsFromArray: resultDict[@"DiscussList"]];
            
            
            [_PLTabV reloadData];
   
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"1011"]){
            
            [WKProgressHUD popMessage:@"暂无评论信息" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];

    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataPLArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTPingLunCell *cell = (WTPingLunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTPingLunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = dataPLArr[indexPath.row];
    [cell setCellWithDict:dict];
    
    NSString *Discuss = dataPLArr[indexPath.row][@"Discuss"];
    CGFloat previewH = [Discuss boundingRectWithSize:CGSizeMake(cell.contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    cell.contetnLabHeight.constant = previewH;
    
    PLCellInteger = previewH - 21;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70 + PLCellInteger;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.000000000000001;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyBoardWillHide:(NSNotification *)n
{
    //获得键盘隐藏的时间
    float time=[[n.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:time animations:^{
        self.viewBottom.constant=0;
        [self.view layoutIfNeeded];
    }];
    
}



-(void)keyBoardWillShow:(NSNotification *)n
{
    //获得键盘弹起的时间
    float time=[[n.userInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    //获得键盘弹起的高度
    float height=[[n.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] CGRectValue].size.height;
    
    [UIView animateWithDuration:time animations:^{
        self.viewBottom.constant=height;
        [self.view layoutIfNeeded];
    }];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_textFiled resignFirstResponder];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//表情按钮
- (IBAction)BQBtnClick:(id)sender {
    
}

//发送按钮
- (IBAction)FSBtnClick:(id)sender {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    if (uid && ![uid  isEqual: @"0"]) {
        
        NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
        NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
        NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
        NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
        NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
        
        NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude", _ContentID,@"ContentId",_Metype,@"MediaType", uid,@"UserId", _textFiled.text  ,@"Discuss", nil];
        
        NSString *login_Str = WoTing_PLget;
        
        [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
            
            NSDictionary *resultDict = (NSDictionary *)response;
            
            NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
            
            if ([ReturnType isEqualToString:@"1001"]) {
                
                [_textFiled resignFirstResponder];
                _textFiled.text = nil;
                [self loadDataPL];  //刷新界面
            }else if ([ReturnType isEqualToString:@"T"]){
                
                [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"1003"]){
                
                [WKProgressHUD popMessage:@"无法评论的内容" inView:nil duration:0.5 animated:YES];
            }else if ([ReturnType isEqualToString:@"200"]){
                
                [AutomatePlist writePlistForkey:@"Uid" value:@""];
                [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
            }
            
        } fail:^(NSError *error) {
            
            NSLog(@"%@", error);
            
        }];
        
    }else {
        
        [WKProgressHUD popMessage:@"请登陆后再试" inView:nil duration:0.5 animated:YES];
    }
    
    
    
}

- (IBAction)backClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
