//
//  WTZJTuijianController.m
//  WOTING
//
//  Created by jq on 2016/12/20.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZJTuijianController.h"

#import "WTZhanJiTJCell.h"

@interface WTZJTuijianController ()<UITableViewDelegate, UITableViewDataSource>{
    
    CGFloat  previewH;
}

@end

@implementation WTZJTuijianController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    _contentimgXQ.layer.masksToBounds = YES;
//    _contentimgXQ.layer.cornerRadius = _contentimgXQ.size.width/2;
//    [_contentimgXQ sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataXQDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@""]];
//    
//    _nameLabXQ.text = [NSString NULLToString:_dataXQDict[@"ContentName"]];
//    
//    _contentLab.text = [NSString NULLToString:_dataXQDict[@"ContentDescn"]];
//    CGFloat previewH = [_contentLab.text boundingRectWithSize:CGSizeMake(_contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
//    _ContLabHeight.constant = previewH; //高度
    
    _ZJTuiJianTab.delegate = self;
    _ZJTuiJianTab.dataSource = self;
    _ZJTuiJianTab.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self registerTableViewCellwithZhuanJi];
    
}

- (void)registerTableViewCellwithZhuanJi{
    
    UINib *nib = [UINib nibWithNibName:@"WTZhanJiTJCell" bundle:nil];
    [_ZJTuiJianTab registerNib:nib forCellReuseIdentifier:@"CellIDZJTJ"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"CellIDZJTJ";
    
    WTZhanJiTJCell *cell = (WTZhanJiTJCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    //图片
    cell.contentImgV.layer.masksToBounds = YES;
    cell.contentImgV.layer.cornerRadius = cell.contentImgV.size.width/2;
    [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataXQDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    //标题
    cell.nameLab.text = [NSString NULLToString:_dataXQDict[@"ContentName"]];
    
    //内容
    cell.contentLab.text = [NSString NULLToString:_dataXQDict[@"ContentDescn"]];
    previewH = [cell.contentLab.text boundingRectWithSize:CGSizeMake(cell.contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    cell.LabHeight.constant = previewH;
    
    //标签[17]	(null)	@"ContentCatalogs" : @"1 element"	[1]	(null)	@"CataTitle" : @"偏好设置/听故事/小说故事"
    cell.BiaoQianLab.text = _dataXQDict[@"ContentCatalogs"][0][@"CataTitle"];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 265 + previewH -21;
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

@end
