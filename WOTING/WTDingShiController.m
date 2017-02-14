//
//  WTDingShiController.m
//  WOTING
//
//  Created by jq on 2017/1/10.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTDingShiController.h"
#import "WTDingShiCell.h"

@interface WTDingShiController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSArray  *dataTimeArr;
    long number;
    NSInteger timefirst;    //0为第一次
}

@property (nonatomic,assign)NSInteger Timenumber;   //倒计时
@property (nonatomic,strong)NSTimer *timer;
//定时器属性

@end

@implementation WTDingShiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    timefirst = 0;
    number = 6;
    _TimeLab.text = @"00:00";
    _TimeTab.delegate = self;
    _TimeTab.dataSource = self;
    
    dataTimeArr = @[@"10分钟",@"20分钟",@"30分钟",@"40分钟",@"50分钟",@"60分钟",@"不启动"];
    
    [self registerCell];
}

- (void)createTime {
    timefirst = 1;
    
    NSDictionary *userInfo = @{@"key":@"value"};
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.f target:self selector:@selector(runTime:) userInfo:userInfo repeats:YES];
}

- (void)runTime:(NSTimer *)time {
    
    _Timenumber--;
    
    _TimeLab.text = [WKProgressHUD timeFormatted:_Timenumber];
    
    if (_Timenumber == -1) {
        
        exit(0);
    }
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
    
    if (timefirst == 0) {
        
        [self createTime];
    }
    
    if (indexPath.row == 0) {
        
        _Timenumber = 10*60 -1;
    }else if (indexPath.row == 1) {
        
        _Timenumber = 20*60 -1;
    }else if (indexPath.row == 2) {
        
        _Timenumber = 30*60 -1;
    }else if (indexPath.row == 3) {
        
        _Timenumber = 40*60 -1;
    }else if (indexPath.row == 4) {
        
        _Timenumber = 50*60 -1;
    }else if (indexPath.row == 5) {
        
        _Timenumber = 60*60 -1;
    }else if (indexPath.row == 6) {
        
        [_timer invalidate];
        timefirst = 0;
        _TimeLab.text = @"00:00";
    }
    
    
    number = indexPath.row;
    [_TimeTab reloadData];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
