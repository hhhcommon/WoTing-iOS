//
//  MsgNormal.h
//  WOTING
//
//  Created by jq on 2017/2/18.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "Message.h"

static const long serialVersionUID = -5354794282645342159L;

@interface MsgNormal : Message

@property (nonatomic, copy) NSString *msgId;    //32位消息id
@property (nonatomic, copy) NSString *reMsgId;  //32位消息id

@property (nonatomic, assign) int bizType;      //0应答；1组通话；2电话通话；4消息通知；8同步通知；15注册消息
@property (nonatomic, assign) int cmdType;      //命令类型
@property (nonatomic, assign) int command;      //命令编号
@property (nonatomic, assign) int returnType;   //返回值类型


@property (nonatomic, assign) int PCDType;      //设备类型1手机，2设备，3网站，0服务器
@property (nonatomic, copy) NSString *userId;   //设备：当前登录用户
@property (nonatomic, copy) NSString *deviceId; //设备：设备串号

//- (void)MsgNormal:(Byte *)msgBytes;
//
//- (void)MsgNormal;

- (BOOL)isAck;

@end
