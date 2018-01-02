//
//  CompanyListModel.h
//  LouYu
//
//  Created by barby on 2017/8/25.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface CompanyListModel : BaseModel
/*
"companyID": 2,
"companyName": "杭州谦程总
 */
@property(nonatomic,strong)NSNumber *companyID;
@property(nonatomic,copy)NSString *companyName;
@end
