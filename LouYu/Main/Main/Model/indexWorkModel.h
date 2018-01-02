//
//  indexWorkModel.h
//  LouYu
//
//  Created by barby on 2017/7/20.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 {
 "code": 1,
 "msg": "操作成功",
 "content": {
 "work": [
 
 ],
 "warn": {
 "status": 2,
 "statusText": "已提议",
 "title": "孟锋发起的故障上报",
 "addtime": "2017-06-07 15:28:50",
 "warnID": 3
 },
 "articleTypeList": [
 {
 "typeID": 1,
 "typeName": "新闻"
 },
 {
 "typeID": 2,
 "typeName": "法规"
 },
 {
 "typeID": 3,
 "typeName": "视频"
 }
 ],
 "defaultTypeID": 1,
 "articleList": [
 {
 "articleID": 21,
 "photo": "http://master.patrol.qianchengwl.cn/Uploads/image/20170523/828f6f1755539de59aef7a66c30b2e7a.jpg",
 "title": "浙江慈溪一房屋凌晨发生坍塌 户主夫妻被埋",
 "introduce": "浙江慈溪一房屋凌晨发生坍塌 户主夫妻被埋",
 "hit": 64,
 "collection": 0,
 "addtime": "3天前"
 },
 {
 "articleID": 19,
 "photo": "http://master.patrol.qianchengwl.cn/Uploads/image/20170523/7785b658d3c5d7c85f55230056082b51.jpg",
 "title": "晋江一民房卫生间洗衣机着火 两人被困",
 "introduce": "晋江一民房卫生间洗衣机着火 两人被困",
 "hit": 31,
 "collection": 0,
 "addtime": "3天前"
 },
 {
 "articleID": 18,
 "photo": "http://master.patrol.qianchengwl.cn/Uploads/image/20170523/c489ed7af308781b52eee57661b0a1db.jpg",
 "title": "高楼阳台离奇掉落，业主该如何维权？",
 "introduce": "高楼阳台离奇掉落，业主该如何维权？",
 "hit": 16,
 "collection": 0,
 "addtime": "3天前"
 },
 {
 "articleID": 17,
 "photo": "http://master.patrol.qianchengwl.cn/Uploads/image/20170523/81dce3a9abb32005d61e2e064eca5992.jpg",
 "title": "厦门18年违建3小时夷为平地 4栋楼房轰然倒地",
 "introduce": "厦门18年违建3小时夷为平地 4栋楼房轰然倒地",
 "hit": 7,
 "collection": 0,
 "addtime": "3天前"
 },
 {
 "articleID": 13,
 "photo": "http://master.patrol.qianchengwl.cn/Uploads/image/20170523/21ebd33e9efeafb128ef02e9bb142967.jpg",
 "title": "电气防火防爆要求及技术措施",
 "introduce": "电气防火防爆要求及技术措施",
 "hit": 3,
 "collection": 0,
 "addtime": "3天前"
 }
 ]
 }
 }
 */


@interface indexWorkModel : BaseModel

@property(nonatomic,strong)NSNumber *status;
@property(nonatomic,copy)NSString *statusText;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,strong)NSNumber *workID;




@end
