//
//  DDetailRecordTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/9.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DDetailRecordTableViewCell.h"

@implementation DDetailRecordTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatAllView];
    }
    return self;
}

-(void)creatAllView{
    
    self.nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(10,5, KscreenWidth-100*Width, 40*Height)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.nameLabel setNumberOfLines:0];
    [self.nameLabel setTextColor:[UIColor blackColor]];
    // [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.nameLabel];
    
    self.statuLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth-50*Width, 10, 40*Width, 30*Height)];
    [self.statuLabel setTextColor:KRGB(104, 173, 255, 1.0)];
    [self.statuLabel setTextAlignment:NSTextAlignmentCenter];
    [self.statuLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.statuLabel.layer setBorderColor:KRGB(104, 173, 255, 1.0).CGColor];
    [self.statuLabel.layer setBorderWidth:1];
    [self addSubview:self.statuLabel];
    
    
    
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
