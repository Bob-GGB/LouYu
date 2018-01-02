//
//  RelatedForMe-NewsListModel.h
//  LouYu
//
//  Created by barby on 2017/9/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"
/*
 "articleID": 20,
 "title": "晋江石结构及危旧房屋翻建改造 15.58万人受惠 ",
 "articlePhoto": "http://master.patrol.qianchengwl.cn/Uploads/image/20170523/45ddaf50bfaffc1d3bb92b97b5640ed0.jpg",
 "addtime": "2017-05-23 12:05"
 */
@interface RelatedForMe_NewsListModel : BaseModel
@property(nonatomic,strong)NSNumber *articleID;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *articlePhoto;
@property(nonatomic,copy)NSString *addtime;

@end
