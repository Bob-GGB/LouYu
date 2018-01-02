//
//  PersonnelTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/2.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserListModel.h"

@interface PersonnelTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *selectButton;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) void(^qhxSelectBlock)(BOOL choice,NSInteger btntag);
-(void)bindDataWithModel:(UserListModel *)model;


@end
