//
//  BaseModel.m
//  LouYu
//
//  Created by barby on 2017/7/17.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

-(instancetype)initWithDict:(NSDictionary *)dict{
    if (self=[super init]) {
        
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    
}


@end
