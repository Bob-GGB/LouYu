//
//  NewTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/17.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NewTableViewCell.h"

@implementation NewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)bindDataWithModel:(indexArticleListModel *)model{
    self.NewtitleLable.text=model.title;
    [self.NewImageView sd_setImageWithURL:[NSURL URLWithString:model.photo]];
    self.NewtimeLable.text=model.addtime;


}
-(void)sendDataWithModel:(CollectionListModel *)model{
    
    self.NewtitleLable.text=model.title;
    self.NewtimeLable.text=model.addtime;
    [self.NewImageView sd_setImageWithURL:[NSURL URLWithString:model.photo]];
}


-(void)CallDataWithModel:(RelatedForMe_NewsListModel *)model{

    self.NewtitleLable.text=model.title;
    self.NewtimeLable.text=model.addtime;
    [self.NewImageView sd_setImageWithURL:[NSURL URLWithString:model.articlePhoto]];

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createAllView];
    }
    
    return self;
}

-(void)createAllView{
       self.NewImageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 110*Width, 84*Height)];
    //[self.NewImageView setBackgroundColor:[UIColor redColor]];
    [self addSubview:self.NewImageView];
    
    self.NewtitleLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.NewImageView.frame)+10, 15, KscreenWidth-self.NewImageView.frame.size.width-30*Width, 45*Height)];
    [self.NewtitleLable setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.NewtitleLable setFont:[UIFont systemFontOfSize:16.0f]];
    [self.NewtitleLable setNumberOfLines:0];
    //[self.NewtitleLable setText:@"哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒哈哈哈傻傻的快乐撒开发的撒"];
    [self addSubview:self.NewtitleLable];
    
    self.NewtimeLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.NewImageView.frame)+10, CGRectGetMaxY(self.NewtitleLable.frame)+15, self.frame.size.width-self.NewImageView.frame.size.width-20, 14)];
    [self.NewtimeLable setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.NewtimeLable setFont:[UIFont systemFontOfSize:13.0f]];
    // [self.NewtimeLable setText:@"2017-7-9 9:11"];
    
    [self addSubview:self.NewtimeLable];


}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
