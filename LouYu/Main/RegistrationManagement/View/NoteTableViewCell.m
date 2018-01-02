//
//  NoteTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/7/28.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NoteTableViewCell.h"
#import "NSString+Extension.h"
@implementation NoteTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpAllView];
    }
    return self;
    
}

-(void)setUpAllView{
    
    self.miaoshulabel =[[UILabel alloc] init];
                        //WithFrame:CGRectMake(5, self.noteLabel.frame.size.width/2, 80, 20)];
    [self.miaoshulabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.miaoshulabel setFont:[UIFont systemFontOfSize:16.0f]];
    [self.miaoshulabel setText:@"备注"];
    [self addSubview:self.miaoshulabel];
    
    self.noteLabel =[[UILabel alloc] init];
                     //WithFrame:CGRectMake(CGRectGetMaxX(self.miaoshulabel.frame)+20, 10,  KscreenWidth-self.miaoshulabel.frame.size.width-10-20, 100)];
    [self.noteLabel setTextColor:KRGB(51, 51, 51, 1.0)];
    [self.noteLabel setNumberOfLines:0];
    [self.noteLabel setFont:[UIFont systemFontOfSize:15.0f]];
    [self addSubview:self.noteLabel];
    
    
    
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
    
    //self.textDescriptionLabel.frame = CGRectMake(CGRectGetMaxX(self.descripLabel.frame)+20, 10, KscreenWidth-self.descripLabel.frame.size.width-10-20, 100);
    CGFloat LabelWidth = KscreenWidth-80-10-20; // 限制宽度
   
    // 根据实际内容，返回高度，
    CGSize LabelSize = [self.noteLabel.text sizeWithLabelWidth:LabelWidth font:[UIFont systemFontOfSize:15]];
    
     self.miaoshulabel.frame = CGRectMake(5, LabelSize.height/2, 80, 20);
    self.noteLabel.frame = CGRectMake(CGRectGetMaxX(self.miaoshulabel.frame)+20, 10, LabelWidth, LabelSize.height);
    
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
