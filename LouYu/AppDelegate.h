//
//  AppDelegate.h
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 *  定义宽高比例系数属性
 */
@property (nonatomic,assign) float autoSizeScaleX;

@property (nonatomic,assign) float autoSizeScaleY;

@end

