//
//  NewTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/17.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "indexArticleListModel.h"
#import "CollectionListModel.h"
#import "RelatedForMe-NewsListModel.h"
@interface NewTableViewCell : UITableViewCell
@property(nonatomic,strong)UIImageView *NewImageView;
@property(nonatomic,strong)UILabel *NewtitleLable;
@property(nonatomic,strong)UILabel *NewtimeLable;

/**
 *  绑定数据
 */


-(void)bindDataWithModel:(indexArticleListModel *)model;

-(void)sendDataWithModel:(CollectionListModel *)model;
-(void)CallDataWithModel:(RelatedForMe_NewsListModel *)model;

@end
