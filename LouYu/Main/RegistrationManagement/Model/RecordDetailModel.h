//
//  RecordDetailModel.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "typeName": "消防安全教育培训记录",
 "trainingtime": "2017-06-28",
 "userName": [
 "罗聪",
 "刘慧"
 ],
 "content": "今天开会的主要内容",
 "textDescription": "好的撒旦谁都会发生的空间圣诞节繁花似锦打开 四大皆空第三方的快速返回三德科技副书记恢复灰色空间上课 数据库东方红是发动机收到货房价快速的恢复开始计划地方科技时代繁花似锦大客户焚枯食淡",
 "photo": [
 "http://master.patrol.qianchengwl.cn/uploads/20170628/db85f56cd4af173eeac08f9b7d4484de.jpg",
 "http://master.patrol.qianchengwl.cn/uploads/20170628/4865c48eb8525f65cf7106d4c8771ce2.jpg"
 ],
 "note": "准时到场"
 */
@interface RecordDetailModel : BaseModel
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *trainingtime;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *textDescription;
@property(nonatomic,copy)NSString *note;
@property(nonatomic,strong)NSArray *photo;
@property(nonatomic,strong)NSArray *userName;


@end
