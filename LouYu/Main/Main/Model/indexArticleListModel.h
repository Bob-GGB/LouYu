//
//  indexArticleListModel.h
//  LouYu
//
//  Created by barby on 2017/7/20.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface indexArticleListModel : BaseModel
@property(nonatomic,strong)NSNumber *articleID;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *introduce;
@property(nonatomic,strong)NSNumber *hit;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *collection;

@end
