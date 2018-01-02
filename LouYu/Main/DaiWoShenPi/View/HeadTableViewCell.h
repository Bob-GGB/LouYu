//
//  HeadTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
#import "WorkDetailModel.h"
@interface HeadTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLable;
@property(nonatomic,strong)UILabel *statusLable;


-(void)bindDataWithModel:(DetailModel *)model;

-(void)sendDataWithModel:(WorkDetailModel *)model;


@end
