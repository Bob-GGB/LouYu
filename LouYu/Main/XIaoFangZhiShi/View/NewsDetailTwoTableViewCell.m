//
//  NewsDetailTwoTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NewsDetailTwoTableViewCell.h"
#import "UITableViewCell+FSAutoCountHeight.h"
@implementation NewsDetailTwoTableViewCell


-(void)sendDataWithContentListModel:(ContentListModel *)model{
    self.titleLabel.text=model.text;
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:model.photo]];


}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
         [AtuoFillScreenUtils autoLayoutFillScreen:self];
        self.titleLabel=[[UILabel alloc]init];
        //WithFrame:CGRectMake(10, 10, KscreenWidth-20, 150)];
        [self.titleLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [self.titleLabel setTextColor:KRGB(51, 51, 51, 1.0f)];
        [self.titleLabel setNumberOfLines:0];
        [self.titleLabel sizeToFit];
        [self.contentView addSubview:self.titleLabel];
        
        self.newsImageView=[[UIImageView alloc] init];
        //WithFrame:CGRectMake(10, CGRectGetMaxY(self.titleLabel.frame)+10, KscreenWidth-20, 200)];
        [self.newsImageView sizeToFit];
        //图片等比例缩放，防止图片拉伸变形
        [self.newsImageView setContentMode:UIViewContentModeScaleAspectFill];
        self.newsImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.newsImageView];
        
        
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).with.offset(10);
                make.left.equalTo(self.contentView.mas_left).with.offset(10);
                make.right.lessThanOrEqualTo(self.contentView.mas_right).with.offset(-10);
            }];
            
            [self.newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.titleLabel.mas_bottom).with.offset(10);
                make.left.mas_equalTo(self.titleLabel);
                make.right.mas_equalTo(self.titleLabel);
                make.height.mas_equalTo(250*Height);
            }];
        
        

    }
    //self.FS_cellBottomView = self.newsImageView;//尽量传入底视图，不传也不会报错

    return self;
    
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
