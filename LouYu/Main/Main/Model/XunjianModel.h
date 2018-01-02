//
//  XunjianModel.h
//  LouYu
//
//  Created by barby on 2017/7/17.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface XunjianModel : BaseModel

/*
 
 warnList	Object[]	问题待处理列表
 warnID	number	故障ID，根据ID去查看详细故障内容
 headImgUrl	string	头像
 title	string	故障主题
 addtime	string	故障上报时间
 type	string	类型
 placeName	string	故障地点
 statusText	string	故障状态描述
 
 */
//@property(nonatomic,strong) NSDictionary *_content;
//@property(nonatomic,strong)NSMutableArray *warnList;
@property(nonatomic,strong)NSNumber *warnID;
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *placeName;
@property(nonatomic,copy)NSString *statusText;


@end
