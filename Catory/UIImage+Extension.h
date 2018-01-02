//
//  UIImage+Extension.h
//  DouBeDemo
//
//  Created by gaolili on 16/5/4.
//  Copyright © 2016年 mRocker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

// 圆角图片
- (UIImage *)clipImageWithRadius:(CGFloat)radius;

- (UIImage *)createImageWithColor:(UIColor *)color;

//根据颜色返回图片
+ (UIImage *)imageWithColor:(UIColor *)color;

//获取网络图片
+ (UIImage *)imageWithUrlString:(NSString *)urlString;


@end
