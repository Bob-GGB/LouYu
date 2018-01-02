//
//  ContentDataModel.h
//  LouYu
//
//  Created by barby on 2017/7/31.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "typeName": "安防巡查（防火巡查）",
 "totalNumber": 24,
 "actualNumber": 2,
 "warnNumber": 2
 */

@interface ContentDataModel : BaseModel

@property(nonatomic,strong)NSNumber *totalNumber;
@property(nonatomic,strong)NSNumber *actualNumber;
@property(nonatomic,strong)NSNumber *warnNumber;
@property(nonatomic,copy)NSString *typeName;

@end
