//
//  HeadTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "HeadTableViewCell.h"

@implementation HeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)bindDataWithModel:(DetailModel *)model{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.nameLable.text=model.name;
    self.statusLable.text=model.statusText;
    
}

-(void)sendDataWithModel:(WorkDetailModel *)model{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.nameLable.text=model.userName;
    self.statusLable.text=model.statusText;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI{

    self.headImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 44, 44)];
    //设置圆角
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    //将多余的部分切掉
//    [self.headImageView setBackgroundColor:[UIColor greenColor]];
    self.headImageView.layer.masksToBounds = YES;
    [self addSubview:self.headImageView];
    self.nameLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+15, 10, 150, 50)];
    [self.nameLable setFont:[UIFont systemFontOfSize:16.0f]];
//    self.nameLable.text=@"杨大力";
    [self.nameLable setTextColor:KRGB(51, 51, 51, 1.0f)];
    [self addSubview:self.nameLable];
    
    self.statusLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLable.frame)+100, 10, 100, 50)];
    [self.statusLable setFont:[UIFont systemFontOfSize:15.0f]];
    [self.statusLable setTextColor:KRGB(117, 117, 117, 1.0f)];
//    self.statusLable.text=@"未完成";
    [self addSubview:self.statusLable];
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 69, KscreenWidth, 1)];
    [lineView setBackgroundColor:KRGB(211, 211, 211, 1.0)];
    [self addSubview:lineView];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
