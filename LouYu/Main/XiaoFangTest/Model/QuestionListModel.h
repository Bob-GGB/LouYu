//
//  QuestionListModel.h
//  LouYu
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@class SelectModel;
@interface QuestionListModel : BaseModel



@property(nonatomic,strong)NSNumber *questionID;
@property(nonatomic,copy)NSString *questionName;
@property(nonatomic,strong)NSArray *select;
@end
