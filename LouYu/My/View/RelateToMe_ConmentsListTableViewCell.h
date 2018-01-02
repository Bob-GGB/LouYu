//
//  RelateToMe_ConmentsListTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/9/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetContentForMeModel.h"
@interface RelateToMe_ConmentsListTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *sendNameLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *replayLabel;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andExist:(NSNumber *)exist;

-(void)sendDataWithContentListModel:(GetContentForMeModel *)model;
@end
