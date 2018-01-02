//
//  SelectModel.h
//  LouYu
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface SelectModel : BaseModel

@property(nonatomic,strong)NSNumber *optionID;
@property(nonatomic,copy)NSString *option;
@end
