//
//  CommentsTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CommentsListModel.h"
#import "ReplyListModel.h"
@interface CommentsTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *commentLabel;
@property(nonatomic,strong)UIButton *supportBtn;
@property(nonatomic,strong)UILabel *countLabel;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic , strong) void(^PraiseBlock)(BOOL choice);


-(void)sendDataWithContentListModel:(CommentsListModel *)model;

-(void)bindDataWithContentListModel:(ReplyListModel *)model;
@end
