//
//  TextDescriptionTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "TextDescriptionTableViewCell.h"
#import "NSString+Extension.h"
@implementation TextDescriptionTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllView];
    }
    return self;
    
}

-(void)setUpAllView{
    
    self.descripLabel =[[UILabel alloc]init];
//                        initWithFrame:CGRectMake(5, 10, 150, 20)];
    [self.descripLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.descripLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.descripLabel setText:@"文字描述"];
    [self addSubview:self.descripLabel];
    
    self.textDescriptionLabel =[[UILabel alloc]init];
                                
                                //initWithFrame:CGRectMake(CGRectGetMaxX(self.descripLabel.frame)+20, 10, KscreenWidth-self.descripLabel.frame.size.width-10-20, 300)];
    [self.textDescriptionLabel setTextColor:KRGB(153, 153, 153, 1.0)];
    [self.textDescriptionLabel setNumberOfLines:0];
    [self.textDescriptionLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.textDescriptionLabel];
    
    
    
}

+ (CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object
{
    CGFloat LabelWidth = KscreenWidth-80-10-20;
    // 字符串分类提供方法，计算字符串的高度
    CGSize statusLabelSize =[object sizeWithLabelWidth:LabelWidth font:[UIFont systemFontOfSize:15]];
    return statusLabelSize.height;
}


#pragma mark - private
- (void)layoutSubviews{
    [super layoutSubviews];
    self.descripLabel.frame = CGRectMake(5, self.textDescriptionLabel.frame.size.height/2, 80, 20);
    //self.textDescriptionLabel.frame = CGRectMake(CGRectGetMaxX(self.descripLabel.frame)+20, 10, KscreenWidth-self.descripLabel.frame.size.width-10-20, 100);
    CGFloat LabelWidth = KscreenWidth-self.descripLabel.frame.size.width-10-20; // 限制宽度
    // 根据实际内容，返回高度，
    CGSize LabelSize = [self.textDescriptionLabel.text sizeWithLabelWidth:LabelWidth font:[UIFont systemFontOfSize:15]];
    self.textDescriptionLabel.frame = CGRectMake(CGRectGetMaxX(self.descripLabel.frame)+20, 10, LabelWidth, LabelSize.height);
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
