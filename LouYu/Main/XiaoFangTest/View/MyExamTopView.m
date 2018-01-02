//
//  MyExamTopView.m
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import "MyExamTopView.h"

@interface MyExamTopView ()

@property (strong, nonatomic) UILabel *subjectTypeLabel;

@property (strong, nonatomic) UILabel *subjectNumLabel;

@end

@implementation MyExamTopView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KscreenWidth, 30);
        
        [self initView];
    }
    return self;
}

- (void)initView {

    [self addSubview:self.subjectTypeLabel];
    [self addSubview:self.subjectNumLabel];
}

- (UILabel *)subjectTypeLabel {
    if (!_subjectTypeLabel) {
        _subjectTypeLabel                    = [[UILabel alloc]init];
        _subjectTypeLabel.frame              =CGRectMake(CGRectGetMaxX(self.subjectNumLabel.frame)+10, 0, (KscreenWidth - 20)-100, self.frame.size.height);
        _subjectTypeLabel.textColor          =[UIColor blackColor];
        _subjectTypeLabel.font               = [UIFont systemFontOfSize:14.0];
        _subjectTypeLabel.textAlignment      = NSTextAlignmentLeft;
    }
    return _subjectTypeLabel;
}

- (UILabel *)subjectNumLabel {
    if (!_subjectNumLabel) {
        _subjectNumLabel                    = [[UILabel alloc]init];
        _subjectNumLabel.frame              =CGRectMake(10, 0, 40, self.frame.size.height);
        _subjectNumLabel.textColor          = [UIColor blackColor];
        _subjectNumLabel.font               = [UIFont systemFontOfSize:14.0];
        _subjectNumLabel.textAlignment      = NSTextAlignmentLeft;
    }
    return _subjectNumLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
