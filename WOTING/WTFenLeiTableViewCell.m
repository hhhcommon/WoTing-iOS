
//
//  WTFenLeiTableViewCell.m
//  WOTING
//
//  Created by jq on 2016/12/5.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTFenLeiTableViewCell.h"

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
    
    for (int i = 0; i < titles.count; i++) {
        
        NSString *title = [[titles objectAtIndex:i] objectForKey:@"name"];
        if (titles.count <= 4) {
            
            //菱形
            UIImageView *imageK = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(60)+ (i*K_Screen_Width/4 - POINT_X(40)) , POINT_Y(110), POINT_X(20), POINT_Y(20))];
            imageK.image = [UIImage imageNamed:@"WTKou.png"];
            [whView addSubview:imageK];
            
            //节目单
            _JMLab = [[UILabel alloc] initWithFrame:CGRectMake(POINT_X(90) + (i*K_Screen_Width/4 - POINT_X(40)), POINT_Y(110), K_Screen_Width/4 - POINT_X(40), POINT_Y(20))];
            _JMLab.font = [UIFont boldSystemFontOfSize:14];
            _JMLab.text = title;
            [whView addSubview:_JMLab];
        }else if (titles.count > 4) {
            
            if (i <= 4) {
               
                //菱形
                UIImageView *imageK = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(60)+ (i*K_Screen_Width/4 - POINT_X(40)) , POINT_Y(90), POINT_X(20), POINT_Y(20))];
                imageK.image = [UIImage imageNamed:@"WTKou.png"];
                [whView addSubview:imageK];
                
                //节目单
                _JMLab = [[UILabel alloc] initWithFrame:CGRectMake(POINT_X(90) + (i*K_Screen_Width/4 - POINT_X(40)), POINT_Y(90), K_Screen_Width/4 - POINT_X(40), POINT_Y(20))];
                _JMLab.font = [UIFont boldSystemFontOfSize:14];
                _JMLab.text = title;
                [whView addSubview:_JMLab];
                
            }else{
                
                static int j = 0;
                //菱形
                UIImageView *imageK = [[UIImageView alloc] initWithFrame:CGRectMake(POINT_X(60)+ (j*K_Screen_Width/4 - POINT_X(40)) , POINT_Y(150), POINT_X(20), POINT_Y(20))];
                imageK.image = [UIImage imageNamed:@"WTKou.png"];
                [whView addSubview:imageK];
                
                //节目单
                _JMLab = [[UILabel alloc] initWithFrame:CGRectMake(POINT_X(90) + (j*K_Screen_Width/4 - POINT_X(40)), POINT_Y(150), K_Screen_Width/4 - POINT_X(40), POINT_Y(20))];
                _JMLab.font = [UIFont boldSystemFontOfSize:14];
                _JMLab.text = title;
                [whView addSubview:_JMLab];

                j++;
            }
            
        }
    }
    
    
    
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
