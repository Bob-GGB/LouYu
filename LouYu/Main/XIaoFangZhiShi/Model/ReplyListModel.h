//
//  ReplyListModel.h
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "name": "沈暑涛回复段晓辉",
 "thumb": "",
 "content": "你就是一个水军",
 "addtime": "2017-07-10 11:07"
 */

@interface ReplyListModel : BaseModel

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *addtime;
@end
