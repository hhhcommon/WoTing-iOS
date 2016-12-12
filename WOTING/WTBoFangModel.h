//
//  WTBoFangModel.h
//  WOTING
//
//  Created by jq on 2016/12/7.
//  Copyright © 2016年 jq. All rights reserved.
//

#import "JSONModel.h"

@interface WTBoFangModel : JSONModel

@property (nonatomic, copy)NSString<Optional> *ContentImg;
@property (nonatomic, copy)NSString<Optional> *ContentName;
@property (nonatomic, copy)NSString<Optional> *ContentPlay;
@property (nonatomic, copy)NSString<Optional> *ContentTimes;

//@property (nonatomic, copy)NSString<Optional> *albumId;
//@property (nonatomic, copy)NSString<Optional> *coverSmall;
//@property (nonatomic, copy)NSString<Optional> *coverLarge;
//@property (nonatomic, copy)NSString<Optional> *smallLogo;
//@property (nonatomic, copy)NSString<Optional> *title;
//@property (nonatomic, copy)NSString<Optional> *playUrl64;
/*{
 CTime = "<null>";
 ContentCatalogs =         (
 {
 CataDid = cn14;
 CataMId = 3;
 CataMName = "\U5185\U5bb9\U5206\U7c7b";
 CataTitle = "\U504f\U597d\U8bbe\U7f6e/\U4f1a\U751f\U6d3b/\U65c5\U6e38\U51fa\U884c";
 }
 );
 ContentDescn = "<null>";
 ContentFavorite = 0;
 ContentId = 0384157c71164c1fa773360214e8c240;
 ContentImg = "http://pic.qingting.fm/2015/0805/20150805154854144.jpg!400";
 ContentKeyWord = "<null>";
 ContentName = "\U65b0\U7586\U63a2\U79d8\U5f55\U4e4b\U8461\U8404\U53e4\U57ce_19";
 ContentPlay = "http://od.qingting.fm/vod/00/00/0000000000000000000024523236_64.m4a";
 ContentPub = "\U873b\U8713";
 ContentPubTime = "<null>";
 ContentShareURL = "http://123.56.254.75:908/CM/mweb/jm/0384157c71164c1fa773360214e8c240/content.html";
 ContentStatus = "<null>";
 ContentSubjectWord = "<null>";
 ContentTimes = 919000;
 ContentURI = "content/getContentInfo.do?MediaType=AUDIO&ContentId=0384157c71164c1fa773360214e8c240";
 MediaType = AUDIO;
 PlayCount = 1234;
 }*/



//当网络数据的键值对的个数大于属性个数时,需要声明该方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key;






@end
