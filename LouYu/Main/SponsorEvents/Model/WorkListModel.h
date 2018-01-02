//
//  WorkListModel.h
//  LouYu
//
//  Created by barby on 2017/8/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"


/*
 "headImgUrl": "https://zheshang.patrol.qianchengwl.cn/uploads/20170602/2756c889d77094727c727fca6a703927.jpg",
 "workID": 6,
 "title": "该去检查了",
 "status": 2,
 "statustext": "已发起",
 "addtime": "2026-12-29 13:58:08",
 "placeName": "什么地方",
 "typeName": "安防巡查（防火巡查）"

 */
@interface WorkListModel : BaseModel


@property(nonatomic,copy)NSString *statustext;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *workID;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *placeName;

@end
