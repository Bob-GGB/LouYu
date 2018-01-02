//
//  InfoDetailTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/15.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkDetailModel.h"
@interface InfoDetailTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *descrLabel;
@property(nonatomic,strong)UILabel *placeLabel;
@property(nonatomic,strong)UILabel *begianLabel;
@property(nonatomic,strong)UILabel *endLabel;


-(void)bindDataWithModel:(WorkDetailModel *)model;

@end
