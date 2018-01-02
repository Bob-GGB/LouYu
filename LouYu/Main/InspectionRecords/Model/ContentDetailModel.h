//
//  ContentDetailModel.h
//  LouYu
//
//  Created by barby on 2017/8/9.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 contentID": 28,
 "contentName": "恶趣味群",
 "statusText": "异
 */

@interface ContentDetailModel : BaseModel

@property(nonatomic,strong)NSNumber *contentID;
@property(nonatomic,copy)NSString *contentName;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,strong)NSNumber *warnID;
@end
