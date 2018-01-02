//
//  HeadContentModel.h
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface HeadContentModel : BaseModel

/*
 "actualNumber": 2,
 "totalNumber": 3,
 "updateTime": "2017-04-17 11:09:36"
 */

@property(nonatomic,strong)NSNumber *actualNumber;
@property(nonatomic,strong)NSNumber *totalNumber;
@property(nonatomic,copy)NSString *updateTime;

@end
