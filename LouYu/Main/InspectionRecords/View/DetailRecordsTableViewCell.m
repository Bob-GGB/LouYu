//
//  DetailRecordsTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DetailRecordsTableViewCell.h"

@implementation DetailRecordsTableViewCell



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatAllView];
    }
    return self;
}
-(void)creatAllView{

    //竖线
    self.verticalLabel=[[UILabel alloc]initWithFrame:CGRectMake(75*Width,0,2,20*Height)];
    self.verticalLabel.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:self.verticalLabel];
    
    //圆圈
    self.circleView=[[UIImageView alloc]initWithFrame:CGRectMake(70*Width,20,10,10*Height)];
    self.circleView.layer.cornerRadius=5;
    self.circleView.backgroundColor=KRGB(104, 173, 255, 1.0);
    [self addSubview:self.circleView];
    
    //竖线
    self.verticalLabelBlow=[[UILabel alloc]initWithFrame:CGRectMake(75*Width,CGRectGetMaxY(self.circleView.frame),2,60*Height)];
    self.verticalLabelBlow.backgroundColor=[UIColor lightGrayColor];
    [self addSubview:self.verticalLabelBlow];
    
    
    self.titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.circleView.frame)+10, 10, 200*Width, 15*Height)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self addSubview:self.titleLabel];
    
    
    self.stauteLabel =[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth-80*Width, 25, 60*Width, 15*Height)];
    [self.stauteLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.stauteLabel setTextAlignment:NSTextAlignmentCenter];
    [self.stauteLabel setTextColor:[UIColor blackColor]];
    [self addSubview:self.stauteLabel];
    
    
    self.nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.circleView.frame)+10, CGRectGetMaxY(self.titleLabel.frame)+15, 100*Width, 15*Height)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:12.0]];
    [self.nameLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self addSubview:self.nameLabel];

    
    UIView *linView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.circleView.frame)+10, CGRectGetMaxY(self.nameLabel.frame)+5, KscreenWidth-CGRectGetMaxX(self.circleView.frame), 1)];
    [linView setBackgroundColor:KRGB(153, 153, 153, 0.5f)];
    [self addSubview:linView];
    
    self.addtimeLabel =[[UILabel alloc] initWithFrame:CGRectMake(10,30, 50*Width, 18*Height)];
    [self.addtimeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.addtimeLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.addtimeLabel setNumberOfLines:1];
    [self.addtimeLabel setTextColor:[UIColor blackColor]];
    [self addSubview:self.addtimeLabel];

    self.addtimeTwoLabel =[[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.addtimeLabel.frame), 70*Width, 18*Height)];
    [self.addtimeTwoLabel setTextAlignment:NSTextAlignmentCenter];
    [self.addtimeTwoLabel setFont:[UIFont systemFontOfSize:11.0]];
    [self.addtimeTwoLabel setNumberOfLines:1];
   
    [self.addtimeTwoLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self addSubview:self.addtimeTwoLabel];

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
