//
//  NewsModel.h
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel

@property(nonatomic,strong)NSNumber *articleID;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addtime;


@end
