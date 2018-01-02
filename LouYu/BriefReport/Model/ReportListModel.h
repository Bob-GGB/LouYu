//
//  ReportListModel.h
//  LouYu
//
//  Created by barby on 2017/7/29.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BaseModel.h"

/*
 "reportID": 12,
 "addtime": "2017-04-28 10:39:39",
 "addtimePlan": "2017-04-28 00:00:00",
 "title": "【浙商银行】2017-04-27管理日报",
 "detail": "需安防巡查（防火巡查）12次，实际巡查0次，巡查中发现问题0次;需维修班组日巡查2次，实际巡查0次，巡查中发现问题0次;需运行班组每日（含外观）巡查1次，实际巡查0次，巡查中发现问题0次;需物业巡检1次，实际巡查0次，巡查中发现问题0次;需楼道检查1次，实际巡查0次，巡查中发现问题0次;"
 */

@interface ReportListModel : BaseModel
@property(nonatomic,strong)NSNumber *reportID;
@property(nonatomic,copy)NSString *addtime;
@property(nonatomic,copy)NSString *addtimePlan;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *detail;
@end
