//
//  Const.h
//  SettingControllerDemo
//
//  Created by  on 15/9/23.
//  Copyright © 2015年 . All rights reserved.
//

#ifndef Const_h
#define Const_h


#define MakeColorWithRGB(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
//获取屏幕尺寸
//#define ScreenWidth      [UIScreen mainScreen].bounds.size.width
//#define ScreenHeight     [UIScreen mainScreen].bounds.size.height
#define ScreenBounds     [UIScreen mainScreen].bounds


//功能图片到左边界的距离
#define FuncImgToLeftGap 15

//功能名称字体
#define FuncLabelFont 16

//功能名称到功能图片的距离,当功能图片funcImg不存在时,等于到左边界的距离
#define FuncLabelToFuncImgGap 15

//指示箭头或开关到右边界的距离
#define IndicatorToRightGap 15

//详情文字字体
#define DetailLabelFont 15

//详情到指示箭头或开关的距离
#define DetailViewToIndicatorGap 13

#endif /* Const_h */
