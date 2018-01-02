//
//  WorkDetailModel.h
//  LouYu
//
//  Created by barby on 2017/8/15.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"
/*
 "headImgUrl": "https://zheshang.patrol.qianchengwl.cn/uploads/20170602/2756c889d77094727c727fca6a703927.jpg",
 "userName": "最上级",
 "status": 2,
 "statusText": "已发起",
 "typeName": "安防巡查（防火巡查）",
 "begintime": "2017-06-13",
 "endtime": "2017-06-13",
 "placeName": "西港新界3楼",
 "title": "地点为3",
 "addtime": "2017-06-13 16:01:28",
 "userMsg"
 */
@interface WorkDetailModel : BaseModel
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *begintime;
@property(nonatomic,copy)NSString *endtime;
@property(nonatomic,copy)NSString *placeName;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addtime;

@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,strong)NSMutableArray *userMsg;
@end
