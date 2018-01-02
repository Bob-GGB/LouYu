//
//  articleDetailModel.h
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface articleDetailModel : BaseModel
/*
 "title": "加强消防安全知识培训 促进社区消防安全工作",
 "photo": "http://master.patrol.qianchengwl.cn/Uploads/image/20170516/f7e9aeb23275064a4f53c4054c993699.jpg",
 "author": "",
 "typeName": "新闻",
 light
 "introduce": "当患于未然，人人都应该有消防卫士。",
 "updateTime": "2017-05-16 17:45:26",
 "hit": 30,
 */

@property(nonatomic,strong)NSNumber *hit;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *author;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *introduce;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,strong)NSNumber *light;


@end


