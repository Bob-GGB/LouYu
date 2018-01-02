//
//  RelateToMe_ConmentsListTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/9/1.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "RelateToMe_ConmentsListTableViewCell.h"
#import "UITableViewCell+FSAutoCountHeight.h"
@interface RelateToMe_ConmentsListTableViewCell ()
//@property(nonatomic)
@end
@implementation RelateToMe_ConmentsListTableViewCell


-(void)sendDataWithContentListModel:(GetContentForMeModel *)model{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.thumb]];
    if ([model.exist isEqualToNumber:@0]) {
        self.sendNameLabel.text=model.sendUserName;
        self.contentLabel.text=model.content;
        self.timeLabel.text=model.addtime;
    }
    else{
       self.sendNameLabel.text=model.sendUserName;
        self.contentLabel.text=model.content;
        self.timeLabel.text=model.addtime;
        self.nameLabel.text=[NSString stringWithFormat:@"%@:",model.name];
//        self.replayLabel.text=[NSString stringWithFormat:@"  %@:%@",model.userName,model.replyContent];
    
    }



}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andExist:(NSNumber *)exist{

    self=[super initWithStyle:(style) reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if ([exist isEqualToNumber:@0]) {
            
            [self setUpUIViewWithZero];
        }
        else{
        
            [self setUpUIViewWithOne];
        }
        
    }
    return self;
}

-(void)setUpUIViewWithZero{
    //all height=130
    self.headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50*Width, 50*Height)];
    [self.headImageView.layer setCornerRadius:25];
    [self.headImageView.layer setMasksToBounds:YES];
    [self addSubview:self.headImageView];
    
    self.sendNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+20*Width, 10, KscreenWidth-100*Width, 20*Height)];
    [self.sendNameLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.sendNameLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.sendNameLabel];
    
    self.contentLabel =[[UILabel alloc] initWithFrame:CGRectMake(self.sendNameLabel.frame.origin.x, CGRectGetMaxY(self.sendNameLabel.frame)+10, self.sendNameLabel.frame.size.width, 20*Height)];
    [self.contentLabel setTextColor:[UIColor blackColor]];
    [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.contentLabel];
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.contentLabel.frame.origin.x, CGRectGetMaxY(self.contentLabel.frame)+10, self.contentLabel.frame.size.width, 20*Height)];
    [self.timeLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.timeLabel];

}



-(void)setUpUIViewWithOne{

    
    //all height=130+40
    self.headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50*Width, 50*Height)];
    [self.headImageView.layer setCornerRadius:25];
    [self.headImageView.layer setMasksToBounds:YES];
    [self addSubview:self.headImageView];
    
    self.sendNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+20*Width, 10, KscreenWidth-100*Width, 20*Height)];
    [self.sendNameLabel setTextColor:KRGB(153, 153, 153, 1.0f)];
    [self.sendNameLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.sendNameLabel];
//    [self.sendNameLabel setBackgroundColor:[UIColor redColor]];
    
    self.nameLabel=[[UILabel alloc] init];
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    
    NSString *str=@"哈哈哈哈哈：";
         CGSize size =  [str boundingRectWithSize:CGSizeMake( MAXFLOAT,self.nameLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    self.nameLabel.frame=CGRectMake(self.sendNameLabel.frame.origin.x, CGRectGetMaxY(self.sendNameLabel.frame)+10, size.width, 20*Height);
    [self.nameLabel setTextColor:KRGB(30, 144, 255, 1.0)];
    [self addSubview:self.nameLabel];
//    [self.nameLabel setBackgroundColor:[UIColor greenColor]];
    
    
    self.contentLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), CGRectGetMaxY(self.sendNameLabel.frame)+10,KscreenWidth-CGRectGetMaxX(self.nameLabel.frame), 20*Height)];
    
    [self.contentLabel setTextColor:[UIColor blackColor]];
    [self.contentLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.contentLabel];
//    [self.contentLabel setBackgroundColor:[UIColor orangeColor]];
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sendNameLabel.frame.origin.x, CGRectGetMaxY(self.contentLabel.frame)+10, self.contentLabel.frame.size.width, 20*Height)];
    [self.timeLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:15]];
    [self addSubview:self.timeLabel];
//    [self.timeLabel setBackgroundColor:[UIColor cyanColor]];
    
//    self.replayLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.sendNameLabel.frame.origin.x, CGRectGetMaxY(self.timeLabel.frame)+5, KscreenWidth-self.headImageView.frame.size.width-40*Height, 25*Height)];
//    [self.replayLabel setBackgroundColor:KRGB(240, 240, 240, 0.5)];
//    [self.replayLabel setTextColor:KRGB(153, 153, 153, 1.0)];
//    [self.replayLabel setNumberOfLines:0];
//    [self.replayLabel setFont:[UIFont systemFontOfSize:15]];
//    [self.replayLabel.layer setCornerRadius:2];
//    [self.replayLabel.layer setMasksToBounds:YES];
//    [self addSubview:self.replayLabel];
////    [self.replayLabel setBackgroundColor:[UIColor brownColor]];
//    
//    self.FS_cellBottomView =self.replayLabel;

    
    
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
