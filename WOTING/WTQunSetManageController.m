//
//  WTQunSetManageController.m
//  WOTING
//
//  Created by jq on 2017/4/20.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunSetManageController.h"

#import "WTQunManageController.h" //选择群管理

#import "WTQunManageCell.h" //cell样式
#import "WTSetManTabCell.h"

@interface WTQunSetManageController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataSetManArr;  //设置管理数据源
    NSMutableArray  *dataDeleteX;      //选中个数
}

@end

@implementation WTQunSetManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataSetManArr = [NSMutableArray arrayWithCapacity:0];
    dataDeleteX = [NSMutableArray arrayWithCapacity:0];
    _SetManTabV.delegate = self;
    _SetManTabV.dataSource = self;

    [_BianJiBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_BianJiBtn setTitle:@"删除" forState:UIControlStateSelected];
    [_BianJiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_BianJiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    _BianJiBtn.backgroundColor = [UIColor JQTColor];
    
    _SetManTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _SetManTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self loadSetManData];
    
    [self registerSetManTabCell];
}

- (void)loadSetManData{
    
    
    NSString *QunZhu = [_dataQunDetilDict objectForKey:@"GroupMasterId"];
    NSString *Manage = [_dataQunDetilDict objectForKey:@"GroupManager"];
    BOOL  isManages;    //是否是多个群管理
    NSArray *ManageArr; //多管理
    if ([Manage containsString:@","]) {
        
        isManages = YES;
        ManageArr = [Manage componentsSeparatedByString:@","];
        
        ManageArr = [self ManageArr:ManageArr andQunStrId:QunZhu];  //去重群主
    }else{
        
        isManages = NO;
    }
    
    NSMutableArray * Marray = [NSMutableArray arrayWithCapacity:0];
    [Marray addObjectsFromArray:_dataQunManageArr];
    NSArray *TArr = [NSArray arrayWithArray:Marray];
    for (NSDictionary *dict in TArr) {
        
        if (isManages) {
            
            for (NSString *ManStr in ManageArr) {
                
                if ([dict[@"UserId"] isEqualToString:ManStr]) {
                    
                    [dataSetManArr addObject:dict];
                    [Marray removeObject:dict];
                }
            }
        }else{
            
            if ([dict[@"UserId"] isEqualToString:Manage]) {
                
                [dataSetManArr addObject:dict];
                [Marray removeObject:dict];
                
            }
        }
    }

}

- (void)registerSetManTabCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTQunManageCell" bundle:nil];
    
    [_SetManTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *cellSetNib = [UINib nibWithNibName:@"WTSetManTabCell" bundle:nil];
    
    [_SetManTabV registerNib:cellSetNib forCellReuseIdentifier:@"cellST"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else{
        
        return dataSetManArr.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 0;
    }else{
        
        return [NSString stringWithFormat:@"管理员(%lu)", dataSetManArr.count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"cellST";
        
        WTSetManTabCell *cell = (WTSetManTabCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTSetManTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        return cell;
        
    }else{
    
        static NSString *cellID = @"cellID";
        
        WTQunManageCell *cell = (WTQunManageCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunManageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        cell.contentLab.text = [NSString NULLToString:dataSetManArr[indexPath.row][@"NickName"]];
        if ([[NSString NULLToString:dataSetManArr[indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString NULLToString:dataSetManArr[indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
        }else if ([NSString NULLToString:dataSetManArr[indexPath.row][@"PortraitBig"]].length){
            
            [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,[NSString NULLToString:dataSetManArr[indexPath.row][@"PortraitBig"]]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            
        }else{
            
            cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
        }
        
        NSString *userId = dataSetManArr[indexPath.row][@"UserId"];
        //传值
        objc_setAssociatedObject(cell.XuanZhongBtn, @"UserId", userId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//实际上就是KVC
        
        [cell.XuanZhongBtn addTarget:self action:@selector(XuanZhongSetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_BianJiBtn.selected) {
            
            cell.XuanZhongBtn.hidden = NO;
        }else{
            
            cell.XuanZhongBtn.hidden = YES;
        }
        
        return cell;
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
        wtQunMVC.dataManageArr = _dataQunManageArr;
        wtQunMVC.dataQunDeDict = _dataQunDetilDict;
        wtQunMVC.contentText = @"设置群管理";
        wtQunMVC.QunType = 2;
        wtQunMVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:wtQunMVC animated:YES];
    }
}

- (void)DeleteManageWithData{
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSString *GroupId = [NSString NULLToString:_dataQunDetilDict[@"GroupId"]];
    
    NSString *DelAdminUserIds;
    NSMutableString *Mstr;
    
    
    Mstr = [NSMutableString stringWithString:dataDeleteX[0]];
    for (int i = 1; i < dataDeleteX.count; i++) {
        NSString *str = dataDeleteX[i];
        [Mstr appendFormat:@",%@",str];
    }
    
    
    DelAdminUserIds = Mstr;
    
    NSDictionary *parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",GroupId,@"GroupId",uid,@"UserId",DelAdminUserIds,@"DelAdminUserIds",nil];
    
    NSString *login_Str = WoTing_SetGroupAdmin;
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            [WKProgressHUD popMessage:@"删除管理成功" inView:nil duration:0.5 animated:YES];
            _BianJiBtn.selected = NO;
            
            [dataDeleteX removeAllObjects];
            
            [_SetManTabV reloadData];
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }else if ([ReturnType isEqualToString:@"200"]){
            
            [AutomatePlist writePlistForkey:@"Uid" value:@""];
            [WKProgressHUD popMessage:@"需要登录" inView:nil duration:0.5 animated:YES];
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

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)BianjiBtnClick:(id)sender {
    
    if (_BianJiBtn.selected){
        
        if (dataDeleteX.count > 0) {
            
            [self DeleteManageWithData];    //删除管理员
        }else{
            
            _BianJiBtn.selected = NO;
            [_SetManTabV reloadData];
        }
    }else{
        
        _BianJiBtn.selected = YES;
        [_SetManTabV reloadData];
    }
}

//cell上btn的点击事件
- (void)XuanZhongSetBtnClick:(UIButton *)btn{
    
    if (btn.selected) {
        
        btn.selected = NO;
        
        NSString *UserId = objc_getAssociatedObject(btn, @"UserId");

        NSArray *Tarr = [NSArray arrayWithArray:dataDeleteX];
        for (NSString *Str in Tarr) {   //删除
            
            if ([UserId isEqualToString:Str]) {
                
                [dataDeleteX removeObject:UserId];
            }
        }
    }else{
        
        btn.selected = YES;         //添加
        
        NSString *UserId = objc_getAssociatedObject(btn, @"UserId");
        
        [dataDeleteX addObject:UserId];
    }
    
}


//管理去群主
- (NSArray *)ManageArr:(NSArray *)Array andQunStrId:(NSString *)QunId{
    
    NSArray *Tarr = [NSArray arrayWithArray:Array];
    NSMutableArray *Marr = [NSMutableArray arrayWithCapacity:0];
    [Marr addObjectsFromArray:Array];
    for (NSString *Str in Tarr) {
        
        if ([Str isEqualToString:QunId]) {
            
            [Marr removeObject:Str];
        }
    }
    
    return [NSArray arrayWithArray:Marr];
}

@end
