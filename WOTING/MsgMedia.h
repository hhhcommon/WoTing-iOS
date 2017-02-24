//
//  msgMedia.h
//  WOTING
//
//  Created by jq on 2017/2/21.
//  Copyright © 2017年 jq. All rights reserved.
//

#import "Message.h"

//媒体消息：媒体流数据

static const long serialVersionUID = -3827446721333425724L;
static const int COMPACT_LEN = 36;  //若删除这个objId，则这个值为24


@interface MsgMedia : Message

@property (nonatomic, assign) int mediaType;      //流类型：1.音频，2视频
@property (nonatomic, assign) int bizType;      //流业务类型：1对讲组，2电话
@property (nonatomic, copy) NSString *channelId;    //频道id：在组队对讲中是组id，在电话对讲中是电话通话Id
@property (nonatomic, copy) NSString *talkId;  //会话id，或一次媒体传输的信息编号

@property (nonatomic, assign) int seqNo;      //流中包的序列号
@property (nonatomic, assign) int returnType;   //返回消息类型

@property (nonatomic, strong) id extInfo;   //扩展信息，这个信息是不参与传输的

@end
