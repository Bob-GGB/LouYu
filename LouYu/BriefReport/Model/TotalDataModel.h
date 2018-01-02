//
//  TotalDataModel.h
//  LouYu
//
//  Created by barby on 2017/7/31.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"


/*
 "allTotalNum": 107,
 "allActualNum": 2,
 "allWarnNum": 2
 */
@interface TotalDataModel : BaseModel

@property(nonatomic,strong)NSNumber *allTotalNum;
@property(nonatomic,strong)NSNumber *allActualNum;
@property(nonatomic,strong)NSNumber *allWarnNum;
@end
