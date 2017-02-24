//
//  MsgNormal.m
//  WOTING
//
//  Created by jq on 2017/2/18.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "MsgNormal.h"

@interface MsgNormal ()


@end

@implementation MsgNormal

- (instancetype)initWith:(Byte [])msgBytes
{
    self = [super init];
    if (self) {
        [self fromBytes:msgBytes];
    }
    return self;
}

- (void)fromBytes:(Byte [])binaryMsg{
    
    
    
}

- (Byte *)toBytes{
    
    Byte byte[] = {};
    
    return byte;
}

- (BOOL)isAck{
    
    return self.msgType == 1;
}

- (BOOL)equals:(Message *)msg{
    
    return 0;
}

@end
