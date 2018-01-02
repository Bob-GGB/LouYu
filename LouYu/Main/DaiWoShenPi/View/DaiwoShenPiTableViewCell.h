//
//  DaiwoShenPiTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/22.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "warnStatusModel.h"
#import "WorkListModel.h"
@interface DaiwoShenPiTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *titileLabel;
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)UILabel *timeLabel;
-(void)bindDataWithModel:(warnStatusModel *)model;

-(void)senderDataWithModel:(WorkListModel *)model;
@end
