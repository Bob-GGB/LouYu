//
//  CollectionListModel.h
//  LouYu
//
//  Created by barby on 2017/8/29.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface CollectionListModel : BaseModel
/*
 addtime = "2017-08-29 17:23:49";
 articleID = 163;
 collection = 7;
 hit = 16;
 introduce = "\U7518\U8083\U7701\U4e3e\U529e\U5168\U7701\U9ad8\U5c42\U5efa\U7b51\U706d\U706b\U6551\U63f4\U5b9e\U6218\U6f14\U7ec3";
 photo = "http://master.patrol.qianchengwl.cn/uploads/20170829/1ede3235fb2d909ed5e3862cc8dc7a88.jpg";
 title = "\U7518\U8083\U7701\U4e3e\U529e\U5168\U7701\U9ad8\U5c42\U5efa\U7b51\U706d\U706b\U6551\U63f4\U5b9e\U6218\U6f14\U7ec3";

 */

@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *articleID;
@property(nonatomic,strong)NSNumber *collection;
@property(nonatomic,strong)NSNumber *hit;
@property(nonatomic,copy)NSString *introduce;
@property(nonatomic,copy)NSString *photo;
@property(nonatomic,copy)NSString *title;
@end
