//
//  InspeceRecordsTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/8.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "InspeceRecordsTableViewCell.h"

@implementation InspeceRecordsTableViewCell


-(void)bindDataWithModel:(PartrolListModel *)model{
   
    self.titleLabel.text=model.typeName;
    self.planTimeLabel.text=model.planTime;
    //1巡检中，2已逾期，3已完成
    if ([model.status isEqualToNumber:@1]) {
        self.statuLabel.textColor=KRGB(104, 173, 255, 1.0);
    }
    else if ([model.status isEqualToNumber:@2]) {
        self.statuLabel.textColor=KRGB(252, 58, 81, 1.0);
    }
    else
    self.statuLabel.textColor=KRGB(153, 153, 153, 1.0f);
    
    self.statuLabel.text=model.patrolStatus;
    self.placeLabel.text=model.lastPlaceName;
    if (model.userName.count==0) {
    self.nameLabel.text=@" ";
    }
    else
     self.nameLabel.text=model.userName[0];
    self.totalLabel.text=[NSString stringWithFormat:@"应巡查 %@个",model.totalNumber];
    self.actualLabel.text=[NSString stringWithFormat:@"已巡查 %@个",model.actualNumber];
    self.warnLabel.text=[NSString stringWithFormat:@"异常项 %@个",model.warnNumber];
    if ([model.warnNumber isEqualToNumber:@0]) {
       self.warnLabel.textColor=KRGB(153, 153, 153, 1.0f);
    }
    else{
        [self.warnLabel setTextColor:KRGB(252, 58, 81, 1.0) ];
    }


}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatAllUIView];
    }

    return self;

}



-(void)creatAllUIView{

    self.titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, KscreenWidth-120*Width, 20*Height)];
    [self.titleLabel setTextColor:[UIColor blackColor]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.titleLabel ];
    
    self.statuLabel=[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth-70*Width, 10, 60*Width, 20*Height)];
   
    [self.statuLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.statuLabel ];
    
    
    self.timeImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+10, 25*Width, 25*Height)];
    [self.timeImageView setImage:[UIImage imageNamed:@"icon_disabled.38.png"]];
    [self.timeImageView.layer setCornerRadius:25/2];
    [self.timeImageView.layer setMasksToBounds:YES];
    [self.timeImageView setUserInteractionEnabled:YES];
    [self addSubview:self.timeImageView];
    
    self.planTimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeImageView.frame)+10, CGRectGetMaxY(self.titleLabel.frame)+10, KscreenWidth-100*Width, 20*Height)];
    [self.planTimeLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.planTimeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.planTimeLabel ];
    
    
    self.placeImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.planTimeLabel.frame)+10, 25, 25)];
    [self.placeImageView setImage:[UIImage imageNamed:@"icon_disabled.40.png"]];
    [self.placeImageView.layer setCornerRadius:25/2];
    [self.placeImageView.layer setMasksToBounds:YES];
    [self.placeImageView setUserInteractionEnabled:YES];
    [self addSubview:self.placeImageView];
    
    
    self.placeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.placeImageView.frame)+10, CGRectGetMaxY(self.planTimeLabel.frame)+10, KscreenWidth-200*Width, 20*Height)];
    [self.placeLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.placeLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.placeLabel ];
    
    self.nameImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.placeLabel.frame)+10, 25, 25)];
    [self.nameImageView setImage:[UIImage imageNamed:@"icon_disabled.401.png"]];
    [self.nameImageView.layer setCornerRadius:25/2];
    [self.nameImageView.layer setMasksToBounds:YES];
    [self.nameImageView setUserInteractionEnabled:YES];
    [self addSubview:self.nameImageView];
    
    self.nameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameImageView.frame)+10, CGRectGetMaxY(self.placeLabel.frame)+10, KscreenWidth-200*Width, 20)];
    [self.nameLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.nameLabel ];
    
    self.resultImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.nameLabel.frame)+10, 25, 25)];
    [self.resultImageView setImage:[UIImage imageNamed:@"icon_disabled.402.png"]];
    [self.resultImageView.layer setCornerRadius:25/2];
    [self.resultImageView.layer setMasksToBounds:YES];
    [self.resultImageView setUserInteractionEnabled:YES];
    [self addSubview:self.resultImageView];
    
    self.totalLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.resultImageView.frame)+10, CGRectGetMaxY(self.nameLabel.frame)+10, (KscreenWidth-40)/3, 20)];
    [self.totalLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.totalLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.totalLabel ];
    
    self.actualLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.totalLabel.frame), CGRectGetMaxY(self.nameLabel.frame)+10, (KscreenWidth-40)/3, 20)];
    [self.actualLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.actualLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.actualLabel ];
    
    self.warnLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.actualLabel.frame), CGRectGetMaxY(self.nameLabel.frame)+10, (KscreenWidth-40)/3, 20)];
    [self.warnLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.warnLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.warnLabel ];
    
    UIView *linView=[[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.warnLabel.frame)+10,KscreenWidth, 10)];
    [linView setBackgroundColor:KRGB(220, 220, 220, 0.5)];
    [self addSubview:linView];
    

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
