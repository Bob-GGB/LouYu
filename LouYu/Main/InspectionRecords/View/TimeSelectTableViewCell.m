//
//  TimeSelectTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "TimeSelectTableViewCell.h"

@implementation TimeSelectTableViewCell




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatAllView];
    }
    return self;
}


-(void)creatAllView{

    
    self.dateNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 80*Width, 30*Height)];
    [self.dateNameLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.dateNameLabel setTextColor:KRGB(134, 136, 148, 1.0)];
    [self addSubview:self.dateNameLabel];
    
    self.dateLabel =[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-40, 20, 80*Width, 30*Height)];
    [self.dateLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.dateLabel setTextColor:KRGB(134, 136, 148, 1.0)];
    [self.dateLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.dateLabel];

    
    
    
    
    
    
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
