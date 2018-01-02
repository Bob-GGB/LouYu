//
//  CommentsListModel.h
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "userID": 94,
 "name": "苏哲",
 "content": "小编说的有道理",
 "contentID": 1,
 "praise": 0,
 "thumb":"",
 "past":1,
 "addtime": "2017-07-10 11:07"
 */
@interface CommentsListModel : BaseModel

@property(nonatomic,strong)NSNumber *userID;
@property(nonatomic,strong)NSNumber *contentID;
@property(nonatomic,strong)NSNumber *praise;
@property(nonatomic,strong)NSNumber *past;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *thumb;
@property(nonatomic,copy)NSString *addtime;

@end
