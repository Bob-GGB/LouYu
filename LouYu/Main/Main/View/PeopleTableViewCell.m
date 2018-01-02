//
//  PeopleTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/23.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PeopleTableViewCell.h"
#import "PeopleViewController.h"
@implementation PeopleTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAllView];
        
    }
    return self;
    
}


-(void)creatAllView{
    self.sendLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80*Width, 20*Height)];
    [self.sendLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.sendLabel setText:@"派发给谁:"];
    [self addSubview:self.sendLabel];
    
    self.PersonImageView=[[UIImageView alloc] init];
    [self.PersonImageView setFrame:CGRectMake(15, CGRectGetMaxY(self.sendLabel.frame)+10, 50*Width, 50*Height)];
    self.PersonImageView.layer.cornerRadius=self.PersonImageView.frame.size.width/2;
    self.PersonImageView.layer.masksToBounds=YES;
    [self.PersonImageView setUserInteractionEnabled:YES];
    [self addSubview:self.PersonImageView];
    
    
    self.IconImageView=[[UIImageView alloc] init];
    [self.IconImageView setFrame:CGRectMake(CGRectGetMaxX(self.PersonImageView.frame)+10, CGRectGetMaxY(self.sendLabel.frame)+25*Height, 30*Width, 15*Height)];
    //    self.IconImageView.layer.cornerRadius=self.addPersonImageView.frame.size.width/2;
    //    self.IconImageView.layer.masksToBounds=YES;
    [self.IconImageView setImage:[UIImage imageNamed:@"jiantou.png"]];
    [self addSubview:self.IconImageView];
    
    
    
    self.addPersonImageView=[[UIImageView alloc] init];
    [self.addPersonImageView setFrame:CGRectMake(CGRectGetMaxX(self.IconImageView.frame)+10, CGRectGetMaxY(self.sendLabel.frame)+10, 50*Width, 50*Height)];
    
    self.addPersonImageView.layer.cornerRadius=self.addPersonImageView.frame.size.width/2;
    self.addPersonImageView.layer.masksToBounds=YES;
    [self.addPersonImageView setImage:[UIImage imageNamed:@"btn_default.png"]];
    
    //为UIImageView1添加点击事件
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [self.addPersonImageView addGestureRecognizer:tapGestureRecognizer1];
    //让UIImageView和它的父类开启用户交互属性
    [self.addPersonImageView setUserInteractionEnabled:YES];
    
    
    [self addSubview:self.addPersonImageView];
    
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.addPersonImageView.frame)+10, 60*Width, 15*Height)];
    [self.nameLabel setTextColor:[UIColor blackColor]];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self addSubview:self.nameLabel];
    
    self.addNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.IconImageView.frame)+10, CGRectGetMaxY(self.addPersonImageView.frame)+10, 60*Width, 15*Height)];
    [self.addNameLabel setTextColor:[UIColor blackColor]];
    [self.addNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self.addNameLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self addSubview:self.addNameLabel];
    
    
    
    
}


-(void)scanBigImageClick1:(UITapGestureRecognizer *)sender{
    // NSLog(@"添加人员");
    PeopleViewController *peopleCV=[[PeopleViewController alloc] init];
    if (self.sendController) {
        
        self.sendController(peopleCV);
        
        
    }
    
    
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
