//
//  Message.h
//  WOTING
//
//  Created by jq on 2017/2/18.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

extern NSString *const END_HEAD;

@property(nonatomic, assign) int msgType;
@property(nonatomic, assign) int affirm;
@property(nonatomic, assign) long sendTime;

@property(nonatomic, assign) int fromType;
@property(nonatomic, assign) int toType;

- (void) fromBytes:(Byte[])binaryMsg;

- (Byte* )toBytes;

@end
