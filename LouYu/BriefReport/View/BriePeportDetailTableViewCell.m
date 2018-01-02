//
//  ColumnChartView.m
//  LouYu
//
//  Created by barby on 2017/7/31.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BriePeportDetailTableViewCell.h"


@interface BriePeportDetailTableViewCell ()

@end


@implementation BriePeportDetailTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self creatAllUIView];
    }

    return self;
}

-(void)creatAllUIView{
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 30, KscreenWidth-20, 20)];
    [self.titleLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.titleLabel];
    
    


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
