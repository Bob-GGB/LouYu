//
//  ReportDetailModel.h
//  LouYu
//
//  Created by barby on 2017/7/31.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "typeID": 1,
 "typeName": "日报",
 "title": "【谦程网络】2017-06-07管理日报",
 "detail":
 */

@interface ReportDetailModel : BaseModel

@property(nonatomic,strong)NSNumber *typeID;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;

@end
