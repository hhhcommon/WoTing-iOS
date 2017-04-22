//
//  WTYiXiaZaiController.m
//  WOTING
//
//  Created by jq on 2016/12/23.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTYiXiaZaiController.h"

#import "WTXiaZaiDetilController.h"

#import "WTXiaZaiDoneCell.h"
#import "WTXiaZaiXuanZhongCell.h"

@interface WTYiXiaZaiController ()<UITableViewDelegate, UITableViewDataSource>{
 
    NSMutableArray *dataYXZArray;   //最后的数据
    NSMutableArray *dataWeiArr;     //未处理前的数据
    
    NSMutableArray  *dataXuanZhongCellArr;  //选中cell个数
    NSInteger       *cellinteger;   //记录当前cell
    
    NSInteger   type;   //0:默认类型    1:待删除类型
    BOOL        isHeaderView;   //全选按钮状态
    BOOL        isQuanXuan;     //是否全选
}

@end

@implementation WTYiXiaZaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    dataYXZArray = [NSMutableArray arrayWithCapacity:0];
    dataWeiArr = [NSMutableArray arrayWithCapacity:0];
    dataXuanZhongCellArr = [NSMutableArray arrayWithCapacity:0];
    type = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTabVliew:) name:@"YIXIAZAI" object:nil];

    _YXZTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _YXZTableView.dataSource = self;
    _YXZTableView.delegate = self;
    
    [self loadData];
    [self registerCell];
    
   
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //通知下载完成
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"XIAZAIWANCHENG" object:nil];
    
    [dataXuanZhongCellArr removeAllObjects];    //清空选中下标
    type = 0;
    [self loadData];
}

- (void)loadData{
    
    [dataYXZArray removeAllObjects];
    [dataXuanZhongCellArr removeAllObjects];    //清空选中下标
    
    FMDatabase *fm = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
    // 1.执行查询语句
    FMResultSet *resultSet = [fm executeQuery:@"SELECT * FROM XIAZAI"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSString *isXIAZAI = [resultSet stringForColumn:@"XIAZAIBOOL"];
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        
        if ([isXIAZAI isEqualToString:@"1"]) {
            
            [dataYXZArray addObject:jsonDict];
            
        }
 
    }
    
    
     [_YXZTableView reloadData];
    
}

- (NSMutableArray *)HYC_RearrangeWitharray:(NSArray *)array andDictKeyName:(NSString *)ID{
    
    NSMutableArray *_dataHYCMarray = [NSMutableArray arrayWithArray:array];
    
    NSMutableArray *_HYCdataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < _dataHYCMarray.count - 1; i ++) {
        
        NSDictionary *HYCdictEveOne = _dataHYCMarray[i];
        BOOL addDictEveOne = NO;
        NSMutableArray *HYCeveMarr = [[NSMutableArray alloc]init];
        
        for (int h = i + 1; h < _dataHYCMarray.count; h ++) {
            
            NSDictionary *HYCdictEveTwo = _dataHYCMarray[h];
            if ([HYCdictEveOne[@"SeqInfo"][ID] isEqualToString:HYCdictEveTwo[@"SeqInfo"][ID]]) {
                
                [HYCeveMarr addObject:HYCdictEveTwo];
                addDictEveOne = YES;
                [_dataHYCMarray removeObjectAtIndex:h];
                h --;
                
            }
            
            if (addDictEveOne && h == _dataHYCMarray.count - 1) {
                
                [HYCeveMarr addObject:HYCdictEveOne];
                [_HYCdataArray addObject:HYCeveMarr];
                [_dataHYCMarray removeObjectAtIndex:i];
                i --;
                
            }
            
        }
        
    }
    [_HYCdataArray addObject:_dataHYCMarray];
    
    NSLog(@"%@",_HYCdataArray);
    return _HYCdataArray;
}


- (void)registerCell {
    
    UINib *cellNib = [UINib nibWithNibName:@"WTXiaZaiDoneCell" bundle:nil];
    
    [_YXZTableView registerNib:cellNib forCellReuseIdentifier:@"cellID"];
    
    UINib *cellXZNib = [UINib nibWithNibName:@"WTXiaZaiXuanZhongCell" bundle:nil];
    
    [_YXZTableView registerNib:cellXZNib forCellReuseIdentifier:@"cellIDXZ"];
    
}

//新增下载任务完成后的通知
- (void)reloadTabVliew:(NSNotification *)not {
    
    [dataYXZArray removeAllObjects];    //清空数据源
    
    FMDatabase *fm = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
    // 1.执行查询语句
    FMResultSet *resultSet = [fm executeQuery:@"SELECT * FROM XIAZAI"];
    // 2.遍历结果
    while ([resultSet next]) {
        
        NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
        
        if ([resultSet boolForColumn:@"XIAZAIBOOL"]) {
            
            [dataYXZArray addObject:jsonDict];
        }

    }
    
    [_YXZTableView reloadData];
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (type == 0) {
        
        if (dataYXZArray.count != 0) {
            
            UIButton *cleanbtn = [[UIButton alloc] init];
            [cleanbtn addTarget:self action:@selector(ChangeViewClick) forControlEvents:UIControlEventTouchUpInside];
            [cleanbtn setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [view addSubview:cleanbtn];
            
            [cleanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(-30);
                make.top.mas_equalTo(11);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
        }
        
    }else{
        
        if (dataYXZArray.count != 0) {
            
            UIButton *cleanbtn = [[UIButton alloc] init];
            [cleanbtn addTarget:self action:@selector(CleanBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [cleanbtn setImage:[UIImage imageNamed:@"icon_delete.png"] forState:UIControlStateNormal];
            [view addSubview:cleanbtn];
            
            [cleanbtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(-30);
                make.top.mas_equalTo(11);
                make.width.mas_equalTo(20);
                make.height.mas_equalTo(20);
            }];
            
            UIButton *XuanBtn = [[UIButton alloc] init];
            [XuanBtn addTarget:self action:@selector(QuanXuanClick:) forControlEvents:UIControlEventTouchUpInside];
            [XuanBtn setImage:[UIImage imageNamed:@"WeiXuanZhong.png"] forState:UIControlStateNormal];
            [XuanBtn setImage:[UIImage imageNamed:@"XuanZhong.png"] forState:UIControlStateSelected];
            if (isHeaderView) {
                
                XuanBtn.selected = YES;
            }else{
                
                XuanBtn.selected = NO;
            }
            [view addSubview:XuanBtn];
            
            [XuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(17);
                make.top.mas_equalTo(14.5);
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(15);
            }];
            
            UILabel *QuanXuanLab = [[UILabel alloc] init];
            QuanXuanLab.text = @"全选";
            QuanXuanLab.font = [UIFont systemFontOfSize:14];
            [view addSubview:QuanXuanLab];
            
            [QuanXuanLab mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(XuanBtn.mas_right).with.offset(10);
                make.top.equalTo(XuanBtn.mas_top);
                make.width.mas_equalTo(50);
                make.height.equalTo(XuanBtn.mas_height);
            }];
        }
        
    }

    return view;

}

//点击改变界面
- (void)ChangeViewClick{
    
    if (type == 0) {
        
        type = 1;
        [_YXZTableView reloadData];
    }
    
}

//点击删除
- (void)CleanBtnClick {
    
    if (isQuanXuan) {

        //遍历文件夹
        NSString *appDocDir = [[[[NSFileManager defaultManager] URLsForDirectory: NSCachesDirectory inDomains:NSUserDomainMask] lastObject] relativePath];
        
        NSArray *contentOfFolder = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:appDocDir error:NULL];
        int count = 1;
        for (NSString *aPath in contentOfFolder) {
            
            NSString * fullPath = [appDocDir stringByAppendingPathComponent:aPath];
            BOOL isDir = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath isDirectory:&isDir])
            {
                
                NSLog(@"dir-%d: %@", count, aPath);
                
                if ([aPath hasSuffix:@".m4a"] || [aPath hasSuffix:@".mp3"] ) {
                    
                    [[NSFileManager defaultManager] removeItemAtPath:fullPath error:nil];
                }
                
                count++;
               
            }
        }
        
        FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
        BOOL isok = [db executeUpdate:@"DELETE FROM XIAZAI"];
        if (isok) {
            
            NSLog(@"全部删除"); //全部删除
            [dataYXZArray removeAllObjects];
            type = 0;
            [_YXZTableView reloadData];
            
        }
        
    
    }else { //还原 type
        
        if (dataXuanZhongCellArr.count) {
            
            FMDatabase *db = [FMDBTool createDatabaseAndTable:@"XIAZAI"];
            
            
            BOOL isRept = NO;
            FMResultSet *resultSet = [db executeQuery:@"SELECT * FROM XIAZAI"];
            // 遍历结果，如果重复就删除数据
            
            for (NSString *HYCstr in dataXuanZhongCellArr) {

                NSString *HYCcontentID = dataYXZArray[[HYCstr intValue]][@"ContentId"];
                NSString *LJQContentPlay = dataYXZArray[[HYCstr intValue]][@"ContentPlay"];
                
                while ([resultSet next]) {
                    
                    NSData *ID = [resultSet dataForColumn:@"XIAZAI"];
                    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:ID options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([HYCcontentID isEqualToString:jsonDict[@"ContentId"]]) {
                        
                        isRept = YES;
                    }
                    
                }
                
                if (isRept) {
                    
                    NSString *deleteSql = [NSString stringWithFormat:@"delete from XIAZAI where XIAZAINum='%@'",HYCcontentID];

                    BOOL isOk = [db executeUpdate:deleteSql];
                    
                    if (isOk) {
                        NSLog(@"删除数据成功! 😄");
                        [self loadData];    //加载数据
                        type = 0;
                        
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
            
        }else{

            type = 0;
            [dataXuanZhongCellArr removeAllObjects];    //清空选中下标
            [_YXZTableView reloadData];
        }
    }
    
}

//全选
- (void)QuanXuanClick:(UIButton *)btn {
    
    btn.selected ^= 1;
    
    if (btn.selected == YES) {
        isHeaderView = YES;
        isQuanXuan = YES;   //全选
        [_YXZTableView reloadData];
    }else {
        isHeaderView = NO;
        isQuanXuan = NO;
        [_YXZTableView reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataYXZArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (type == 0) {    //正常状态下的下载cell
        
        static NSString *cellID = @"cellID";
        
        WTXiaZaiDoneCell *cell = (WTXiaZaiDoneCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTXiaZaiDoneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        if (dataYXZArray[indexPath.row][@"SeqInfo"]) {
            
            [cell setCellWithDict:dataYXZArray[indexPath.row][@"SeqInfo"]];
        }else{
            
            [cell setCellWithDict:dataYXZArray[indexPath.row]];
        }
        
        return cell;
        
    }else{      //处于待选择删除状态的cell
        
        static NSString *cellID = @"cellIDXZ";
        
        WTXiaZaiXuanZhongCell *cell = (WTXiaZaiXuanZhongCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[WTXiaZaiXuanZhongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        
        UIButton *cellBtn = cell.XuanZhongBtn;
        
        cellBtn.tag = indexPath.row + 100;
        [cellBtn addTarget:self action:@selector(XuanZhongBtnClick:) forControlEvents:UIControlEventTouchUpInside];

        if (dataYXZArray[indexPath.row][@"SeqInfo"]) {
            
            [cell setCellWithDict:dataYXZArray[indexPath.row][@"SeqInfo"]];
        }else{
            
            [cell setCellWithDict:dataYXZArray[indexPath.row]];
        }
        
        if (isQuanXuan) {
            
            cell.XuanZhongBtn.selected = YES;
        }else {
            
            cell.XuanZhongBtn.selected = NO;
        }
        
        return cell;
    }
    
}

#pragma mark -选中事件
- (void)XuanZhongBtnClick:(UIButton *)btn{
    
    
    if (btn.selected) {
        
        [dataXuanZhongCellArr removeObject:[NSString stringWithFormat:@"%ld",(long)btn.tag - 100]];
        
        btn.selected = NO;
        
        if (dataXuanZhongCellArr.count != dataYXZArray.count){
            
            isHeaderView = NO;
            isQuanXuan = NO;   //全选
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
            [_YXZTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else{

        [dataXuanZhongCellArr addObject:[NSString stringWithFormat:@"%ld",(long)btn.tag - 100]];
        
        btn.selected = YES;
        
        if (dataXuanZhongCellArr.count == dataYXZArray.count) {
            
            isHeaderView = YES;
            isQuanXuan = YES;   //全选
            [_YXZTableView reloadData];
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.000000000001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dict = dataYXZArray[indexPath.row];
    
    WTXiaZaiDetilController *WTXZDetil = [[WTXiaZaiDetilController alloc] init];
    WTXZDetil.dataDict = dict;
    [self.navigationController pushViewController:WTXZDetil animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
