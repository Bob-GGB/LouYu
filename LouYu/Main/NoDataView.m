//
//  NoDataView.m
//  LouYu
//
//  Created by barby on 2017/8/19.
//  Copyright © 2017年 barby. All rights reserved.
//

#import "NoDataView.h"

@implementation NoDataView

-(instancetype)init{

    self=[super init];
    if (self) {
//        [self setBackgroundColor:KRGB(255, 255, 255, 1.0)];
        UIImageView *imageView   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80 )];
            [imageView setImage:[UIImage imageNamed:@"nodata"]];
        imageView.center=CGPointMake(KscreenWidth/2, KscreenHeight/2);

           imageView.clipsToBounds  = YES;
        [self addSubview:imageView];
    }
    return self;
}

@end
