//
//  MyExamTableViewCell.m
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import "MyExamTableViewCell.h"



#import "UIButton+BackgroundColor.h"

@interface MyExamTableViewCell ()

@property (strong, nonatomic) UIButton *selectedBtn;

@end

@implementation MyExamTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
    }
    return self;
}

- (void)initView {

    [self.contentView addSubview:self.selectedBtn];
    [self.contentView addSubview:self.textNameLabel];
}

- (UIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedBtn.frame              = CGRectMake(20, 8, 30, 30);
        _selectedBtn.titleLabel.font    = [UIFont systemFontOfSize:14.0];
        _selectedBtn.layer.cornerRadius = 15;
        _selectedBtn.layer.borderWidth  = 1;
        _selectedBtn.layer.borderColor  = ZmjColor(153, 153, 153).CGColor;
        _selectedBtn.clipsToBounds      = YES;
        _selectedBtn.selected=NO;
        [_selectedBtn      setTitleColor:ZmjColor(153, 153, 153) forState:UIControlStateNormal];
        [_selectedBtn      setTitleColor:ZmjColor(104, 173, 255) forState:UIControlStateSelected];
        [_selectedBtn addTarget:self action:@selector(selectButtonDidPress:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedBtn;
}

-(UILabel *)textNameLabel{

    if (!_textNameLabel) {
        
        _textNameLabel =[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_selectedBtn.frame)+10, _selectedBtn.frame.origin.y-5, (KscreenWidth-100)*Width, 35)];
        _textNameLabel.font=[UIFont systemFontOfSize:14.0];
        _textNameLabel.numberOfLines=0;
    
    }
    return _textNameLabel;
}

-(void)selectButtonDidPress:(UIButton *)sender{

    
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
