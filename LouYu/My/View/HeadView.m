//
//  HeadView.m
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
      
        [self creatAllView];
    }
    return self;

}


-(void)creatAllView{
    self.headImageView =[[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 80, 80)];
    //[self.headImageView setBackgroundColor:[UIColor redColor]];
    self.headImageView.layer.cornerRadius=10;
    [self.headImageView.layer setMasksToBounds:YES];
    [self addSubview:self.headImageView];
    
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+20, 15, 80, 30)];
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
    //[self.nameLabel setText:@"好说歹说"];
   // [self addSubview:self.nameLabel];
    
    self.phoneLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+20, CGRectGetMaxY(self.nameLabel.frame)+10, 150, 30)];
    [self.phoneLabel setTextColor:[UIColor whiteColor]];
    [self.phoneLabel setFont:[UIFont systemFontOfSize:15.0f]];
   // [self.phoneLabel setText:@"1232345435"];
    //[self addSubview:self.phoneLabel];
    
    self.backButton=[[UIImageView alloc] init];
    [self.backButton setFrame:CGRectMake(KscreenWidth-50,CGRectGetMaxY(self.nameLabel.frame)-5, 40, 40)];
    [self.backButton setImage:[UIImage imageNamed:@"btn_normal.60.png"]];
    
    self.changeLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth-50-60, CGRectGetMaxY(self.nameLabel.frame), 60, 30)];
    [self.changeLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.changeLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.changeLabel setText:@"更换头像"];

    
//    [self.backButton addTarget:self action:@selector(backButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.backButton];
    


}
//-(void)backButtonDidPress:(UIButton *)sender{
//
//    DemoSettingController *setCV=[[DemoSettingController alloc] init];
//    if (self.sendController) {
//        self.sendController(setCV);
//    }
//
//}

@end
