//
//  SettingSectionModel.h
//  xiu8iOS
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SettingSectionModel : NSObject
@property (nonatomic,copy) NSString  *sectionHeaderName; /**< 传空表示分组无名称*/

@property (nonatomic,assign) CGFloat  sectionHeaderHeight; /**<      分组header高度*/

@property (nonatomic,strong) NSArray  *itemArray; /**< item模型数组*/

@property (nonatomic,strong) UIColor  *sectionHeaderBgColor; /**< 背景色*/

@end
