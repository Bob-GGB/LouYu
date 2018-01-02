//
//  indexWarnModel.h
//  LouYu
//
//  Created by barby on 2017/7/20.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface indexWarnModel : BaseModel

@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *warnID;


@end
