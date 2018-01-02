//
//  ContentModel.h
//  LouYu
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"


/*
 "warnAmount": 0,
 "allWarnAmount": 1,
 "dealAmount": 0,
 "dealAllAmount": 1
 */
@interface ContentModel : BaseModel

@property(nonatomic,strong)NSNumber *warnAmount;
@property(nonatomic,strong)NSNumber *allWarnAmount;
@property(nonatomic,strong)NSNumber *dealAmount;
@property(nonatomic,strong)NSNumber *dealAllAmount;

@end
