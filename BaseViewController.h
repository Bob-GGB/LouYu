//
//  BaseViewController.h
//  LouYu
//
//  Created by barby on 2017/7/14.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//在基类里面生成四个方法,方便创建导航栏的按钮
@property (nonatomic,strong) UIButton *rightBarButtons;
//设置导航栏左侧按钮的
-(void)setLeftBarButtonItemWithImageName:(NSString *)name andTitle:(NSString *)title;
//设置导航栏左侧按钮的点击事件
-(void)leftBarButtonDidPress:(UIButton *)sender;

//设置导航栏右侧按钮的
-(void)setrightBarButtonItemWithImageName:(NSString *)name andTitle:(NSString *)title;
//设置导航栏右侧按钮的点击事件
-(void)rightBarButtonDidPress:(UIButton *)sender;

@end
