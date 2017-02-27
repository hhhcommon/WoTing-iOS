//
//  AllViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "AllViewController.h"

#import "WTZhuanJiViewController.h"

#import "WTLikeView.h"

#import "WTBoFangTableViewCell.h"
#import "WTLikeCell.h"

@interface AllViewController ()<UITableViewDelegate, UITableViewDataSource, WTLikeViewDelegate>{
    
    WTLikeView      *wtLikeView;
    
    NSMutableArray  *dataLikeArr;
    NSMutableArray  *dataSYArr;     //声音
    NSMutableArray  *dataZJArr;     //专辑
    NSMutableArray  *dataDTArr;     //电台
}

@end

@implementation AllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataLikeArr = [NSMutableArray arrayWithCapacity:0];
    dataSYArr = [NSMutableArray arrayWithCapacity:0];
    dataZJArr = [NSMutableArray arrayWithCapacity:0];
    dataDTArr = [NSMutableArray arrayWithCapacity:0];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _likeTabV.delegate = self;
    _likeTabV.dataSource = self;
    
    _likeTabV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _likeTabV.tableFooterView = [[UIView alloc] init];
    
    [self registerTabViewCell];
    
    if (_dataAllArray) {    //播放历史
        
        [_likeTabV reloadData];
    }else{
        
        [self loadDAtaLike];
    }
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_likeTabV registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *LikecellNib = [UINib nibWithNibName:@"WTLikeCell" bundle:nil];
    
    [_likeTabV registerNib:LikecellNib forCellReuseIdentifier:@"cellIDL"];
}

- (void)loadDAtaLike {
    
    NSString *uid = [AutomatePlist readPlistForKey:@"Uid"];
    
    NSString *IMEI = [AutomatePlist readPlistForKey:@"IMEI"];
    NSString *ScreenSize = [AutomatePlist readPlistForKey:@"ScreenSize"];
    NSString *MobileClass = [AutomatePlist readPlistForKey:@"MobileClass"];
    NSString *GPS_longitude = [AutomatePlist readPlistForKey:@"GPS-longitude"];
    NSString *GPS_latitude = [AutomatePlist readPlistForKey:@"GPS-latitude"];
    
    NSDictionary *parameters;
    NSString *login_Str;
    
    if ( _SearchStr == nil) {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",@"2",@"ResultType", nil];
        
        login_Str = WoTing_likeList;
        
    }else {
        
        parameters = [[NSDictionary alloc] initWithObjectsAndKeys:IMEI,@"IMEI", ScreenSize,@"ScreenSize",@"1",@"PCDType", MobileClass, @"MobileClass",GPS_longitude,@"GPS-longitude", GPS_latitude,@"GPS-latitude",uid,@"UserId",_SearchStr,@"SearchStr", nil];
        
        login_Str = WoTing_searchBy;
        
    }
    
    
    [ZCBNetworking postWithUrl:login_Str refreshCache:YES params:parameters success:^(id response) {
        
        
        NSDictionary *resultDict = (NSDictionary *)response;
        
        NSString  *ReturnType = [resultDict objectForKey:@"ReturnType"];
        if ([ReturnType isEqualToString:@"1001"]) {
            
            if ( _SearchStr == nil) {
                
                NSDictionary *ResultList = resultDict[@"ResultList"];
                
                [dataLikeArr addObjectsFromArray: ResultList[@"FavoriteList"]];
                
                [_likeTabV reloadData];
                
            }else {
                
                NSMutableArray *Rarray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *Aarray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *Sarray = [NSMutableArray arrayWithCapacity:0];
                NSMutableDictionary *dictR = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableDictionary *dictA = [NSMutableDictionary dictionaryWithCapacity:0];
                NSMutableDictionary *dictS = [NSMutableDictionary dictionaryWithCapacity:0];
                [dictR setObject:@"RADIO" forKey:@"MediaType"];
                [dictA setObject:@"AUDIO" forKey:@"MediaType"];
                [dictS setObject:@"SEQU" forKey:@"MediaType"];
                for (NSDictionary *dict in resultDict[@"ResultList"][@"List"]) {
                    
                    if ([dict[@"MediaType"] isEqualToString: @"RADIO"]) {
                        
                        [Rarray addObject:dict];
                        [dictR setObject:Rarray forKey:@"List"];
                        
                        
                    }else if ([dict[@"MediaType"] isEqualToString: @"AUDIO"]) {
                        
                        [Aarray addObject:dict];
                        [dictA setObject:Aarray forKey:@"List"];
                        
                    }else if ([dict[@"MediaType"] isEqualToString: @"SEQU"]){
                        
                        [Sarray addObject:dict];
                        [dictS setObject:Sarray forKey:@"List"];
                        
                    }
                    
                }
                if (Rarray.count != 0) {
                    
                    [dataLikeArr addObject:dictR];
                }
                if (Aarray.count != 0) {
                    
                    [dataLikeArr addObject:dictA];
                }
                if (Sarray.count != 0) {
                    
                    [dataLikeArr addObject:dictS];
                }
                
                [_likeTabV reloadData];
                
            }
            
        }else if ([ReturnType isEqualToString:@"T"]){
            
            [WKProgressHUD popMessage:@"服务器异常" inView:nil duration:0.5 animated:YES];
        }
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
    
    
    
}

- (void)likeNSNotification:(NSString *)str {
    
    NSDictionary *dict = @{@"Str":str};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LIKELISTCHANGE" object:nil userInfo:dict];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_dataAllArray) {    //播放历史
        
        return _dataAllArray.count;
    }else{
    
        return dataLikeArr.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataAllArray) {    //播放历史
        
        NSArray *array = _dataAllArray[section][@"List"];
        
        if (array.count >= 3) {
            
            return 3;
        }else {
            
            return array.count;
        }
        
        
    }else{
        NSArray *array = dataLikeArr[section][@"List"];
        
        if (array.count >= 3) {
            
            return 3;
        }else {
            
            return array.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return 0.000000000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    wtLikeView = [[WTLikeView alloc] init];
    
    if (_dataAllArray) {    //播放历史
        
        if ([_dataAllArray[section][@"MediaType"] isEqualToString: @"RADIO"]) {
            
            wtLikeView.NameLab.text = @"电台";
        }else if ([_dataAllArray[section][@"MediaType"] isEqualToString: @"AUDIO"]) {
            
            wtLikeView.NameLab.text = @"声音";
        }
    }else {
        if ([dataLikeArr[section][@"MediaType"] isEqualToString: @"RADIO"]) {
            
            wtLikeView.NameLab.text = @"电台";
        }else if ([dataLikeArr[section][@"MediaType"] isEqualToString: @"AUDIO"]) {
            
            wtLikeView.NameLab.text = @"声音";
        }else if ([dataLikeArr[section][@"MediaType"] isEqualToString: @"SEQU"]){
            
            wtLikeView.NameLab.text = @"专辑";
        }
    }
    wtLikeView.delegate = self;
    
    return wtLikeView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dataAllArray) {    //播放历史
        
        if ([_dataAllArray[indexPath.section][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            static NSString *cellID = @"cellIDL";
            
            WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            NSDictionary *dict = _dataAllArray[indexPath.section][@"List"][indexPath.row];;
            [cell setCellWithDict:dict];
            
            
            return cell;
        }else {
            
            static NSString *cellID = @"cellID";
            
            WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.WTBoFangImgV.hidden = YES;
            NSDictionary *dict = _dataAllArray[indexPath.section][@"List"][indexPath.row];
            [cell setCellWithDict:dict];
            
            
            return cell;
        }
    }else {
    
        if ([dataLikeArr[indexPath.section][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            static NSString *cellID = @"cellIDL";
            
            WTLikeCell *cell = (WTLikeCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTLikeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            
            NSDictionary *dict = dataLikeArr[indexPath.section][@"List"][indexPath.row];;
            [cell setCellWithDict:dict];
            
            
            return cell;
        }else {
            
            static NSString *cellID = @"cellID";
            
            WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            }
            cell.WTBoFangImgV.hidden = YES;
            NSDictionary *dict = dataLikeArr[indexPath.section][@"List"][indexPath.row];
            [cell setCellWithDict:dict];
            
            
            return cell;
        }
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_dataAllArray) {    //播放历史
        
        if ([_dataAllArray[indexPath.section][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
            
            wtZJVC.contentID = [NSString NULLToString:_dataAllArray[indexPath.section][@"List"][indexPath.row][@"ContentId"]] ;
            [self.navigationController pushViewController:wtZJVC animated:YES];
            
        }else{
            
            NSDictionary *dict = _dataAllArray[indexPath.section][@"List"][indexPath.row];
            NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
            [self.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        }
    }else {
        if ([dataLikeArr[indexPath.section][@"MediaType"] isEqualToString:@"SEQU"]) {
            
            WTZhuanJiViewController *wtZJVC = [[WTZhuanJiViewController alloc] init];
            
            wtZJVC.contentID = [NSString NULLToString:dataLikeArr[indexPath.section][@"List"][indexPath.row][@"ContentId"]] ;
            [self.navigationController pushViewController:wtZJVC animated:YES];
            
        }else{
            
            NSDictionary *dict = dataLikeArr[indexPath.section][@"List"][indexPath.row];
            NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
        }
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
