//
//  censusTypeListModel.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "typeID": 1,
 "typeName": "自动消防设施故障处理记录"
 */

@interface censusTypeListModel : BaseModel

@property(nonatomic,strong)NSNumber *typeID;
@property(nonatomic,copy)NSString *typeName;

@end
