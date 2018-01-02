//
//  OnePartrolListeModel.h
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface OnePartrolListeModel : BaseModel

/*
 
 "patrolID": 106,
 "status": 1,
 "statusText": "已巡检",
 "addtime": "2017-04-17 11:19:36",
 "placeName": "浙江银行安全出口",
 "userName": "科比",
 "longitude": "0.000000",
 "latitude": "0.000000",
 "warnStatusText": "1项异常"
 */


@property(nonatomic,strong)NSNumber *patrolID;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,copy)NSString *placeName;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *longitude;
@property(nonatomic,copy)NSString *latitude;
@property(nonatomic,copy)NSString *warnStatusText;


@end
