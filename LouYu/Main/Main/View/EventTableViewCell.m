//
//  EventTableViewCell.m
//  LouYu
//
//  Created by mc on 2017/9/23.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "EventTableViewCell.h"
#import "MoreEventViewController.h"
@implementation EventTableViewCell
-(void)DataWithModel:(indexWorkModel *)model{
    
    //[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.XXX]];
    self.titleLable.text=@"事件处理";
    self.addTimeLable.text=model.addtime;
    self.typeLable.text=model.title;
    self.statusTextLable.text=model.statusText;
    [self.headImageView setImage:[UIImage imageNamed:@"icon_shijianchuli.png"]];
  
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier ];
    if (self) {
        
        [self setUpAllView];
    }
    
    return self;
}

#pragma --设置所有控件
-(void)setUpAllView{
    
    self.headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10,10, 30, 30)];
    //[self.headImageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.headImageView];
    //titileLable
    self.titleLable =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, CGRectGetMaxY(self.lineView.frame)+10, 60, 18)];
    // [self.titleLable setBackgroundColor:[UIColor yellowColor]];
    [self.titleLable setTextColor:KRGB(134, 136, 148, 1.0)];
    [self.titleLable setFont:[UIFont systemFontOfSize:14.0f]];
    [self addSubview:self.titleLable];
    //rightimageView
    self.rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(KscreenWidth-44, 10, 44, 44)];
    [self.rightImageView setImage:[UIImage imageNamed:@"btn_normal_88.png"]];
    [self addSubview:self.rightImageView];
    //addTimelabel
    self.addTimeLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, CGRectGetMaxY(self.titleLable.frame)+5, (KscreenWidth-100)*Width, 14)];
    [self.addTimeLable setTextColor:KRGB(153, 153, 153, 1.0)];
    // [self.addTimeLable setBackgroundColor:[UIColor blueColor]];
    [self.addTimeLable setFont:[UIFont systemFontOfSize:12.0f]];
    [self addSubview:self.addTimeLable];
    //typeLabel
    self.typeLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10,CGRectGetMaxY(self.addTimeLable.frame)+12 , (self.frame.size.width-100)*Width, 20)];
    [self.typeLable setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.typeLable setFont: [UIFont systemFontOfSize:17.0f]];
    //[self.typeLable setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:self.typeLable];
    //statusTextLable
    self.statusTextLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10,CGRectGetMaxY(self.typeLable.frame)+12 , 90*Width, 20*Height)];
    [self.statusTextLable setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.statusTextLable setFont: [UIFont systemFontOfSize:15.0f]];
    //[self.statusTextLable setBackgroundColor:[UIColor orangeColor]];
    [self addSubview:self.statusTextLable];
    
    //moreButton
    
    self.moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.moreButton setFrame:CGRectMake(0, CGRectGetMaxY(self.statusTextLable.frame)+8, KscreenWidth, 33*Height)];
    [self.moreButton setTitle:@"查看更多" forState:UIControlStateNormal];
    [self.moreButton setTitleColor:KRGB(153, 153, 153, 1.0) forState:UIControlStateNormal];
    [self.moreButton setBackgroundColor:KRGB(249, 249, 249, 1.0)];
    [self.moreButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [self.moreButton addTarget:self action:@selector(moreButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreButton];
    
    //每个cell之间的间隔
    UIView *BlowLineView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.moreButton.frame), KscreenWidth, 10)];
    [BlowLineView setBackgroundColor:KRGB(240, 240, 240, 1.0)];
    [self addSubview:BlowLineView];
    
}

//moreButton的点击事件

-(void)moreButtonDidPress:(UIButton*)sender{
   
    MoreEventViewController *moreEventVC=[[MoreEventViewController alloc] init];
    
    if (self.sendController) {
        self.sendController(moreEventVC);
        NSLog(@"我被点击了");
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
