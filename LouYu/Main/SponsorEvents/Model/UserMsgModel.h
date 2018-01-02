//
//  UserMsgModel.h
//  LouYu
//
//  Created by barby on 2017/8/15.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"
/*
 "updatetime": "2017-06-13 16:01:28",
 "userName": "最上级",
 "headImgUrl": "https://zheshang.patrol.qianchengwl.cn/uploads/20170602/2756c889d77094727c727fca6a703927.jpg",
 "roleID": 3,
 "status": 1,
 "userStatusText": "发起事件",
 "light": 1
 
 */

@interface UserMsgModel : BaseModel

@property(nonatomic,copy)NSString *updatetime;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *userStatusText;
@property(nonatomic,strong)NSNumber *roleID;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSNumber *light;


@end
