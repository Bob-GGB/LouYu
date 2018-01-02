//
//  UserTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllView];
    }
    return self;
    
}

-(void)setUpAllView{
    
    self.Namelabel =[[UILabel alloc] initWithFrame:CGRectMake(5, 10, KscreenWidth/4-10, 20)];
    [self.Namelabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.Namelabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.Namelabel setText:@"培训人员"];
    [self addSubview:self.Namelabel];
    
    self.userNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.Namelabel.frame)+self.Namelabel.frame.size.width, 10, KscreenWidth/2-10, 20)];
    [self.userNameLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.userNameLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self addSubview:self.userNameLabel];
    
    
    
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
