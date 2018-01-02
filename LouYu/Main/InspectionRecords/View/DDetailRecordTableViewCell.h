//
//  DDetailRecordTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/9.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDetailRecordTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;

@property(nonatomic,strong)UILabel *statuLabel;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) void(^qhxSelectBlock)(BOOL choice,NSInteger btntag);
@end
