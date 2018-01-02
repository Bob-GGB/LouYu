//
//  TransitionAnimation.h
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.

//

@import UIKit;

@interface TransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTargetEdge:(UIRectEdge)targetEdge;

@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end
