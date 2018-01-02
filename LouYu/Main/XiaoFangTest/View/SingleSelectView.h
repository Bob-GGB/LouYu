//
//  SingleSelectView.h
//  Exam
//
//  Created by barby on 2017/8/7.
//  Copyright © 2017年 barby. All rights reserved.//

#import <UIKit/UIKit.h>

typedef void(^SingleSelectActionBlock)(NSIndexPath *seleIndexPath, NSInteger btnTag ,NSNumber *questionId);

@interface SingleSelectView : UIView

@property (copy, nonatomic) SingleSelectActionBlock SingleSelectBlock;

@property (strong, nonatomic) NSString    *seleIndexStr;

@property (strong, nonatomic) NSIndexPath *seleIndexPath;






- (instancetype)initWithTypeId:(NSNumber *)typeID;

@end
