//
//  NSString+Extension.h
//  DouBeDemo
//
//  Created by gaolili on 16/5/4.
//  Copyright © 2016年 mRocker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)


/**
 *  简单计算textsize
 *
 *  @param width 传入特定的宽度
 *  @param font  字体
 */
- (CGSize)sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font;
- (CGSize)sizeWithImageWidth:(CGFloat)width imageView:(UIImageView *)imageView;

@end
