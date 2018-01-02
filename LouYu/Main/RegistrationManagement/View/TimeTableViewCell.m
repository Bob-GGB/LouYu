//
//  TimeTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "TimeTableViewCell.h"

@implementation TimeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllView];
    }
    return self;

}

-(void)setUpAllView{

    self.timeLable =[[UILabel alloc] initWithFrame:CGRectMake(5, 10, KscreenWidth/4-10, 20)];
    [self.timeLable setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.timeLable setFont:[UIFont systemFontOfSize:16.0f]];
    [self.timeLable setText:@"培训时间"];
    [self addSubview:self.timeLable];
    
    self.trainingtimeLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLable.frame)+self.timeLable.frame.size.width, 10, KscreenWidth/3-10, 20)];
    [self.trainingtimeLable setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.trainingtimeLable setFont:[UIFont systemFontOfSize:16.0f]];
    [self addSubview:self.trainingtimeLable];

    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
