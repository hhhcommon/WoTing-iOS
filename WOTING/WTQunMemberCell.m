//
//  WTQunMemberCell.m
//  WOTING
//
//  Created by jq on 2017/4/13.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "WTQunMemberCell.h"

#import "WTFriendDetailsController.h"   //好友详情
#import "WTQunManageController.h"       //群管理界面

#import "WTQunCYCell.h" //成员样式

@interface WTQunMemberCell ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    
    BOOL  isCY; //是否是普通成员
}

@end

@implementation WTQunMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView:) name:@"RELOADCOLLECTION" object:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(K_Screen_Width/4, K_Screen_Width/4)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    _QunMemberContectionV.delegate = self;
    _QunMemberContectionV.dataSource = self;
    _QunMemberContectionV.scrollEnabled = NO;
    [_QunMemberContectionV setCollectionViewLayout:flowLayout];
    
    [_QunMemberContectionV registerNib:[UINib nibWithNibName:@"WTQunCYCell" bundle:nil] forCellWithReuseIdentifier:@"MyCollectionCell"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// 返回分区数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

// 每个分区多少个item
- (NSInteger )collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (isCY) {
        
        if (_dataQunMemArr.count >= 8) {
            
            return 8;
        }else{
            
            return _dataQunMemArr.count;
            
        }
    }else{
    
        if (_dataQunMemArr.count > 6) {
            
            return 8;
        }else{
            
            return _dataQunMemArr.count + 2;
            
        }
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isCY) {
        
        WTQunCYCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
        if (_dataQunMemArr.count != 0) {
            
            cell.contentLab.text = [NSString NULLToString:_dataQunMemArr[indexPath.row][@"NickName"]];
            
            if ([[NSString NULLToString:_dataQunMemArr[indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataQunMemArr[indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
            }else if ([NSString NULLToString:_dataQunMemArr[indexPath.row][@"PortraitBig"]].length){
                
                [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataQunMemArr[indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                
            }else{
                
                cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
            }
            
        }
        
        return cell;
    }else{
    
        WTQunCYCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCollectionCell" forIndexPath:indexPath];
        if (_dataQunMemArr.count != 0) {
            
            if (indexPath.row < _dataQunMemArr.count ) {
                
                cell.KuangImgV.hidden = NO;
                
                cell.contentLab.text = [NSString NULLToString:_dataQunMemArr[indexPath.row][@"NickName"]];
                
                if ([[NSString NULLToString:_dataQunMemArr[indexPath.row][@"PortraitBig"]] hasPrefix:@"http"]) {
                    [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataQunMemArr[indexPath.row][@"PortraitBig"]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                }else if ([NSString NULLToString:_dataQunMemArr[indexPath.row][@"PortraitBig"]].length){
                    
                    [cell.contentImgV sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:[NSString stringWithFormat:@"%@%@", SKInterFaceServer,_dataQunMemArr[indexPath.row][@"PortraitBig"]]]] placeholderImage:[UIImage imageNamed:@"Friend_header.png"]];
                    
                }else{
                    
                    cell.contentImgV.image = [UIImage imageNamed:@"Friend_header.png"];
                }
            }else if (indexPath.row == _dataQunMemArr.count){
                
                cell.KuangImgV.hidden = YES;
                cell.contentLab.text = @"添加";
                cell.contentImgV.image = [UIImage imageNamed:@"AddMember.png"];
            }else{
                
                cell.KuangImgV.hidden = YES;
                cell.contentLab.text = @"删除";
                cell.contentImgV.image = [UIImage imageNamed:@"kickMember.png"];
            }
        }
        
        
        return cell;
    }
}

// 点击图片的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isCY) {
        
        WTFriendDetailsController *wtfriDVC = [[WTFriendDetailsController alloc] init];
        [self.delegateQunMem.navigationController pushViewController:wtfriDVC animated:YES];
    }else{
    
        if (_dataQunMemArr.count != 0) {
            
            if (indexPath.row < _dataQunMemArr.count ) {
                
                WTFriendDetailsController *wtfriDVC = [[WTFriendDetailsController alloc] init];
                [self.delegateQunMem.navigationController pushViewController:wtfriDVC animated:YES];
                
            }else if (indexPath.row == _dataQunMemArr.count){
                
                WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
                wtQunMVC.QunType = 3;
                wtQunMVC.dataManageArr = _dataQunMemArr;
                wtQunMVC.dataQunDeDict = _dataQunDedict;
                wtQunMVC.contentText = @"选择联系人";
                [self.delegateQunMem.navigationController pushViewController:wtQunMVC animated:YES];
                
            }else{
                
                WTQunManageController *wtQunMVC = [[WTQunManageController alloc] init];
                wtQunMVC.QunType = 4;
                wtQunMVC.dataManageArr = _dataQunMemArr;
                wtQunMVC.dataQunDeDict = _dataQunDedict;
                wtQunMVC.contentText = @"删除群成员";
                [self.delegateQunMem.navigationController pushViewController:wtQunMVC animated:YES];
            }
        }
    
    }
}

- (void)reloadCollectionView:(NSNotification *)not{
    
    if (not.userInfo[@"JQARR"]) {
        
        _dataQunMemArr = not.userInfo[@"JQARR"];
    }
    
    if (not.userInfo[@"JQCY"]) {
        
        isCY = YES;
    }
    
    [_QunMemberContectionV reloadData];
}

@end
