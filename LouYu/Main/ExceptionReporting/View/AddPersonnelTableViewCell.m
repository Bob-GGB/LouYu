//
//  AddPersonnelTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "AddPersonnelTableViewCell.h"
#import "PersonelViewController.h"


@implementation AddPersonnelTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAllView];
        
    }
    return self;

}


-(void)creatAllView{
    self.sendLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80*Width, 20*Height)];
    [self.sendLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.sendLabel setText:@"提交给谁"];
    [self addSubview:self.sendLabel];
    
    self.deleteLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.sendLabel.frame), self.sendLabel.frame.origin.y, 150*Width, 20*Height)];
    [self.deleteLabel setText:@"(点击头像删除)"];
    [self.deleteLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.deleteLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self addSubview:self.deleteLabel];
   
    self.addPersonImageView=[[UIImageView alloc] init];
    [self.addPersonImageView setFrame:CGRectMake(15, CGRectGetMaxY(self.sendLabel.frame)+5, 40*Width, 40*Height)];
    
    self.addPersonImageView.layer.cornerRadius=self.addPersonImageView.frame.size.width/2;
    self.addPersonImageView.layer.masksToBounds=YES;
    [self.addPersonImageView setImage:[UIImage imageNamed:@"btn_default.png"]];
   
    //为UIImageView1添加点击事件
    UITapGestureRecognizer *tapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scanBigImageClick1:)];
    [self.addPersonImageView addGestureRecognizer:tapGestureRecognizer1];
    //让UIImageView和它的父类开启用户交互属性
    [self.addPersonImageView setUserInteractionEnabled:YES];
    
    
    [self addSubview:self.addPersonImageView];
    
    UILabel *addLabel=[[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.addPersonImageView.frame)+5, 100*Width, 15*Height)];
    [addLabel setText:@"添加人员"];
    [addLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [addLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self addSubview:addLabel];
    
    
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(addLabel.frame)+10, KscreenWidth, 10)];
    [lineView setBackgroundColor:KRGB(235, 235, 235, 1.0f)];
    [self addSubview:lineView];

}


-(void)scanBigImageClick1:(UITapGestureRecognizer *)sender{
   // NSLog(@"添加人员");
    PersonelViewController *personCV=[[PersonelViewController alloc] init];
    
    
    if (self.sendController) {
    
        self.sendController(personCV);
        
        

        
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
