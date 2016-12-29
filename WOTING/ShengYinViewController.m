//
//  ShengYinViewController.m
//  WOTING
//
//  Created by jq on 2016/12/16.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "ShengYinViewController.h"

#import "WTBoFangTableViewCell.h"

@interface ShengYinViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ShengYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _SYTableView.delegate = self;
    _SYTableView.dataSource = self;
    
    [self registerTabViewCell];
}

//注册
- (void)registerTabViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTBoFangTableViewCell" bundle:nil];
    
    [_SYTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSYArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cellID";
    
    WTBoFangTableViewCell *cell = (WTBoFangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTBoFangTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    NSDictionary *dict = _dataSYArr[indexPath.row];
    [cell setCellWithDict:dict];
    
    
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
