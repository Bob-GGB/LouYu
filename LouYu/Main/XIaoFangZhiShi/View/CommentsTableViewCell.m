//
//  CommentsTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "CommentsTableViewCell.h"
#import "UITableViewCell+FSAutoCountHeight.h"
@implementation CommentsTableViewCell



-(void)sendDataWithContentListModel:(CommentsListModel *)model{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.nameLabel.text=model.name;
    self.timeLabel.text=model.addtime;
    self.commentLabel.text=model.content;
    self.countLabel.text=[NSString stringWithFormat:@"%@",model.praise];
//    NSLog(@"model.past:%@",model.past);
    

}


-(void)bindDataWithContentListModel:(ReplyListModel *)model{

    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    self.timeLabel.text=model.addtime;
    self.commentLabel.text=model.content;
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:model.name];
    
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:@"回复"].location, [[noteStr string] rangeOfString:@"回复"].length);
    [noteStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:redRange];
    
    
    [self.nameLabel setAttributedText:noteStr];
    [self.nameLabel sizeToFit];
   
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        [self setUpAllView];
    }
    
    self.FS_cellBottomView =self.commentLabel;
    return self;

}


-(void)setUpAllView{

    self.headImageView=[[UIImageView alloc] init];

    [self.headImageView.layer setMasksToBounds:YES];
    [self.headImageView.layer setCornerRadius:50*0.5];
    [self.headImageView setUserInteractionEnabled:YES];
    [self addSubview:self.headImageView];
    
    self.nameLabel=[[UILabel alloc] init];
    [self.nameLabel setTextColor:KRGB(64,224,208, 1.0f)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.nameLabel];
    
    self.timeLabel=[[UILabel alloc] init];
    [self.timeLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.timeLabel];
    
    self.commentLabel=[[UILabel alloc] init];
    [self.commentLabel setTextColor:[UIColor blackColor]];
    [self.commentLabel setFont:[UIFont systemFontOfSize:15]];
    [self.commentLabel setNumberOfLines:0];
    [self addSubview:self.commentLabel];
    
    self.supportBtn=[UIButton buttonWithType:UIButtonTypeCustom];
   
//    [self.supportBtn setImage:[UIImage imageNamed:@"矢量智能对象_59"] forState:UIControlStateNormal];
    [self.supportBtn addTarget:self action:@selector(supportBtnDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.supportBtn];
    
    self.countLabel=[[UILabel alloc] init];
    [self.countLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.countLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:self.countLabel];
    
}




-(void)supportBtnDidPress:(UIButton *)sender{
    NSLog(@"点赞");
    _isSelect=!_isSelect;
    //     NSLog(@"_isSelectvalue: %@" ,_isSelect?@"YES":@"NO");
    if (self.PraiseBlock) {
        
        self.PraiseBlock(_isSelect);
    }


}



-(void)layoutSubviews{
    [super layoutSubviews];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.top.equalTo(self.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_top);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth-150, 30));

    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(10);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(KscreenWidth-180, 30));
        
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(@-10);
//        make.height.equalTo(@100);
    }];
    
    
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        
    }];
    
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.right.equalTo(self.supportBtn.mas_right).with.offset(-25);
        make.size.mas_equalTo(CGSizeMake(30, 30));
       
    }];


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
