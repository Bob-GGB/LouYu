//
//  XunJianTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/17.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "indexWarnModel.h"

@interface XunJianTableViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *headImageView;

@property(nonatomic,strong)UIImageView *rightImageView;

@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UILabel *addTimeLable;
@property(nonatomic,strong)UILabel *typeLable;
@property(nonatomic,strong)UILabel *placeNameLable;
@property(nonatomic,strong)UILabel *statusTextLable;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)NSNumber *roleIDnum;
@property (nonatomic , strong) void(^sendController)(UIViewController * controller);

-(void)bindDataWithModel:(indexWarnModel *)model;

//-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier RoleID:(NSNumber *)roleID;
@end
