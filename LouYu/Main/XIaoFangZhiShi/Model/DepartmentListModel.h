//
//  DepartmentListModel.h
//  LouYu
//
//  Created by barby on 2017/8/5.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 
 
 "departmentID": 1,
 "departmentName": "保安部",
 "number": 3
 */

@interface DepartmentListModel : BaseModel
@property(nonatomic,strong)NSNumber *departmentID;
@property(nonatomic,strong)NSNumber *number;
@property(nonatomic,copy)NSString *departmentName;

@end
