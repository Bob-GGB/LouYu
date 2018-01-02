//
//  DetailHeadView.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DetailHeadView.h"

@implementation DetailHeadView

-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame: frame];
    if (self) {
        [self creatAllView];
    }

    return self;
}




-(void)creatAllView{

    self.yiCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/4-10, 10, KscreenWidth/5,20 )];
    [self.yiCountLabel setTextColor:[UIColor whiteColor]];
    [self.yiCountLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yiCountLabel setFont:[UIFont systemFontOfSize:18.0f]];
    //[self.yiCountLabel setText:@"1"];
    [self addSubview:self.yiCountLabel];
    
    self.yingCountLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yiCountLabel.frame)+self.yiCountLabel.frame.size.width+10, 10, KscreenWidth/5,20 )];
    [self.yingCountLabel setTextColor:[UIColor whiteColor]];
    [self.yingCountLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yingCountLabel setFont:[UIFont systemFontOfSize:18.0f]];
   // [self.yingCountLabel setText:@"1"];
    [self addSubview:self.yingCountLabel];
    
    self.yiLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/4-10, CGRectGetMaxY(self.yiCountLabel.frame)+10, KscreenWidth/5,20 )];
    [self.yiLabel setTextColor:[UIColor whiteColor]];
    [self.yiLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yiLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [self.yiLabel setText:@"已巡检"];
    [self addSubview:self.yiLabel];
    
    self.yingLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.yiCountLabel.frame)+self.yiCountLabel.frame.size.width+10,CGRectGetMaxY(self.yingCountLabel.frame)+10, KscreenWidth/5,20 )];
    [self.yingLabel setTextColor:[UIColor whiteColor]];
    [self.yingLabel setTextAlignment:NSTextAlignmentCenter];
    [self.yingLabel setFont:[UIFont systemFontOfSize:18.0f]];
    [self.yingLabel setText:@"应巡检"];
    [self addSubview:self.yingLabel];
    
    self.UpdateLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/5-30, CGRectGetMaxY(self.yiLabel.frame)+10, KscreenWidth-KscreenWidth/4-20,20 )];
    [self.UpdateLabel setTextColor:[UIColor whiteColor]];
    
    [self.UpdateLabel setFont:[UIFont systemFontOfSize:13.0f]];
    //[self.UpdateLabel setText:@"更新于：08-08 11:22"];
    [self addSubview:self.UpdateLabel];
    
    
    
}

@end
