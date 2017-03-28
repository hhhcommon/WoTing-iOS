
//
//  WTXiaZaiDetilController.m
//  WOTING
//
//  Created by jq on 2017/3/2.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTXiaZaiDetilController.h"

#import "WTXiaZaiDetilCell.h"

@interface WTXiaZaiDetilController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataDetilArr;

@end

@implementation WTXiaZaiDetilController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _dataDetilArr = [NSMutableArray arrayWithCapacity:0];
    
    _XiaZaiDetilTab.dataSource = self;
    _XiaZaiDetilTab.delegate = self;
    
    
    [self registerTableViewCell];
    [self loadData];
}

- (void)loadData {
    
    
    if (_dataDict) {
        
        if (_dataDict[@"SeqInfo"]) {
            
            _contentName.text = _dataDict[@"SeqInfo"][@"ContentName"];
        }else {
            
            _contentName.text = _dataDict[@"ContentName"];
        }
        
        _jiLab.text = [NSString stringWithFormat:@"共%@个节目", @"1"];
        _sizeLab.text = [NSString stringWithFormat:@"共%@MB",@""];
        [_dataDetilArr addObject:_dataDict];
    }
    
    [_XiaZaiDetilTab reloadData];
}

- (void)registerTableViewCell{
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiDetilCell" bundle:nil];
    
    [_XiaZaiDetilTab registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataDetilArr.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"cellID";
    
    WTXiaZaiDetilCell *cell = (WTXiaZaiDetilCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        cell = [[WTXiaZaiDetilCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    UIButton *cellBtn = cell.cleanBtn;
    
    cellBtn.tag = indexPath.row + 200;
    [cellBtn addTarget:self action:@selector(CleanClick:) forControlEvents:UIControlEventTouchUpInside];

    [cell setCellwithDict:_dataDetilArr[indexPath.row]];
    
    return cell;
}

//删除单个节目单体
- (void)CleanClick:(UIButton *)btn{
    
    int indexPath = (int)btn.tag - 200;
    
    FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
    
    
    BOOL isRept = NO;
    FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
    // 遍历结果，如果重复就删除数据

    NSString *HYCcontentID = _dataDetilArr[indexPath][@"ContentId"];
    NSString *LJQContentPlay = _dataDetilArr[indexPath][@"ContentPlay"];
    
    while ([resultSet next]) {
        
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        
        if ([HYCcontentID isEqualToString:jsonDict[@"ContentId"]]) {
            
            isRept = YES;
        }
        
    }
    
    if (isRept) {
        
        NSString *deleteSql = [NSString stringWithFormat:@"delete from XIAZAI where XIAZAINum='%@'",HYCcontentID];
        //NSLog(@"%@", deleteSql);
        //                        NSString *deleteSql = @"delete from BFLS where MusicDict";
        BOOL isOk = [db executeUpdate:deleteSql];
        
        if (isOk) {
            NSLog(@"删除数据成功! 😄");
            [_dataDetilArr removeAllObjects];
            [_XiaZaiDetilTab reloadData];
            
            //遍历文件夹
            NSString *appDocDir = [[[[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
            
            NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
            
            for (NSString *aPath in contentOfFolder) {
                
                NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
                
                if ([LJQContentPlay hasSuffix:aPath]) {
                    
                    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];   //删除数据
                    NSLog(@"删除数据成功! 😄");
                }
            }
            
        }else{
            NSLog(@"删除数据失败! 💔");
        }
        
    }
        
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSDictionary *dict = _dataDetilArr[indexPath.row];
    NSDictionary *DataDict = [[NSDictionary alloc] initWithDictionary:dict];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABLEVIEWCLICK" object:nil userInfo:DataDict];
    
    //回首页
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TABBARSELECATE" object:nil];
    
    self.tabBarController.selectedIndex = 0;
    
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
