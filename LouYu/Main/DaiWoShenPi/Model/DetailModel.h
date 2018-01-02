//
//  DetailModel.h
//  LouYu
//
//  Created by barby on 2017/7/25.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

@interface DetailModel : BaseModel

/*
 title	string	故障主题
 status	number	故障状态
 statusText	string	故障状态描述
 placeName	string	故障地点名称
 contentName	string	故障地点项目名称
 textDescription	string	故障文本描述
 voiceDescription	string	故障语音描述
 photo	array[]	故障照片url
 name	string	故障上报人姓名
 headImgUrl	string	故障上报人头像
 addtime	string	故障上报时间
 updateTime	string	故障更新时间
 cheskMsg	Object[]	审核人信息
 roleID	number	审核人身份类型ID
 userID	number	审核人ID
 checkName	string	审核人姓名
 headImgUrl	string	审核人头像
 status	number	审核人审核状态
 statusText	string	审核人审核状态描述
 note	string	审核人提出的解决方案
 checkUpdateTime	string	审核人更新审核时间
 light	number	审核人更新状态0不亮1高亮
 */
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,copy)NSString *placeName;
@property(nonatomic,copy)NSString *contentName;
@property(nonatomic,copy)NSString *textDescription;
@property(nonatomic,copy)NSString *voiceDescription;
@property(nonatomic,strong)NSArray *photo;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *headImgUrl;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSArray *lastPhoto;
@property(nonatomic,copy)NSString *voice;
@property(nonatomic,copy)NSString *text;


@end
