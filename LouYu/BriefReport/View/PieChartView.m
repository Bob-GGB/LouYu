//
//  PieChartView.m
//  LouYu
//
//  Created by barby on 2017/7/31.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView



-(void)bindDataWithModel:(TotalDataModel *)model{

    
    
self.pie.valueArr = @[model.allTotalNum,model.allActualNum,model.allWarnNum];

    NSLog(@"pieVie---self.pie.valueArr:%@",self.pie.valueArr);
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self showPieChartUpView];
        //[self showColumnView];
    }
    return self;

}

- (void)showPieChartUpView{

    
    UIImageView *imageView1=[[UIImageView alloc] initWithFrame:CGRectMake(200,60, 10, 10)];
    [imageView1 setBackgroundColor:KRGB(96, 151, 232,1.0)];
    [self addSubview:imageView1];
    UILabel *label1=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+10, imageView1.frame.origin.y, 80*Width, 15)];
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [label1 setText:@"应巡查次数"];
    [self addSubview:label1];
    
    UIImageView *imageView2=[[UIImageView alloc] initWithFrame:CGRectMake(imageView1.frame.origin.x, imageView1.frame.origin.y+20, 10, 10)];
    [imageView2 setBackgroundColor:KRGB(164, 225, 255,1.0)];
    [self addSubview:imageView2];

    UILabel *label2=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView2.frame)+10, imageView2.frame.origin.y, 80*Width, 15)];
     [label2 setFont:[UIFont systemFontOfSize:13]];
    [label2 setText:@"实际查询次数"];
    [self addSubview:label2];
    
    UIImageView *imageView3=[[UIImageView alloc] initWithFrame:CGRectMake(imageView1.frame.origin.x, imageView2.frame.origin.y+20, 10, 10)];
    [imageView3 setBackgroundColor:KRGB(255, 204, 169,1.0)];
    [self addSubview:imageView3];
    UILabel *label3=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView1.frame)+10, imageView3.frame.origin.y, 80*Width, 15)];
     [label3 setFont:[UIFont systemFontOfSize:13]];
    [label3 setText:@"发现问题"];
    [self addSubview:label3];
    
    UIImageView *imageView4=[[UIImageView alloc] initWithFrame:CGRectMake(imageView1.frame.origin.x, imageView3.frame.origin.y+20, 10, 10)];
    [imageView4 setBackgroundColor:KRGB(218, 247, 232,1.0)];
    [self addSubview:imageView4];
    UILabel *label4=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView4.frame)+10, imageView4.frame.origin.y, 80*Width, 15)];
     [label4 setFont:[UIFont systemFontOfSize:13]];
    [label4 setText:@"已处理问题"];
    [self addSubview:label4];
    
}



@end
