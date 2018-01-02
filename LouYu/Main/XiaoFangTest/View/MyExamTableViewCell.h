//
//  MyExamTableViewCell.h
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import <UIKit/UIKit.h>

@interface MyExamTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UIButton *selectedBtn;
@property (strong, nonatomic) UILabel  *textNameLabel;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, copy) void(^qhxSelectBlock)(BOOL choice,NSInteger btntag);
@end
