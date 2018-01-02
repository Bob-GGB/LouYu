//
//  MyExamBoomView.m
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import "MyExamBoomView.h"



@interface MyExamBoomView ()

@end

@implementation MyExamBoomView

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        self.frame = CGRectMake(0, (KscreenHeight-200)*Height, KscreenWidth, 30);
        
        [self initView];
    }
    return self;
}

- (void)initView {
    
    NSArray *array = @[@"下一题"];
    
    for (int i = 0; i < array.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame     = CGRectMake(KscreenWidth/4, 0, KscreenWidth /2, self.frame.size.height);
        button.tag       = i + 1;
        [button setTitle:array[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button.layer setBorderColor:[UIColor blackColor].CGColor];
        [button.layer setBorderWidth:1];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (button.tag == 0) {
            
            button.enabled = NO;
        }
    }
}

- (void)buttonAction:(UIButton *)button {

    if (self.subjectBlock) {
        
        self.subjectBlock(button.tag);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
