//
//  TypeModel.h
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface TypeModel : BaseModel
//"typeID": 1,
//"typeName": "新闻"
@property(nonatomic,strong)NSNumber *typeID;
@property(nonatomic,copy)NSString *typeName;
@end
