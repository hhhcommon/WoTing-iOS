//
//  Message.m
//  WOTING
//
//  Created by jq on 2017/2/18.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "Message.h"

@interface Message()


@end

@implementation Message


- (BOOL)isCtlAffirm{
    
    return _affirm == 1 || _affirm == 3;
}

- (BOOL)isBizAffirm{
    
    return _affirm == 2 || _affirm == 3;
    
}

- (int)compareTo:(Message *)o{
    
    long flag = _sendTime - o.sendTime;
    if (flag == 0) {
        
        return 0;
    }else if (flag >0){
        
        return 1;
    }else{
        
        return -1;
    }
}

- (BOOL)equalsMsg:(Message *)msg{
    
    if (_msgType != msg.msgType) {
        
        return false;
    }else if (_msgType != msg.affirm){
        
        return false;
    }else if (_fromType != msg.fromType){
        
        return false;
    }else if (_toType != msg.toType){
        
        return false;
    }
    
    return true;
}

@end
