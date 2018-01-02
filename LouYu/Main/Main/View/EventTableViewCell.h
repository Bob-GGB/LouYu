//
//  EventTableViewCell.h
//  LouYu
//
//  Created by mc on 2017/9/23.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "indexWorkModel.h"
@interface EventTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UIImageView *rightImageView;

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *addTimeLable;
@property(nonatomic,strong)UILabel *typeLable;
@property(nonatomic,strong)UILabel *placeNameLable;
@property(nonatomic,strong)UILabel *statusTextLable;
@property(nonatomic,strong)UIButton *moreButton;
@property (nonatomic , strong) void(^sendController)(UIViewController * controller);

-(void)DataWithModel:(indexWorkModel *)model;
@end
