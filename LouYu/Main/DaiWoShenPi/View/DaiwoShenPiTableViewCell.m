//
//  DaiwoShenPiTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/22.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "DaiwoShenPiTableViewCell.h"

@implementation DaiwoShenPiTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


-(void)bindDataWithModel:(warnStatusModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.titileLabel.text=model.title;
    self.timeLabel.text=model.addtime;
    self.statusLabel.text=model.statusText;
    self.typeLabel.text=[NSString stringWithFormat:@"类型：%@",model.type];
    self.placeLabel.text=[NSString stringWithFormat:@"地点：%@",model.placeName];


}

-(void)senderDataWithModel:(WorkListModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.titileLabel.text=model.title;
    self.timeLabel.text=model.addtime;
    self.statusLabel.text=model.statustext;
    self.typeLabel.text=[NSString stringWithFormat:@"类型：%@",model.typeName];
    self.placeLabel.text=[NSString stringWithFormat:@"地点：%@",model.placeName];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setUpUI];
        [AtuoFillScreenUtils autoLayoutFillScreen:self];
    }
    
    return self;
}

-(void)setUpUI{
    UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KscreenWidth, 10)];
    [lineView setBackgroundColor:KRGB(220, 220, 220, 0.5)];
    [self.contentView addSubview:lineView];
    
    self.headImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineView.frame)+10, 40, 40)];
    self.headImageView.clipsToBounds=YES;
    self.headImageView.layer.cornerRadius=20;
    //[self.headImageView setBackgroundColor:[UIColor redColor]];
    [self.contentView addSubview:self.headImageView];
   
    self.titileLabel=[[UILabel alloc] init];
     [self.titileLabel setFont:[UIFont systemFontOfSize:16.0f]];
                      //WithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, 20,200, 32)];
    NSString *str=@"张武柳发起的故障上报";
    CGSize size = [str boundingRectWithSize:CGSizeMake(300, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.titileLabel.font} context:nil].size;
    self.titileLabel.frame=CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, 20,size.width, 20);
    [self.titileLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.titileLabel setNumberOfLines:0];
   // [self.titileLabel setText:@"哈哈哈傻傻的快乐撒开发的撒哈哈哈"];
    [self.contentView addSubview:self.titileLabel];
    
    self.typeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.titileLabel.frame.origin.x, CGRectGetMaxY(self.titileLabel.frame)+5, 150, 18)];
    [self.typeLabel setTextColor:KRGB(117, 117, 117, 1.0)];
    [self.typeLabel setFont:[UIFont systemFontOfSize:14.0f]];
   // [self.typeLabel setText:@"类型：故障上报"];
    [self.contentView addSubview:self.typeLabel];
    
    self.placeLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.titileLabel.frame.origin.x, CGRectGetMaxY(self.typeLabel.frame)+5, 250, 18)];
    [self.placeLabel setTextColor:KRGB(117, 117, 117, 1.0)];
    [self.placeLabel setFont:[UIFont systemFontOfSize:14.0f]];
   // [self.placeLabel setText:@"地点：杭州大楼二层"];
    [self.contentView addSubview:self.placeLabel];
    
    self.statusLabel=[[UILabel alloc] initWithFrame:CGRectMake(self.titileLabel.frame.origin.x, CGRectGetMaxY(self.placeLabel.frame)+5, 100, 18)];
    [self.statusLabel setTextColor:KRGB(104, 173, 255, 1.0)];
    [self.statusLabel setFont:[UIFont systemFontOfSize:14.0f]];
    //[self.statusLabel setText:@"待处理"];
    [self.contentView addSubview:self.statusLabel];
    
    self.timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titileLabel.frame)+20,self.titileLabel.frame.origin.y,100,20)];
    [self.timeLabel setTextColor:KRGB(117, 117, 117, 1.0)];
    [self.timeLabel setFont:[UIFont systemFontOfSize:13.0f]];
    //[self.timeLabel setText:@"2017.06.06"];
    [self.contentView addSubview:self.timeLabel];

    

    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
