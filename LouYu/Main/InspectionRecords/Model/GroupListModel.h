//
//  GroupListModel.h
//  LouYu
//
//  Created by mc on 2017/9/13.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"


/*
 "groupID": 1,
 "groupName": "B1幢",
 "status": 1,
 "statusText": "巡检中"
 
 */
@interface GroupListModel : BaseModel
@property(nonatomic,strong)NSNumber *groupID;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *groupName;
@property(nonatomic,copy)NSString *statusText;
@end
