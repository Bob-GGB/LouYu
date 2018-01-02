//
//  MyExamHeaderView.m
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "MyExamHeaderView.h"



@interface MyExamHeaderView ()

@property (strong, nonatomic) UILabel *subjectLabel;

@end

@implementation MyExamHeaderView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, KscreenWidth, 50*Height);
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
    }
    return self;
}

- (void)initView {
    
    [self addSubview:self.subjectLabel];
}

- (UILabel *)subjectLabel {
    if (!_subjectLabel) {
        _subjectLabel               = [[UILabel alloc]init];
        _subjectLabel.frame         = CGRectMake(10, 0, self.frame.size.width - 15, self.frame.size.height);
        _subjectLabel.textColor     = [UIColor blackColor];
        _subjectLabel.font          = [UIFont systemFontOfSize:15.0];
        _subjectLabel.textAlignment = NSTextAlignmentLeft;
        
        _subjectLabel.numberOfLines = 0;
    }
    return _subjectLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
