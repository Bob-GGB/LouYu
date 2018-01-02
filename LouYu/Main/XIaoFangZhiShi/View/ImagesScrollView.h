//
//  ImagesScrollView.h
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesScrollView : UIView<UIScrollViewDelegate>


@property (nonatomic, retain) NSTimer * timer;

@property (nonatomic, retain) UIScrollView * scrollView;
@property (nonatomic, retain) UIPageControl * pageControl;
@property (nonatomic, retain) UILabel * currentPageLabel;

@property (nonatomic, retain) NSArray * dataSource;


- (id) initWithFrame:(CGRect)frame images:(NSArray *)images;

- (void) startTimer;
- (void) stopTimer;
@end
