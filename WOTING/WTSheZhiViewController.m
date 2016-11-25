//
//  WTSheZhiViewController.m
//  WOTING
//
//  Created by jq on 2016/11/24.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTSheZhiViewController.h"

@interface WTSheZhiViewController ()<UITableViewDataSource, UITableViewDelegate>{
    
    /** 设置ICON */
    NSArray         *iconsArray;
    /** 设置Title */
    NSArray         *titlesArray;
}

@end

@implementation WTSheZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.JQSZtableView.delegate = self;
    self.JQSZtableView.dataSource = self;
    
    iconsArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"mine_set_icon_download.png", @"mine_set_icon_delete.png",  nil], [NSArray arrayWithObjects:@"mine_set_icon_preference.png", nil],[NSArray arrayWithObjects:@"mine_set_icon_help.png",@"mine_set_icon_feedback.png",@"mine_set_icon_about.png", nil], nil];
    
    titlesArray = [[NSArray alloc] initWithObjects:[NSArray arrayWithObjects:@"下载路径", @"清除缓存", nil], [NSArray arrayWithObjects:@"偏好设置",  nil],[NSArray arrayWithObjects:@"使用帮助",@"反馈建议",@"关于我听" , nil], nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.textLabel.font = [UIFont systemFontOfSize:FONT_SIZE_OF_PX(30)];
        cell.textLabel.textColor = [UIColor skTitleHighBlackColor];
    }
    
    cell.imageView.image = [UIImage imageNamed:[[iconsArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    cell.textLabel.text = [[titlesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    
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

- (IBAction)FanHuiBtnClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
