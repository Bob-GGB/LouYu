//
//  NewsDetailTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NewsDetailTableViewCell.h"

@implementation NewsDetailTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [AtuoFillScreenUtils autoLayoutFillScreen:self];
        [self creatAllUIView];
    }

    return self;

}

-(void)bindDataWithModel:(articleDetailModel *)model{
    self.titLabel.text=model.title;
    self.timeLable.text=model.updateTime;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:model.photo]];
}



-(void)creatAllUIView{

    self.titLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, KscreenWidth-20, 55)];
    [self.titLabel setFont:[UIFont systemFontOfSize:22.0f]];
    [self.titLabel setTextColor:KRGB(51, 51, 51, 1.0f)];
    [self.titLabel setNumberOfLines:0];
    [self.titLabel setTextAlignment:NSTextAlignmentCenter];
    //[self.titLabel setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.titLabel];

    
    self.timeLable=[[UILabel alloc] initWithFrame:CGRectMake(110, CGRectGetMaxY(self.titLabel.frame)+14, KscreenWidth-180, 15)];
    [self.timeLable setFont:[UIFont systemFontOfSize:13.0f]];
    [self.timeLable setTextColor:KRGB(153, 153, 153, 1.0f)];
    //[self.timeLable setBackgroundColor:[UIColor greenColor]];
    [self addSubview:self.timeLable];
    
    self.newsImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLable.frame)+20, KscreenWidth-20, 160)];
    //图片等比例缩放，防止图片拉伸变形
    [self.newsImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.newsImageView.clipsToBounds = YES;

//    [self.newsImageView setBackgroundColor:[UIColor blueColor]];
    [self addSubview:self.newsImageView];

    
    


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
