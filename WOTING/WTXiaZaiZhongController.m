//
//  WTXiaZaiZhongController.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTXiaZaiZhongController.h"

#import "WTXiaZaiCell.h"


@interface WTXiaZaiZhongController ()<WTXiaZaiCellDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    
}

@end

@implementation WTXiaZaiZhongController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _XZZTableView.delegate = self;
    _XZZTableView.dataSource = self;
    
    _XZZTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _XZZTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self registerTableCell];
    
    if (_urls.count == 0||_urls == nil) {
        
        UIImageView *ImgV = [[UIImageView alloc] init];
        ImgV.image = [UIImage imageNamed:@"WuShuJu.png"];
        [self.view addSubview:ImgV];
        __weak WTXiaZaiZhongController *weakSelf = self;
        [ImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(weakSelf.view);
            make.centerY.equalTo(weakSelf.view);
            make.width.mas_equalTo(K_Screen_Width/2);
            make.height.mas_equalTo(K_Screen_Width/2);
        }];
    }
}

- (void)registerTableCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiCell" bundle:nil];
    
    [_XZZTableView registerNib:cellNib forCellReuseIdentifier:@"cellIDL"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _urls.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellIDL";
    
    WTXiaZaiCell *cell = (WTXiaZaiCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTXiaZaiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    [cell Content:_urls[indexPath.row]];
    [cell changeBeginAndStop];
    cell.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

//下载完成 ， 移除下载任务
- (void)DownLoadWithPlist:(NSString *)str {
    
    NSMutableArray *array;
    
    if ([[NSMutableArray alloc]initWithContentsOfFile:JQ__Plist_managerName(@"DownLoad")]) {
        
        array = [[NSMutableArray alloc]initWithContentsOfFile:JQ__Plist_managerName(@"DownLoad")];
    }else {
        
        array = [NSMutableArray arrayWithCapacity:0];
    }
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *writeDict = [[NSDictionary alloc] init];
    
    for (NSDictionary *dict in _urls) {
        
        if ([str isEqualToString:dict[@"ContentPlay"]]) {
            
            [_urls removeObject:dict];
            [_XZZTableView reloadData];
            if (_urls.count == 0) {
                
                UIImageView *ImgV = [[UIImageView alloc] init];
                ImgV.image = [UIImage imageNamed:@"WuShuJu.png"];
                [self.view addSubview:ImgV];
                __weak WTXiaZaiZhongController *weakSelf = self;
                [ImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                   
                    make.centerX.equalTo(weakSelf.view);
                    make.centerY.equalTo(weakSelf.view);
                    make.width.mas_equalTo(K_Screen_Width/2);
                    make.height.mas_equalTo(K_Screen_Width/2);
                }];
            }

            writeDict = [self PlistDictChange:dict];//取部分数据存储
            
            [array addObject:writeDict];
            [array writeToFile:JQ__Plist_managerName(@"DownLoad") atomically:YES];
            
        }
    }

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"YIXIAZAI" object:nil];
}

- (NSDictionary *)PlistDictChange:(NSDictionary *)dict {
    
    NSMutableDictionary *Changedict = [[NSMutableDictionary alloc] init];
    
    [Changedict setValue:[NSString NULLToString:dict[@"ContentImg"]] forKey:@"ContentImg"];
    [Changedict setValue:[NSString NULLToString:dict[@"ContentName"]] forKey:@"ContentName"];
    [Changedict setValue:dict[@"PlayCount"] forKey:@"PlayCount"];
    [Changedict setValue:[NSString NULLToString:dict[@"ContentPub"]] forKey:@"ContentPub"];
    
    return Changedict;
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
