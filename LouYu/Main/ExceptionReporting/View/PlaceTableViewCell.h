//
//  PlaceTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyListModel.h"
@protocol SelectedCellDelegate <NSObject>

- (void)handleSelectedButtonActionWithSelectedIndexPath:(NSIndexPath *)selectedIndexPath;

@end

@interface PlaceTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIButton *selectButton;
@property (nonatomic, weak) id<SelectedCellDelegate> xlDelegate;
@property (assign, nonatomic) NSIndexPath *selectedIndexPath;

-(void)bindDataWithModel:(CompanyListModel *)model;
@end
