//
//  InspeceRecordsTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PartrolListModel.h"
@interface InspeceRecordsTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *statuLabel;
@property(nonatomic,strong)UILabel *planTimeLabel;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *totalLabel;
@property(nonatomic,strong)UILabel *actualLabel;
@property(nonatomic,strong)UILabel *warnLabel;
@property(nonatomic,strong)UIImageView *timeImageView;
@property(nonatomic,strong)UIImageView *placeImageView;
@property(nonatomic,strong)UIImageView *nameImageView;
@property(nonatomic,strong)UIImageView *resultImageView;

-(void)bindDataWithModel:(PartrolListModel *)model;

@end
