//
//  WTJieMuXQViewController.m
//  WOTING
//
//  Created by jq on 2017/2/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTJieMuXQViewController.h"

#import "WTJMDCell.h"

@interface WTJieMuXQViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    
}

@end

@implementation WTJieMuXQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _JieMuDanTab.delegate = self;
    _JieMuDanTab.dataSource = self;
    
    [self RegisterJMDCell];
    
}

- (void)RegisterJMDCell {
    
    UINib *nib = [UINib nibWithNibName:@"WTJMDCell" bundle:nil];
    
    [_JieMuDanTab registerNib:nib forCellReuseIdentifier:@"cellJMD"];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataJMDArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
    static NSString *cellID = @"cellJMD";
    
    WTJMDCell *cell = (WTJMDCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTJMDCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    //WTJMDCell *cell = [[WTJMDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    cell.NameLab.text = _dataJMDArr[indexPath.row][@"Title"];
    
    NSString *beginStr = _dataJMDArr[indexPath.row][@"BeginTime"];
    beginStr = [beginStr substringToIndex:5];
    NSString *endStr = _dataJMDArr[indexPath.row][@"EndTime"];
    endStr = [endStr substringToIndex:5];
    cell.TimeLab.text = [NSString stringWithFormat:@"%@-%@",beginStr, endStr];
    
    cell.ZhiBoImgV.hidden = YES;
  
    if (_timeSp != nil) {
        NSDate *senddate = [NSDate date];

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        NSString *currentStr = [dateFormatter stringFromDate: senddate];
        NSArray *strArr = [currentStr componentsSeparatedByString:@" "];
        NSString *Rstr = strArr[1];
        
        //1.创建一个时间格式
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        //2.设置时间格式
        [df setDateFormat:@"mm:ss"];
        
        //3.提取
        NSDate *dateBegin = [df dateFromString:beginStr];
        NSDate *dateEnd = [df dateFromString:endStr];
        NSDate *dateRstr = [df dateFromString:Rstr];
        
        NSComparisonResult result1 = [dateRstr compare:dateBegin];
        NSComparisonResult result2 = [dateRstr compare:dateEnd];
        
        if (result1 == NSOrderedDescending && result2 == NSOrderedAscending) {
            
            cell.TimeLab.textColor = [UIColor blackColor];
            cell.NameLab.textColor = [UIColor blackColor];
            cell.ZhiBoImgV.hidden = NO;
        }else{
            
            cell.TimeLab.textColor = [UIColor lightGrayColor];
            cell.NameLab.textColor = [UIColor lightGrayColor];
            cell.ZhiBoImgV.hidden = YES;
        }
        
        
    }
    
    return cell;
    
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
