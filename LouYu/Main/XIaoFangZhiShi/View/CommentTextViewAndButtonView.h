//
//  CommentTextViewAndButtonView.h
//  LouYu
//
//  Created by barby on 2017/8/30.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTextViewAndButtonView : UIView
@property(nonatomic,strong)UITextView *commentField;
@property(nonatomic,strong)UIButton *publishBtn;
@property (nonatomic , strong) void(^SendCommentBoclk)(NSString *content);
@end
