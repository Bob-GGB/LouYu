//
//  PersonnelTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/2.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PersonnelTableViewCell.h"

@implementation PersonnelTableViewCell


-(void)bindDataWithModel:(UserListModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImgUrl]];
    self.nameLabel.text=model.userName;


}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatAllView];
    }
    return self;
}


-(void)creatAllView{
    self.headImageView =[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30*Width, 30*Height)];
    self.headImageView.layer.masksToBounds=YES;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    [self addSubview:self.headImageView];
    
    self.nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(KscreenWidth/2-80*Width, 10, 80*Width, 30*Height)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.nameLabel setTextColor:KRGB(134, 136, 148, 1.0)];
    [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.nameLabel];
    
    self.selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setFrame:CGRectMake(KscreenWidth-50*Width, 10, 40*Width, 30*Height)];
//    self.selectButton.selected=YES;
    //[self.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
   // [self.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(selectButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectButton];
    



}

-(void)selectButtonDidPress:(UIButton *)sender{

//    sender.selected=!self.selected;
    self.isSelect = !self.isSelect;
    if (self.qhxSelectBlock) {
        self.qhxSelectBlock(self.isSelect,sender.tag);
    }
        

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
