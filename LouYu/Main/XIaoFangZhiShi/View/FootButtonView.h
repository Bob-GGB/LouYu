//
//  FootButtonView.h
//  LouYu
//
//  Created by barby on 2017/7/27.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FootButtonView : UIView
@property(nonatomic,strong)UIButton *footButton;
@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic , strong) void(^CollectBlock)(BOOL choice);

@property (nonatomic , strong) void(^sendController)(UIViewController * controller);

@property (nonatomic , strong) void(^shareBlock)(void);

-(instancetype)initWithArticleID:(NSNumber *)articleID andUserID:(NSNumber *)userID;
@end
