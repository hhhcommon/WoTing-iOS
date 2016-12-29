//
//  WTZJTuijianController.m
//  WOTING
//
//  Created by jq on 2016/12/20.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "WTZJTuijianController.h"

@interface WTZJTuijianController ()

@end

@implementation WTZJTuijianController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _contentimgXQ.layer.masksToBounds = YES;
    _contentimgXQ.layer.cornerRadius = _contentimgXQ.size.width/2;
    [_contentimgXQ sd_setImageWithURL:[NSURL URLWithString:[NSString NULLToString:_dataXQDict[@"ContentImg"]]] placeholderImage:[UIImage imageNamed:@""]];
    
    _nameLabXQ.text = [NSString NULLToString:_dataXQDict[@"ContentName"]];
    
    _contentLab.text = [NSString NULLToString:_dataXQDict[@"ContentDescn"]];
    CGFloat previewH = [_contentLab.text boundingRectWithSize:CGSizeMake(_contentLab.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    _ContLabHeight.constant = previewH; //高度
    
    
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
