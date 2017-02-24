//
//  msgMedia.m
//  WOTING
//
//  Created by jq on 2017/2/21.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "MsgMedia.h"

@implementation MsgMedia

- (instancetype)initWith:(Byte[])binaryMsg
{
    self = [super init];
    if (self) {
        
        [self fromBytes:binaryMsg];
    }
    return self;
}

- (void)fromBytes:(Byte [])binaryMsg{
    
    
}

- (Byte *)toBytes{
    
    return 0;
}

- (BOOL)isAck{
    
    return self.affirm == 0 && self.msgType == 1;
}


- (BOOL)equals:(Message *)msg{
    
    
    return true;
}
//是否是音频包
- (BOOL)isAudio{
    
    return _mediaType ==1;
}
//是否是视频包
- (BOOL)isVedio{
    
    return _mediaType == 2;
}

- (BOOL)equalsMsg:(Message *)msg{
    
    return true;
}

@end
