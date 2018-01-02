//
//  ImagesScrollView.m
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "ImagesScrollView.h"

@implementation ImagesScrollView

- (id) initWithFrame:(CGRect)frame images:(NSArray *)images {
    if (self = [super initWithFrame:frame]) {
         [AtuoFillScreenUtils autoLayoutFillScreen:self];
        self.dataSource = images;
        // 1. 初始化定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(loopImageTimer:) userInfo:nil repeats:YES];
        //[timer setFireDate:[NSDate distantFuture]];
        
        CGFloat viewWidth = CGRectGetWidth(self.frame);
        CGFloat viewHeigh = CGRectGetHeight(self.frame);
        NSUInteger pageCount = images.count;
        
        // 2. 初始化UIScrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeigh)];
        _scrollView.contentSize = CGSizeMake(viewWidth * pageCount, viewHeigh);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        for (int i = 0; i < images.count; i++) {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth * i, 0, viewWidth, viewHeigh)];
//            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [UIImage imageNamed:images[i]];
            imageView.tag = i;
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loopImageOnClicked:)];
            [imageView addGestureRecognizer:tap];
            
            [_scrollView addSubview:imageView];
        }
        
        [self addSubview:_scrollView];
        
        if (images.count > 1) {
            // 3. 初始化UIPageControl
            int pageControllHeight = 30;
            CGFloat scrollViewBottom = _scrollView.frame.origin.y + _scrollView.frame.size.height;
            _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(viewWidth - 100, scrollViewBottom - pageControllHeight, 100, pageControllHeight)];
            [_pageControl setBackgroundColor:[UIColor clearColor]];
            //设置当前页小球的颜色
            [_pageControl setCurrentPageIndicatorTintColor:[UIColor greenColor]];
            //设置剩余页小球颜色
            [_pageControl setPageIndicatorTintColor:[UIColor whiteColor]];
            _pageControl.currentPage = 0;
            _pageControl.numberOfPages = pageCount;

            [self addSubview:_pageControl];
            
            // 4. 初始化 当前页/总页数
            _currentPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _pageControl.frame.origin.y, 50, pageControllHeight)];
            _currentPageLabel.text = [NSString stringWithFormat:@"%d/%ld", 1, (unsigned long)images.count];
            [self addSubview:_currentPageLabel];
        }
    }
    
    return self;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isMemberOfClass:[UITableView class]]) {
        
    }else {
        int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;   //当前是第几个视图
        _pageControl.currentPage = index;
        
        _currentPageLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (unsigned long)self.dataSource.count];
    }
}


#pragma mark -
#pragma mark - Actions
- (void) loopImageTimer:(NSTimer *)timer {
    NSUInteger totalNum = self.dataSource.count;
    if (totalNum > 1) {
        CGPoint newOffset = _scrollView.contentOffset;
        newOffset.x = newOffset.x + CGRectGetWidth(_scrollView.frame);
        if (newOffset.x > (CGRectGetWidth(_scrollView.frame) * (totalNum-1))) {
            newOffset.x = 0 ;
        }
        int index = newOffset.x / CGRectGetWidth(_scrollView.frame);   //当前是第几个视图
        newOffset.x = index * CGRectGetWidth(_scrollView.frame);
        
        _pageControl.currentPage = index;
        _currentPageLabel.text = [NSString stringWithFormat:@"%d / %ld",index+1, (unsigned long)totalNum];
        [_scrollView setContentOffset:newOffset animated:YES];
    }else{
        [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    }
}


- (void) loopImageOnClicked:(UITapGestureRecognizer *) tapGestureRecognizer{
    NSInteger imageViewTag = tapGestureRecognizer.view.tag;
    NSLog(@"imageViewTag: ----------------- %ld", (long)imageViewTag);        // 0, 1, 2
    
}


#pragma mark -
#pragma mark - Methods
- (void) startTimer {
    [_timer setFireDate:[NSDate distantPast]];
}

- (void) stopTimer {
    [_timer setFireDate:[NSDate distantFuture]];
}

@end
