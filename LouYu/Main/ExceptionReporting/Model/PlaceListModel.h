//
//  PlaceListModel.h
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*"groupID": 2,
"groupName": "C2幢",
"place"*/
@interface PlaceListModel : BaseModel
@property(nonatomic,strong)NSNumber *groupID;
@property(nonatomic,copy)NSString *groupName;
@property(nonatomic,strong)NSArray *place;
@end
