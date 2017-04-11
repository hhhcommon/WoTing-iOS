//
//  WTDingShiController.m
//  WOTING
//
//  Created by jq on 2017/1/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTDingShiController.h"
#import "WTDingShiCell.h"
#import "MainViewController.h"



@interface WTDingShiController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSArray  *dataTimeArr;
    long number;
    
}

@end

@implementation WTDingShiController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = YES;
    
    
    
    number = [[NSUserDefaults standardUserDefaults] integerForKey:KEYHYCBOOL_______HYCKEY];
    
    
    
    
    _TimeLab.text = @"00:00";
    
    
    
    _TimeTab.delegate = self;
    _TimeTab.dataSource = self;
    
    dataTimeArr = @[@"10分钟",@"20分钟",@"30分钟",@"40分钟",@"50分钟",@"60分钟",@"不启动"];
    
    
    [[MainViewController sharedManager]  setCellSelectedBlock:^(NSString *timeLabel) {
        
        
        _TimeLab.text = timeLabel;
        
        if ([timeLabel isEqualToString:@"00:00"]) {
            
            number = 6;
            
            [self.TimeTab reloadData];
            
        }
        
        
        
    }];
    
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.TimeTab.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self hideTableViewExtraLine];
    [self registerCell];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    
    
}



- (void)registerCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTDingShiCell" bundle:nil];
    
    [_TimeTab registerNib:cellNib forCellReuseIdentifier:@"Cell"];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataTimeArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    WTDingShiCell *cell = (WTDingShiCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[WTDingShiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }
    cell._timeLab.text = [dataTimeArr objectAtIndex:indexPath.row];
    cell.imageV.hidden = YES;
    
    if (number == (long)indexPath.row) {
        
        cell.imageV.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    
    [udf setInteger:indexPath.row forKey:KEYHYCBOOL_______HYCKEY];
    
    if (indexPath.row == 6) {
        
        // [_timer setFireDate:[NSDate distantFuture]];
        
        [udf setObject:nil
                forKey:KEYHYC_______HYCKEY];
        
        _TimeLab.text = @"00:00";
        
    }else{
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        
        dateFormatter.dateFormat=@"dd:HH:mm:ss";//指定转date得日期格式化形式
        
        [udf setObject:
         
         [dateFormatter stringFromDate:
          
          [NSDate dateWithTimeInterval:(indexPath.row+1)*600 sinceDate:[NSDate date]]
          
          ]
         
                forKey:KEYHYC_______HYCKEY];
        
        [[MainViewController sharedManager] startTimer];
        
        //  [_timer setFireDate:[NSDate distantPast]];
        //  [_timer setFireDate:[NSDate distantFuture]];
    }
    number = indexPath.row;
    [_TimeTab reloadData];
    [udf synchronize];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}





//隐藏多余的行
-(void)hideTableViewExtraLine
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectZero];
    self.TimeTab.tableFooterView=view;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
