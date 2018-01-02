//
//  DetailRecordsTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailRecordsTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *stauteLabel;
@property(nonatomic,strong)UILabel *nameLabel;
@property(strong,nonatomic) UILabel *verticalLabel ;//竖线
@property(strong,nonatomic) UIImageView *circleView; //圈
@property(strong,nonatomic) UILabel *verticalLabelBlow ;//竖线
@property(nonatomic,strong)UILabel *addtimeLabel;
@property (nonatomic,strong) UILabel *addtimeTwoLabel;
@end
