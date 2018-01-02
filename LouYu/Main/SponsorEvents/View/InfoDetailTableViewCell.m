//
//  InfoDetailTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/15.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "InfoDetailTableViewCell.h"

@implementation InfoDetailTableViewCell




-(void)bindDataWithModel:(WorkDetailModel *)model{
    self.typeLabel.text=model.typeName;
    self.begianLabel.text=model.begintime;
    self.endLabel.text=model.endtime;
    self.placeLabel.text=model.placeName;
    self.descrLabel.text=model.title;
    

}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
    }
    
    return self;
}

-(void)setUpUI{
    UILabel *typesLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, 100, 20)];
    [typesLabel setText:@"类型："];
    [typesLabel setTextColor:[UIColor blackColor]];
    [self addSubview:typesLabel];
    self.typeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typesLabel.frame)+10, 20, KscreenWidth-100, 20)];
    [self.typeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    // [self.typeLabel setText:@"类型：是当时的我"];
    [self.typeLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self addSubview:self.typeLabel];
    
    UILabel *beLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.typeLabel.frame)+10, 100, 20)];
    [beLabel setTextColor:[UIColor blackColor]];
    [beLabel setText:@"开始时间："];
    [self addSubview:beLabel];
    
    self.begianLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(beLabel.frame)+10, CGRectGetMaxY(self.typeLabel.frame)+10, KscreenWidth-150, 20)];
    [self.begianLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.begianLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self addSubview:self.begianLabel];
    
    UILabel *enlabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.begianLabel.frame)+10, 100, 20)];
    [enlabel setTextColor:[UIColor blackColor]];
    [enlabel setText:@"结束时间："];
    [self addSubview:enlabel];
    
    self.endLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(enlabel.frame)+10, CGRectGetMaxY(self.begianLabel.frame)+10, KscreenWidth-150, 20)];
    [self.endLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.endLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self addSubview:self.endLabel];
    
    UILabel *plLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.endLabel.frame)+10, 100, 20)];
    [plLabel setTextColor:[UIColor blackColor]];
    [plLabel setText:@"地点："];
    [self addSubview:plLabel];
    self.placeLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(plLabel.frame)+10,CGRectGetMaxY(self.endLabel.frame)+10, KscreenWidth-150, 20)];
    [self.placeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self.placeLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    // [self.placeLabel setText:@"杭州西湖区216号XXX大楼"];
    [self addSubview:self.placeLabel];
    
    UILabel *deLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.placeLabel.frame)+10, 100, 20)];
    [deLabel setTextColor:[UIColor blackColor]];
    [deLabel setText:@"描述："];
    [self addSubview:deLabel];
    self.descrLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(deLabel.frame)+10, CGRectGetMaxY(self.placeLabel.frame)+10, KscreenWidth-150, 20)];
    [self.descrLabel setFont:[UIFont systemFontOfSize:15.0f]];
    // [self.descrLabel setText:@"描述：上的法国萨多家咖啡馆的撒风公交卡时代"];
    [self.descrLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self addSubview:self.descrLabel];

   
    //
    
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
