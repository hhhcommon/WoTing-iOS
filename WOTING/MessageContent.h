//
//  MessageContent.h
//  WOTING
//
//  Created by jq on 2017/2/21.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageContent : NSObject

- (void)fromBytes:(Byte *)content;

- (Byte *)toByte;

- (BOOL)equals:(MessageContent *)mc;

@end
