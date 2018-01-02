//
//  NewsDetailTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "articleDetailModel.h"

@interface NewsDetailTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *titLabel;
@property(nonatomic,strong)UILabel *timeLable;
@property(nonatomic,strong)UIImageView *newsImageView;

-(void)bindDataWithModel:(articleDetailModel *)model;



@end
