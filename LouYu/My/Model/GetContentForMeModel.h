//
//  GetContentForMeModel.h
//  LouYu
//
//  Created by barby on 2017/9/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "content": "小编说的有道理",
 "contentID": 1,
 "userID": 94,
 "userName": "苏哲",
 "sendUserName": "段晓辉",
 "name": "回复苏哲",
 "replyContent": "占楼",
 "replyContentID": 3,
 "sendUserID": 95,
 "thumb": "https://zheshang.patrol.qianchengwl.cn/uploads/20170607/48dc65070094892b8cf7c03fadd6ebc3.jpg",
 "addtime": "2017-07-10 11:07"
 */
@interface GetContentForMeModel : BaseModel
@property(nonatomic,copy)NSString *content;
@property(nonatomic,strong)NSNumber *contentID;
@property(nonatomic,strong)NSNumber *userID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *replyContent;
@property(nonatomic,copy)NSString *sendUserName;
@property(nonatomic,strong)NSNumber *replyContentID;
@property(nonatomic,strong)NSNumber *sendUserID;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *exist;





@end
