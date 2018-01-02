//
//  BriePeportTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/29.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "BriePeportTableViewCell.h"

@implementation BriePeportTableViewCell



-(void)bindDataWithModel:(ReportListModel *)model{

    self.timeLable.text=model.addtime;
    self.titleLable.text=model.title;
    self.descriLable.text=model.detail;
    


}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatAllView];
        
    }

    return self;

}


-(void)creatAllView{

    self.timeLable =[[UILabel alloc] initWithFrame:CGRectMake(90, 20, KscreenWidth-180, 15)];
    [self.timeLable setFont:[UIFont systemFontOfSize:13.0f]];
    [self.timeLable setTextColor:KRGB(134, 136, 148, 1.0)];
    [self.timeLable setText:@"2017-10-16 00:00:00"];
    [self.titleLable setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.timeLable];
    
    self.headImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.timeLable.frame)+10, 30, 30)];
    [self.headImageView setImage:[UIImage imageNamed:@"icon_jianbao."]];
    [self addSubview:self.headImageView];
    
    UIView *backgroundView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, CGRectGetMaxY(self.timeLable.frame)+10, KscreenWidth-self.headImageView.frame.size.width-20-20, 120)];
    //将图层的边框设置为圆脚
    
    backgroundView.layer.cornerRadius = 5;
    backgroundView.layer.masksToBounds = YES;
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [backgroundView.layer setBorderWidth:1];
    [backgroundView.layer setBorderColor:KRGB(220, 220, 220, 1.0).CGColor];
    [self addSubview:backgroundView];
    
    self.titleLable =[[UILabel alloc] initWithFrame:CGRectMake(10, 10,KscreenWidth-self.headImageView.frame.size.width-60, 20)];
//    self.titleLable.text=@"上多少大是大非可能对双方来说都不分开两边";
    [self.titleLable setFont:[UIFont systemFontOfSize:14.0f]];
    [self.titleLable setTextColor:[UIColor blackColor]];//KRGB(51, 51, 51, 1.0)
    [backgroundView addSubview:self.titleLable];
    
    self.descriLable =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLable.frame)+10, KscreenWidth-self.headImageView.frame.size.width-60, 40)];
//    self.descriLable.text=@"风刀霜剑咖啡对健康十分 v 速度快减肥吧但是看见方便快捷似懂非懂设计开发 v 看到健身房 v 的设计开发的时刻风刀霜剑咖啡对健康十分 v 速度快减肥吧但是看见方便快捷似懂非懂设计开发 v 看到健身房 v 的设计开发的时刻";
    [self.descriLable setFont:[UIFont systemFontOfSize:12.0f]];
    [self.descriLable setNumberOfLines:0];
    [self.descriLable setTextColor:KRGB(134, 136, 148, 1.0)];
    [backgroundView addSubview:self.descriLable];
    
    self.moreLable =[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.descriLable.frame)+10, 150, 20)];
    [self.moreLable setFont:[UIFont systemFontOfSize:13.0f]];
    [self.moreLable setText:@"查看更多"];
    [self.moreLable setTextColor:KRGB(104, 173, 255, 1.0)];
    [backgroundView addSubview:self.moreLable];
    
    
    

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
