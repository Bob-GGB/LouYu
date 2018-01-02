//
//  SendPersonTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/15.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendPersonTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *sendLabel;
@property(nonatomic,strong)UILabel  *nameLabel;
@property(nonatomic,strong)UIImageView *addPersonImageView;
@property(nonatomic,strong)UILabel  *addNameLabel;
@property(nonatomic,strong)UIImageView *PersonImageView;
@property(nonatomic,strong)UIImageView *IconImageView;

@property (nonatomic , strong) void(^sendController)(UIViewController * controller);
@end
