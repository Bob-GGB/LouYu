//
//  PhotosTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDetailModel.h"
@interface PhotosTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *photoLabel;
@property(nonatomic,strong)UIImageView *photoImageView;
//-(void)bindDataWithModel:(RecordDetailModel *)model;
@end
