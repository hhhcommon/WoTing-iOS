
//
//  WTFenLeiTableViewCell.m
//  WOTING
//
//  Created by jq on 2016/12/5.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTFenLeiTableViewCell.h"

#import "WTFLDetaliController.h"

@implementation WTFenLeiTableViewCell{
    
    UIView      *whView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self initAdd];
    }
    
    return self;
}

- (void)initAdd {
    
    __weak WTFenLeiTableViewCell *weakSelf = self;
    
    //白色view
    whView = [[UIView alloc] init];
    whView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whView];
    [whView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf).with.offset(POINT_Y(10));
        make.left.equalTo(weakSelf);
        make.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf);
    }];
    
    //线
    UIImageView *imageX = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(20), POINT_Y(20), POINT_X(10), POINT_Y(20))];
    imageX.image = [UIImage imageNamed:@"WTXian.png"];
    [whView addSubview:imageX];
    
    //标题
    _nameLab = [[UILabel alloc] initWithFrame:CGRectMake(POINT_X(40), POINT_Y(20), POINT_X(120), POINT_Y(20))];
    _nameLab.font = [UIFont boldSystemFontOfSize:15];
    [whView addSubview:_nameLab];
    
    
}

- (void)setTitles:(NSArray *)titles {
    
    NSInteger XX = 0;
    NSInteger YY = 10;
    NSInteger width = K_Screen_Width/4.00000;
    NSInteger height = 10;
    
    for (int i = 0; i < titles.count; i++) {
        
        NSString *title = [[titles objectAtIndex:i] objectForKey:@"name"];
        
        if (!(i%4)) {
            
            YY += 30;
            XX = 0;
            
        }
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(XX, YY, width - 3, height)];
        btn.tag = 1000 + i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"WTKou.png"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.imageEdgeInsets = UIEdgeInsetsMake(-4,0, 0, 0);
        [whView addSubview:btn];
        
        XX += width;

    }
    
    
    
}

- (void)btnClick:(UIButton *)btn {
    
    WTFLDetaliController *wtflVC = [[WTFLDetaliController alloc] init];
    
    wtflVC.nameLab.text = btn.titleLabel.text;
    
    [self.delegate.navigationController pushViewController:wtflVC animated:YES];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
