//
//  ButtonView.h
//  LouYu
//
//  Created by barby on 2017/7/26.
//  Copyright © 2017年 barby. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ButtonView : UITableViewCell

@property(nonatomic,strong)NSNumber *typeIDNum;
@property(nonatomic,copy)NSString *typeNameStr;
@property (nonatomic , strong) void(^sendController)(UIViewController * controller);
@end
