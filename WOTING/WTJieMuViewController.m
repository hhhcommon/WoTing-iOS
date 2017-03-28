//
//  WTJieMuViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTJieMuViewController.h"

#import "WTBoFangTableViewCell.h"
#import "WTJMXQTableCell.h"


@interface WTJieMuViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    CGFloat  contentHeigth;
}

@end

@implementation WTJieMuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _JMXQTabV.delegate = self;
    _JMXQTabV.dataSource = self;
    
    [self registerTabJMCell];
}

- (void)registerTabJMCell{
    
    UINib *nib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    [_JMXQTabV registerNib:nib forCellReuseIdentifier:@"CellIDBF"];
    
    UINib *nibJM = [UINib nibWithNibName:@"WTJMXQTableCell" bundle:nil];
    [_JMXQTabV registerNib:nibJM forCellReuseIdentifier:@"CellIDJM"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }else{
        
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0.000000000001;
    }else{
        
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return 70;
    }else{
        
        return 410 + contentHeigth - 21;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"CellIDBF";
        
        WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (_dataDictJM != nil) {
            
            NSDictionary *dict = [NSDictionary dictionaryWithDictionary:_dataDictJM];
            [cell setCellWithDict:dict];
        }
        
        cell.WTBoFangImgV.hidden = YES;
        
        return cell;
    }else{
        
        static NSString *cellID = @"CellIDJM";
        
        WTJMXQTableCell *cell = (WTJMXQTableCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (_dataDictJM != nil) {
            
            cell.contentImageName.layer.cornerRadius = 45/2.0;
            cell.contentImageName.layer.masksToBounds = YES;
            [cell.contentImageName sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataDictJM[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@"img_radio_default"]];
            
            cell.fromLab.text = [NSString NULLToString:_dataDictJM[@"ContentPub"]];
            
            cell.contentLab.text = [NSString NULLToString:_dataDictJM[@"ContentDescn"]];
            contentHeigth = [cell.contentLab.text boundingRectWithSize:CGSizeMake(cell.contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
            cell.ContentHeight.constant = contentHeigth;
            
            if (_dataDictJM[@"ContentPersons"]) {//[12]	(null)	@"ContentPersons" : @"1 element"[0]	(null)	@"RefName" : @"主播"[2]	(null)	@"PerName" : @"我是宋小明啊"[5]	(null)	@"ContentPub" : @"喜马拉雅"
                cell.contantNameLab.text = [NSString NULLToString:_dataDictJM[@"ContentPersons"][0][@"PerName"]];
                
            }else{
                
                cell.contantNameLab.text = @"暂无主播信息";
            }
            
            if (_dataDictJM[@"ContentCatalogs"]) { //[14]	(null)	@"ContentCatalogs" : @"1 element" [1]	(null)	@"CataTitle" : @"内容分类/脱口秀场"
                
                cell.BiaoQianLab.text = [NSString NULLToString:_dataDictJM[@"ContentCatalogs"][0][@"CataTitle"]];
            }else{
                
                cell.BiaoQianLab.text = @"暂无标签";
            }
            
            
        }
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
