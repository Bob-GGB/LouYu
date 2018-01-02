//
//  PartrolListModel.h
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 
 "status":3,
 "patrolIcon": "1491507001",
 "typeID": 1,
 "typeName": "安防巡查（防火巡查）",
 "lastPlaceName": "阜阳",
 "userName": [
 "孟锋"
 ],
 "warnNumber": 0,
 "totalNumber": 5,
 "actualNumber": 5,
 "patrolStatus": "已完成",
 "planTime": "04-07 02:40至04-07 04:40",
 "actualTime": "04-07 03:30至04-07 03:50"
 */

@interface PartrolListModel : BaseModel

@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *patrolIcon;
@property(nonatomic,strong)NSNumber *typeID;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *lastPlaceName;
@property(nonatomic,strong)NSArray *userName;
@property(nonatomic,strong)NSNumber *warnNumber;
@property(nonatomic,strong)NSNumber *totalNumber;
@property(nonatomic,strong)NSNumber *actualNumber;
@property(nonatomic,copy)NSString *patrolStatus;
@property(nonatomic,copy)NSString *planTime;
@property(nonatomic,copy)NSString *actualTime;


@end
