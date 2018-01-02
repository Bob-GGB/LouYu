//
//  censusListModel.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface censusListModel : BaseModel
/*
 "censusID": 1,
 userName": "席联科、中级、最上级",
 "title": "2017-06-22增加的记录",
 "trainingtime": "2017-06-22",
 "content": "开会",
 "addtime": "2017-06-22 14:26:12"
 */

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *trainingtime;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *censusID;
@end
