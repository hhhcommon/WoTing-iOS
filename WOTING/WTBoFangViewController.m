//
//  WTBoFangViewController.m
//  WOTING
//
//  Created by jq on 2016/11/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTBoFangViewController.h"

@interface WTBoFangViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSMutableArray  *dataBFArray;
}

@end

@implementation WTBoFangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataBFArray = [NSMutableArray arrayWithCapacity:0];
    
    _JQtableView.delegate = self;
    _JQtableView.dataSource = self;
    
    [self initHeaderView];
}


- (void)initHeaderView{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K_Screen_Width, POINT_Y(600))];
    headerView.backgroundColor = [UIColor whiteColor];
    _JQtableView.tableHeaderView = headerView;
    
    //喇叭、文字、话筒
    UIButton *LBbtn = [[UIButton alloc] init];
    [LBbtn setImage:[UIImage imageNamed:@"home_btn_traffic.png"] forState:UIControlStateNormal];
    [headerView addSubview:LBbtn];
    [LBbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(30));
        make.top.mas_equalTo(POINT_Y(35));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_Y(50));
    }];
    
    UIButton *HTbtn = [[UIButton alloc] init];
    [HTbtn setImage:[UIImage imageNamed:@"home_btn_voice search.png"] forState:UIControlStateNormal];
    [headerView addSubview:HTbtn];
    [HTbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(30));
        make.top.mas_equalTo(POINT_Y(35));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_X(50));
    }];
    
    UILabel *BTLab = [[UILabel alloc] init];
    BTLab.font = [UIFont systemFontOfSize:FONT_SIZE_OF_PX(32)];
    BTLab.text = @"稻花香";
    BTLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:BTLab];
    [BTLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(LBbtn.mas_right).with.offset(POINT_X(30));
        make.right.equalTo(HTbtn.mas_left).with.offset(-POINT_X(30));
        make.top.mas_equalTo(POINT_Y(35));
        make.height.mas_equalTo(POINT_Y(40));
    }];
    
    //播放器
    UIView *PlayView = [[UIView alloc] initWithFrame:CGRectMake(0, POINT_Y(95), K_Screen_Width, POINT_Y(450))];
    PlayView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:PlayView];
#warning 此处应用有播放器。。
    //前一首
    UIButton *QyBtn = [[UIButton alloc] init];
    [QyBtn setImage:[UIImage imageNamed:@"home_btn_last.png"] forState:UIControlStateNormal];
    [PlayView addSubview:QyBtn];
    [QyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(POINT_X(100));
        make.top.mas_equalTo(POINT_X(100));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_X(50));
    }];
    
    //后一首
    UIButton *HyBtn = [[UIButton alloc] init];
    [HyBtn setImage:[UIImage imageNamed:@"home_btn_next.png"] forState:UIControlStateNormal];
    [PlayView addSubview:HyBtn];
    [HyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-POINT_X(100));
        make.top.mas_equalTo(POINT_X(100));
        make.width.mas_equalTo(POINT_X(50));
        make.height.mas_equalTo(POINT_X(50));
    }];
    
    //
    
    //灰线
    UIImageView *lineImageView = [[UIImageView alloc] init];
    lineImageView.backgroundColor = [UIColor lightGrayColor];
    [headerView addSubview:lineImageView];
    [lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(PlayView.mas_bottom);
        make.left.mas_equalTo(POINT_X(30));
        make.right.mas_equalTo(-POINT_X(30));
        make.height.equalTo(@1);
    }];
    
    //灰线以下
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataBFArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170;
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
