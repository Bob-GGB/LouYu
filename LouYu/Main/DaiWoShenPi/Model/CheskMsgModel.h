//
//  CheskMsgModel.h
//  LouYu
//
//  Created by barby on 2017/7/25.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface CheskMsgModel : BaseModel

/*
 
 "roleID": 1,
 "userID": 92,
 "checkName": "孟锋",
 "headImgUrl": "https://louyutest.qianchengwl.cn/uploads/20170602/87844b9d6afa5141c5e0f105baab2351.jpg",
 "status": 1,
 "statusText": "已上报",
 "note": "",
 "checkUpdateTime": "2017-06-07 15:03:32",
 "light": 1

 */


@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,strong)NSNumber *roleID;
@property(nonatomic,strong)NSNumber *userID;
@property(nonatomic,copy)NSString *checkName;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,strong)NSNumber *light;
@property(nonatomic,copy)NSString *addtime;

@end
