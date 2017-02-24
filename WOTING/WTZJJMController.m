//
//  WTZJJMController.m
//  WOTING
//
//  Created by jq on 2016/12/20.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZJJMController.h"

#import "WTZhuanJiCell.h"

@interface WTZJJMController ()<UITableViewDelegate, UITableViewDataSource>{
    
    BOOL isHeaderViewSelected;
}

@end

@implementation WTZJJMController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _ZJJieMTabV.delegate = self;
    _ZJJieMTabV.dataSource = self;
    _ZJJieMTabV.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    isHeaderViewSelected = NO;
    [self registerTableViewCell];
}

- (void)registerTableViewCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTZhuanJiCell" bundle:nil];
    
    [_ZJJieMTabV registerNib:cellNib forCellReuseIdentifier:@"cellIDL"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataZJArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    static NSString *cellID = @"cellIDL";
    
    WTZhuanJiCell *cell = (WTZhuanJiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTZhuanJiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = _dataZJArr[indexPath.row];
    
    [cell setCellWithDict:dict];
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *labeltitle = [[UILabel alloc] init];
    labeltitle.text = [NSString stringWithFormat:@"共%lu集", _dataZJArr.count];
    labeltitle.font = [UIFont boldSystemFontOfSize:15];
    labeltitle.textColor = [UIColor skTitleCenterBlackColor];
    [view addSubview:labeltitle];
    
    [labeltitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(24);
    }];
    
    UIButton *DownLoadBtn = [[UIButton alloc] init];
    [DownLoadBtn addTarget:self action:@selector(DownLoadBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [DownLoadBtn setImage:[UIImage imageNamed:@"ZJ_DownLoad.png"] forState:UIControlStateNormal];
    [view addSubview:DownLoadBtn];
    [DownLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    UIButton *PaiXuBtn = [[UIButton alloc] init];
    [PaiXuBtn addTarget:self action:@selector(PaiXuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [PaiXuBtn setImage:[UIImage imageNamed:@"PaiXu_Nol.png"] forState:UIControlStateNormal];
    [PaiXuBtn setImage:[UIImage imageNamed:@"PaiXu_Sele.png"] forState:UIControlStateSelected];
    if (isHeaderViewSelected) {
        
        PaiXuBtn.selected = YES;
    }else{
        
        PaiXuBtn.selected = NO;
    }
    [view addSubview:PaiXuBtn];
    [PaiXuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(DownLoadBtn.mas_left).with.offset(-30);
        make.top.mas_equalTo(10);
        make.width.mas_equalTo(24);
        make.height.mas_equalTo(24);
    }];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = _dataZJArr[indexPath.row];
    NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
 
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//专辑下载
- (void)DownLoadBtnClick:(UIButton *)btn{
    
    
    
}

//专辑排序
- (void)PaiXuBtnClick:(UIButton *)btn {
    
    NSArray* reversedArray = [[_dataZJArr reverseObjectEnumerator] allObjects];
    [_dataZJArr removeAllObjects];
    [_dataZJArr addObjectsFromArray:reversedArray];
    if (isHeaderViewSelected == YES) {
        isHeaderViewSelected = NO;
    }else{
        isHeaderViewSelected = YES;
    }
    [_ZJJieMTabV reloadData];
    
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
