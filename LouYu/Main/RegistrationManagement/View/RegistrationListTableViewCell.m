//
//  RegistrationListTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RegistrationListTableViewCell.h"

@implementation RegistrationListTableViewCell




-(void)bindDataWithModel:(censusListModel *)model{
    self.titleLabel.text=model.title;
    self.userNameLabel.text=model.userName;
    self.contentLabel.text=model.content;
    self.addtimeLabel.text=model.addtime;


}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllView];
    }
    return self;

}

-(void)setUpAllView{
    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 20)];
    [self.titleLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self addSubview:self.titleLabel];
    
    self.userNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame)+5, 150, 20)];
    [self.userNameLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.userNameLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.userNameLabel];
    
    self.contentLabel=[[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.userNameLabel.frame)+5, KscreenWidth-10, 40)];
    [self.contentLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.contentLabel setNumberOfLines:0];
    [self.contentLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self addSubview:self.contentLabel];
    
    self.addtimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+10, 5,150 , 20)];
    [self.addtimeLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.addtimeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.addtimeLabel];
    
    
    

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
