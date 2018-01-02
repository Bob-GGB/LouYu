//
//  DetailsTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailModel.h"
@interface DetailsTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *descrLabel;
@property(nonatomic,strong)UILabel *VoiceLabel;
@property(nonatomic,strong)UIButton *VoiceButton;
@property(nonatomic,strong)UIImageView *WarnImageView;
@property(nonatomic,strong)UIImageView *placeImageView;
@property(nonatomic,strong)UILabel *placeLabel;

-(void)bindDataWithModel:(DetailModel *)model;

@end
