//
//  PlaceContentListModel.h
//  LouYu
//
//  Created by barby on 2017/8/9.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"


/*
 "classID": 8,
 "className": "室内",
 "content": [
 {
 "contentID": 28,
 "contentName": "恶趣味群",
 "statusText": "异
 */

@interface PlaceContentListModel : BaseModel

@property(nonatomic,strong)NSNumber *classID;
@property(nonatomic,strong)NSArray *content;
@property(nonatomic,copy)NSString *className;

@end
