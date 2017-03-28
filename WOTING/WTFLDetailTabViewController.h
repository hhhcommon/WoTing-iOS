//
//  WTFLDetailTabViewController.h
//  WOTING
//
//  Created by jq on 2017/3/17.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WTFLDetailTabViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *FLDetailTabV;

@property (nonatomic, copy) NSString *contentID;
@property (nonatomic, copy) NSString *MediaType;

@end
