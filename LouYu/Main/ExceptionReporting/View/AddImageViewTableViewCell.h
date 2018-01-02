//
//  AddImageViewTableViewCell.h
//  LouYu
//
//  Created by barby on 2017/8/3.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddImageViewTableViewCell : UITableViewCell
@property (strong, nonatomic)  UIImageView *imageIcon;
@property (strong, nonatomic)  UIImageView *imageRectangle;
@property (strong, nonatomic)  UIImageView *imageRectangle1;
@property(nonatomic,strong) NSMutableArray *imageDaraArr;
@property (nonatomic , strong) void(^sendController)(UIViewController * controller);
@end
