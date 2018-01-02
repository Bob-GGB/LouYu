//
//  RegistrationListTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "censusListModel.h"
@interface RegistrationListTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UILabel *addtimeLabel;

-(void)bindDataWithModel:(censusListModel *)model;
@end
