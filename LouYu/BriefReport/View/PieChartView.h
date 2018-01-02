//
//  PieChartView.h
//  LouYu
//
//  Created by barby on 2017/7/31.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TotalDataModel.h"
#import "JHChartHeader.h"
@interface PieChartView : UITableViewCell
@property(nonatomic,strong)JHPieChart *pie;
-(void)bindDataWithModel:(TotalDataModel *)model;
@end
