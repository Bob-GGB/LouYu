//
//  BriePeportTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/29.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportListModel.h"
@interface BriePeportTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *descriLable;
@property(nonatomic,strong)UILabel *moreLable;

-(void)bindDataWithModel:(ReportListModel *)model;
@end
