//
//  WTFriendDetailsController.m
//  WOTING
//
//  Created by jq on 2017/4/12.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTFriendDetailsController.h"

#import "WTQunAndFriendDetailsCell.h"   //资料cell
#import "WTFriDetailQMingCell.h"        //好友签名
#import "WTQunShouQiCell.h"             //收起展开
#import "WTFriAddFCell.h"               //添加好友
#import "WTQuitQunCell.h"               //添加或删除好友

@interface WTFriendDetailsController ()<UITableViewDelegate, UITableViewDataSource>{
    
    BOOL    isSQ; //签名显示与收起
    
}

@end

@implementation WTFriendDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    isSQ = NO;
    
    _FriendTabV.delegate = self;
    _FriendTabV.dataSource = self;
    
    _FriendTabV.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerFriendDetailsTabCell];
}

- (void)registerFriendDetailsTabCell{
    //资料
    UINib *cellNib = [UINib nibWithNibName:@"WTQunAndFriendDetailsCell" bundle:nil];
    
    [_FriendTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    //好友签名
    UINib *cellQMNib = [UINib nibWithNibName:@"WTFriDetailQMingCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQMNib forCellReuseIdentifier:@"cellQM"];
    
    //收起
    UINib *cellSQNib = [UINib nibWithNibName:@"WTQunShouQiCell" bundle:nil];
    
    [_FriendTabV registerNib:cellSQNib forCellReuseIdentifier:@"cellSQ"];
    
    //添加好友编辑
    UINib *cellQMConNib = [UINib nibWithNibName:@"WTFriAddFCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQMConNib forCellReuseIdentifier:@"cellADD"];
    
    
    //添加或删除
    UINib *cellQTNib = [UINib nibWithNibName:@"WTQuitQunCell" bundle:nil];
    
    [_FriendTabV registerNib:cellQTNib forCellReuseIdentifier:@"cellQT"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return 200;
    }else if (indexPath.row == 1){
        
        return 100;
    }else if (indexPath.row == 2){
        
        return 21;
    }else if (indexPath.row == 3){
        
        return 120;
    }else{
        
        return 60;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        static NSString *cellID = @"cellID";
        
        WTQunAndFriendDetailsCell *cell = (WTQunAndFriendDetailsCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunAndFriendDetailsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_dataFriDict.count) {
            //图片
            if ([[NSString NULLToString:_dataFriDict[@"PortraitBig"]] hasPrefix:@"http"]) {
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataFriDict[@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else if ([NSString NULLToString:_dataFriDict[@"PortraitBig"]].length){
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataFriDict[@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
            //文字
            cell.NickLab.text = [NSString NULLToString:_dataFriDict[@"GroupName"]];
        }
//            _QunNumber.text = [NSString stringWithFormat:@"群号: %@",[NSString NULLToString:_dataFriDict[@"GroupNum"]]];
//            _QunName.text = [NSString NULLToString:_dataFriDict[@"GroupSignature"]];
        
        return cell;
    }else if (indexPath.row == 1){  //群签名
        
        static NSString *cellID = @"cellQM";
        
        WTFriDetailQMingCell *cell = (WTFriDetailQMingCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTFriDetailQMingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.contentLab.text = _dataFriDict[@""];
        
        return cell;
    }else if (indexPath.row == 2){  //收起
        
        static NSString *cellID = @"cellSQ";
        
        WTQunShouQiCell *cell = (WTQunShouQiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQunShouQiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.shouQiBtn addTarget:self action:@selector(shouQiBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
    }else if (indexPath.row == 3){  //添加好友编辑
        
        static NSString *cellID = @"cellADD";
        
        WTFriAddFCell *cell = (WTFriAddFCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTFriAddFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        if (_FriendDetailType == 0) {
            
            cell.ContentTextF.hidden = YES;
            cell.HaoyouLab.hidden = YES;
        }else{
            
            cell.ContentTextF.hidden = NO;
            cell.HaoyouLab.hidden = NO;
        }
        
        return cell;
    }else {  //添加或删除
        
        static NSString *cellID = @"cellQT";
        
        WTQuitQunCell *cell = (WTQuitQunCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTQuitQunCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (_FriendDetailType == 0) {
            
            [cell.QuitBtn setTitle:@"删除好友" forState:UIControlStateNormal];
            cell.QuitBtn.backgroundColor = [UIColor JQTColor];
            cell.backgroundColor = [UIColor whiteColor];
        }else{
            
            [cell.QuitBtn setTitle:@"添加对方为好友" forState:UIControlStateNormal];
            cell.QuitBtn.backgroundColor = [UIColor JQTColor];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        return cell;
    }
}



- (void)shouQiBtn:(UIButton *)btn{
    
    if (btn.selected) {
        
        btn.selected = NO;
        isSQ = NO;
        [_FriendTabV reloadData];
    }else{
        
        btn.selected = YES;
        isSQ = YES;
        [_FriendTabV reloadData];
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
