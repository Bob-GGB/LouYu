//
//  PlaceTableViewCell.m
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "PlaceTableViewCell.h"

@implementation PlaceTableViewCell

-(void)bindDataWithModel:(CompanyListModel *)model{
    self.nameLabel.text=model.companyName;

}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self creatAllView];
    }
    return self;
}

-(void)creatAllView{
    
    self.nameLabel =[[UILabel alloc] initWithFrame:CGRectMake(10,5, KscreenWidth-100, 30)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.nameLabel setTextColor:KRGB(134, 136, 148, 1.0)];
   // [self.nameLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:self.nameLabel];
    
    self.selectButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [self.selectButton setFrame:CGRectMake(KscreenWidth-50, 5, 40, 30)];
    //    self.selectButton.selected=YES;
//    [self.selectButton setImage:[UIImage imageNamed:@"btn_selected.png"] forState:UIControlStateSelected];
//     [self.selectButton setImage:[UIImage imageNamed:@"btn_normal.png"] forState:UIControlStateNormal];
    [self.selectButton addTarget:self action:@selector(selectButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.selectButton];
    
    
    
    
}

-(void)selectButtonDidPress:(UIButton *)sender{
    
    [self.xlDelegate handleSelectedButtonActionWithSelectedIndexPath:self.selectedIndexPath];
    
    
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
