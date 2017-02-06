//
//  CityModel.h
//  WOTING
//
//  Created by jq on 2017/1/5.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel : NSObject

@property (nonatomic, copy) NSString *CityName;

@property (nonatomic,copy) NSString *CityId;

@property (nonatomic, copy) NSString *Cityletter;   //大写字母

- (void)setValue:(id)value forUndefinedKey:(NSString *)key;

@end
