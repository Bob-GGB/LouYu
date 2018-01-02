//
//  NewsDetailTwoTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContentListModel.h"
@interface NewsDetailTwoTableViewCell : UITableViewCell

/** 比例约束 */
@property (weak, nonatomic) NSLayoutConstraint *ratioLC;
/** 赋值比例 */
@property (nonatomic, assign) CGFloat ratio;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIImageView *newsImageView;
-(void)sendDataWithContentListModel:(ContentListModel *)model;

@property (nonatomic, copy ) void (^changeCellHeight)(void);

@end
