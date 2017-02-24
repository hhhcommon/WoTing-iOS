//
//  Message.h
//  WOTING
//
//  Created by jq on 2017/2/18.
//  Copyright © 2017年 jq. All rights reserved.
//

#import <Foundation/Foundation.h>

static const Byte END_FIELD[] = {'|', '|'};
static const Byte END_HEAD[] = {'^', '^'};
static const Byte BEGIN_CTL [] = {'|', '^'};
static const Byte BEGIN_MDA [] = {'^', '|'};
static const int _MAXLENGTH = 20480;


@interface Message : NSObject

@property(nonatomic, assign) int msgType;   //消息类型：0主动发出；1回复类型
@property(nonatomic, assign) int affirm;    //是否需要确认；0不需要，1需要控制回复，2不需要控制回复，需要业务回复，3都需要
@property(nonatomic, assign) long sendTime; //发送时间

//1.服务器     0.设备
@property(nonatomic, assign) int fromType;  //从那类设备来
@property(nonatomic, assign) int toType;    //到那类设备去


- (void)fromBytes:(Byte[])binaryMsg;    //从字节数组中获得消息

- (Byte *)toBytes;                      //把消息序列化为字节数组

- (BOOL)isAck;                          //是否是应答消息

- (BOOL)equals:(Message *)msg;          //判断是否是应答消息
- (BOOL)equalsMsg:(Message *)msg;


- (BOOL)isCtlAffirm;    //该条消息是否需要控制确认
- (BOOL)isBizAffirm;    //该条消息是否需要业务确认

- (int)compareTo:(Message *)o;  //用于消息排序

@end
