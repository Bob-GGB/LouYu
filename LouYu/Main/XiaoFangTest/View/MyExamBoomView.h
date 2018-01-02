//
//  MyExamBoomView.h
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import <UIKit/UIKit.h>

typedef void(^subjectActionBlock)(NSInteger btnTag);

@interface MyExamBoomView : UIView

@property (copy, nonatomic) subjectActionBlock subjectBlock;

@end
