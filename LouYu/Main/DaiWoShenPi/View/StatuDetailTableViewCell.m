//
//  StatuDetailTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/24.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "StatuDetailTableViewCell.h"

@implementation StatuDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)bindDataWithModel:(CheskMsgModel *)model{
    if ([model.light isEqualToNumber:@0]) {
        [self.statusImageView  setImage:[UIImage imageNamed:@"icon_weishenghe.png"]];
    }
    else
[self.statusImageView  setImage:[UIImage imageNamed:@"icon_yishenghe_normal.png"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.nameLabel.text=model.checkName;
    self.statusLabel.text=model.statusText;
    self.timeLabel.text=model.addtime;
    
    if (model.note ==NULL) {
        
        [self.beizhuLabel removeFromSuperview];

    }else{
        self.beizhuLabel.text=[NSString stringWithFormat:@" 备注：%@",model.note];
    }
    

    
}


-(void)senderDataWithModel:(UserMsgModel *)model{


    if ([model.light isEqualToNumber:@0]) {
        [self.statusImageView  setImage:[UIImage imageNamed:@"icon_weishenghe.png"]];
    }
    else
        [self.statusImageView  setImage:[UIImage imageNamed:@"icon_yishenghe_normal.png"]];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.nameLabel.text=model.userName;
    self.statusLabel.text=model.userStatusText;
    self.timeLabel.text=model.updatetime;
        [self.beizhuLabel removeFromSuperview];
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI{
    self.statusImageView=[[UIImageView alloc] init];
                          //WithFrame:CGRectMake(10, 30*Height, 16*Width, 16*Height)];
    //设置圆角
    self.statusImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    //将多余的部分切掉
    self.statusImageView.layer.masksToBounds = YES;
   // [self.statusImageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.statusImageView];
    [self.statusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.and.height.equalTo(@16);
        make.top.equalTo(@30);
    }];
    
    self.backgrondImageView=[[UIImageView alloc] init];
                             //WithFrame:CGRectMake(CGRectGetMaxX(self.statusImageView.frame)+10, 10, 310*Width, 70*Height)];
    [self.backgrondImageView setImage:[UIImage imageNamed:@"形状-5"]];
    [self addSubview:self.backgrondImageView];
    [self.backgrondImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusImageView.mas_right).offset(10);
        make.right.equalTo(@-10);
        make.top.equalTo(@10);
        make.height.equalTo(@70);
    }];
    
    
    self.headImageView=[[UIImageView alloc] init];
                        //WithFrame:CGRectMake(13, 15, 30*Width, 30*Height)];
//    [self.headImageView setBackgroundColor:[UIColor greenColor]];
    //设置圆角
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    //将多余的部分切掉
    self.headImageView.layer.masksToBounds = YES;
    
    [self.backgrondImageView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@13);
        make.top.equalTo(@15);
        make.width.and.height.equalTo(@30);
    }];
    
    
    self.nameLabel=[[UILabel alloc] init];
                    //WithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, self.headImageView.frame.origin.y+8, 50*Width, 20*Height)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.nameLabel setTextColor:KRGB(51, 51, 51, 1.0)];
     //[self.nameLabel setText:@"杨大力"];
    [self.backgrondImageView addSubview:self.nameLabel];
    CGSize size = [@"杨大力" boundingRectWithSize:CGSizeMake(300, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nameLabel.font} context:nil].size;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.top.equalTo(@20);
        make.height.equalTo(@15);
        make.width.equalTo(@(size.width));
    }];
    
    
    self.statusLabel=[[UILabel alloc] init];
                      //WithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), self.nameLabel.frame.origin.y, 60*Width, 20*Height)];
    [self.statusLabel setTextColor:KRGB(104, 173, 255, 1.0)];
    [self.statusLabel setFont:[UIFont systemFontOfSize:13.0f]];
//    self.statusLabel.adjustsFontForContentSizeCategory= YES;
    [self.statusLabel sizeToFit];
    //[self.statusLabel setBackgroundColor:[UIColor redColor]];
    [self.backgrondImageView addSubview:self.statusLabel];
    CGSize sizess = [@"已处理啦" boundingRectWithSize:CGSizeMake(300, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.nameLabel.font} context:nil].size;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(1);
        make.top.equalTo(@20);
        make.width.equalTo(@(sizess.width));
        make.height.equalTo(@15);
        
    }];
    
    self.timeLabel=[[UILabel alloc] init];
                    //WithFrame:CGRectMake(CGRectGetMaxX(self.statusLabel.frame), self.nameLabel.frame.origin.y,KscreenWidth-CGRectGetMaxX(self.statusLabel.frame), 20)];
    //[self.timeLabel setText:@"2017-01-09"];
   // [self.timeLabel setBackgroundColor:[UIColor greenColor]];
    [self.timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [self.timeLabel setTextColor:KRGB(117, 117, 117, 1.0)];
    [self.backgrondImageView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusLabel.mas_right);
        make.right.equalTo(@0);
        make.top.equalTo(@20);
        make.height.equalTo(@15);
    }];
    
    
    self.beizhuLabel=[[UILabel alloc] init];
//                      WithFrame:CGRectMake(15, CGRectGetMaxY(self.headImageView.frame)+5, self.backgrondImageView.frame.size.width, 15)];
    [self.beizhuLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.beizhuLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.backgrondImageView addSubview:self.beizhuLabel];
    [self.beizhuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@(200));
    }];

}

-(void)layoutSubviews

{
    
    [super layoutSubviews];
    
    [self layoutIfNeeded];
    
    
    //设置圆角
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    //将多余的部分切掉
    self.headImageView.layer.masksToBounds = YES;
    
    
    
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
