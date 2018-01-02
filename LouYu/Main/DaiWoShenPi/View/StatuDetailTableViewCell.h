//
//  StatuDetailTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheskMsgModel.h"
#import "UserMsgModel.h"
@interface StatuDetailTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *statusImageView;
@property(nonatomic,strong)UIImageView *backgrondImageView;
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *statusLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *beizhuLabel;

-(void)bindDataWithModel:(CheskMsgModel *)model;

-(void)senderDataWithModel:(UserMsgModel *)model;
@end
